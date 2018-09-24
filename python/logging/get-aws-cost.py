#!/usr/bin/env python3
"""
Download AWS Cost and Usage Reports from S3.
"""
import sys
import os
import argparse
import logging
import datetime
from pathlib import Path, PurePosixPath
from urllib.parse import urlparse
import json
import boto3
import botocore.config


def current_dt():
    """Current datetime in UTC."""
    return datetime.datetime.now(datetime.timezone.utc)


parser = argparse.ArgumentParser(
    description='Download AWS Cost and Usage Reports stored in AWS S3',
    epilog='Developed under the NASA/Raytheon EED-2 Task 28 contract.',
    formatter_class=argparse.ArgumentDefaultsHelpFormatter)
parser.add_argument('--s3loc',
                    help='S3 location of the reports (s3://[BUCKET]/[PATH]/)',
                    default='s3://cloudydap/billing/Arch1')
parser.add_argument(
    '--to', help='Destination directory for cost reports (will be created).',
    default=Path().cwd())
dt = current_dt()
parser.add_argument('-y', '--year', type=int,
                    help='Billing report\'s year. Default: current year.',
                    default=dt.year)
parser.add_argument('-m', '--month', type=int,
                    help='Billing report\'s month. Default: current month.',
                    default=dt.month)
parser.add_argument('--aws_key', default=os.environ.get('AWS_ACCESS_KEY_ID'),
                    help='Amazon identification key. Default: from '
                    '$AWS_ACCESS_KEY_ID env. variable.')
parser.add_argument('--aws_secret',
                    default=os.environ.get('AWS_SECRET_ACCESS_KEY'),
                    help='Amazon identification key secret. Default: from '
                    '$AWS_SECRET_ACCESS_KEY env. variable.',)
parser.add_argument(
    '-d', '--delete', action='store_true', default=False,
    help='Delete all the older reports for the billing period')
parser.add_argument('--loglevel', default='info',
                    choices=['debug', 'info', 'warning'],
                    help='Logging level')
arg = parser.parse_args()

logging.basicConfig(
    format='%(asctime)s:%(levelname)s:%(filename)s:%(lineno)d:%(message)s',
    level=arg.loglevel.upper(),
    datefmt='%H:%M:%S',
    stream=sys.stderr)
lggr = logging.getLogger(__name__)

# Parse and fix up bucket and logs key prefix...
s3loc = urlparse(arg.s3loc)
s3bucket = s3loc.netloc
s3prefix = s3loc.path
if s3prefix[0] == '/':
    s3prefix = s3prefix[1:]
if s3prefix[-1] != '/':
    s3prefix += '/'
s3prefix = PurePosixPath(s3prefix)
lggr.info('S3 bucket = {}; S3 base key prefix = {}'.format(s3bucket, s3prefix))

# Compute the dates for the first day of the billing's month and its next
# month...
bill_sp = datetime.datetime(arg.year, arg.month, 1)
bill_ep = (bill_sp + datetime.timedelta(days=32)).replace(day=1)

# Directory where billing report should be downloaded to. Make one if it does
# not exist...
log_dir = Path(arg.to)
if not log_dir.exists():
    lggr.info('Creating directory for report file {}'.format(log_dir))
    log_dir.mkdir(mode=0o774, parents=True)
lggr.info('Download billing reports to directory: {}'.format(log_dir.resolve()))

# Connect to AWS and the S3 bucket...
lggr.info('Connecting to AWS')
s3 = boto3.resource('s3', 'us-east-1',
                    aws_access_key_id=arg.aws_key,
                    aws_secret_access_key=arg.aws_secret,
                    config=botocore.config.Config(
                        user_agent_extra=PurePosixPath(sys.argv[0]).name
                    ))

# Bucket key for billing report JSON locator file...
report_name = s3prefix.stem
bill_prd = bill_sp.strftime('%Y%m%d') + '-' + bill_ep.strftime('%Y%m%d')
manifest = s3prefix.joinpath(bill_prd, '{}-Manifest.json'.format(report_name))

# Get the key for the billing report from the JSON locator...
lggr.info('Getting billing manifest {}'.format(manifest))
obj = s3.Object(s3bucket, str(manifest))
info = json.loads(obj.get()['Body'].read().decode('utf-8'))

# Sanity checks...
if info['bucket'] != s3bucket:
    raise ValueError('%s: Bucket name mismatch' % info['bucket'])
elif info['reportName'] != report_name:
    raise ValueError('%s: Report name mismatch' % info['reportName'])
bill_start_period = bill_sp.strftime('%Y%m%dT000000.000Z')
bill_end_period = bill_ep.strftime('%Y%m%dT000000.000Z')
if (info['billingPeriod']['start'] != bill_start_period or
        info['billingPeriod']['end'] != bill_end_period):
    raise ValueError('Billing start and/or end period mismatch')

# Download billing reports...
if not info['reportKeys']:
    print('No report to download')
else:
    for rk in info['reportKeys']:
        dest = Path(arg.to).joinpath(
            PurePosixPath(rk).name.replace(report_name,
                                           report_name + '-' + bill_prd))
        lggr.info('Downloading report {} to {}'.format(rk, dest))
        s3.Object(s3bucket, rk).download_file(str(dest))

    if arg.delete:
        lggr.info('Deleting older billing reports...')
        # Remove all the older billing reports...
        if 'assemblyId' in info:
            flt_prfx = str(manifest.parent)
            manifest_key = str(manifest)
            b = s3.Bucket(s3bucket)
            for id in b.objects.filter(Prefix=flt_prfx):
                if (info['assemblyId'] not in PurePosixPath(id.key).parts and
                        id.key != manifest_key):
                    lggr.info('Deleting object {}'.format(id.key))
                    id.delete()
        else:
            lggr.warning('Assembly ID missing in the manifest')
