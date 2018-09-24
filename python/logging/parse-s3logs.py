#!/usr/bin/env python3
"""
Download and parse S3 access logs from a specified S3 bucket.
"""
import os
import sys
import argparse
import logging
from pathlib import Path, PurePosixPath
from datetime import datetime
from urllib.parse import urlparse
import csv
import boto3
import botocore.config


def process_log(logf):
    """Process one S3 access log file.

    Return a list of lists where each element represents one row of the log
    file.

    logf: Path object representing an S3 log file.
    """
    log_entries = list()
    with logf.open(mode='r') as f:
        r = csv.reader(f, delimiter=' ', quotechar='"')
        for i in r:
            # 3nd and 4th field contain datetime in a weird format. Rearrange
            # to ISO 8601 string...
            i[2] = datetime.strptime(
                i[2] + ' ' + i[3], '[%d/%b/%Y:%H:%M:%S %z]'
            ).isoformat()
            del i[3]

            # Split 9th (used to be 10th) field into the HTTP method and URL
            # part...
            method, url = i[8].split(' ')[0:2]
            i[8] = method
            i.insert(9, url)

            log_entries.append(i)

    return log_entries


parser = argparse.ArgumentParser(
    description='Download and parse S3 access logs',
    epilog='Developed under the NASA/Raytheon EED-2 Task 28 contract.',
    formatter_class=argparse.ArgumentDefaultsHelpFormatter)

parser.add_argument('csvfile', help='Output CSV file for parsed information')
parser.add_argument('--s3loc',
                    help='S3 location of the reports (s3://[BUCKET]/[PATH]/)',
                    default='s3://cloudydap/logs')
parser.add_argument(
    '--to', help='Destination directory for S3 access logs (will be created).',
    default=Path().cwd())
parser.add_argument('--aws_key', default=os.environ.get('AWS_ACCESS_KEY_ID'),
                    help='Amazon identification key. Default: from '
                    '$AWS_ACCESS_KEY_ID env. variable.')
parser.add_argument('--aws_secret',
                    default=os.environ.get('AWS_SECRET_ACCESS_KEY'),
                    help='Amazon identification key secret. Default: from '
                    '$AWS_SECRET_ACCESS_KEY env. variable.')
parser.add_argument('-d', '--delete', action='store_true',
                    help='Delete S3 logs after download')
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

lggr.info(
    'S3 log location: bucket = {}, key prefix = {}'.format(s3bucket, s3prefix))

# Directory where S3 logs should be downloaded to. Make one if it does not
# exist...
log_dir = Path(arg.to)
if not log_dir.exists():
    lggr.info('Creating directory for log files {}'.format(log_dir))
    log_dir.mkdir(mode=0o774, parents=True)
lggr.info('Download S3 logs to directory: {}'.format(log_dir.resolve()))

# The CSV files to store parsed S3 log data...
csvfile = Path(arg.csvfile)
if not csvfile.exists():
    columns = ['Bucket_Owner', 'Bucket', 'Time', 'Remote_IP',
               'Requester', 'Request_ID', 'Operation', 'Key',
               'HTTP_method', 'Request_URI', 'HTTP_status',
               'Error_Code', 'Bytes_Sent', 'Object_Size',
               'Total_Time_ms', 'Turn_Around_Time_ms',
               'Referrer', 'User_Agent', 'Version_Id']
    with csvfile.open('w', newline='') as f:
        csv.writer(f).writerow(columns)
lggr.info('Store parsed log information in this CSV file: {}'
          .format(csvfile.resolve()))

# Connect to AWS and the S3 bucket...
lggr.info('Connecting to AWS')
s3 = boto3.resource('s3', 'us-east-1',
                    aws_access_key_id=arg.aws_key,
                    aws_secret_access_key=arg.aws_secret,
                    config=botocore.config.Config(
                        user_agent_extra=PurePosixPath(sys.argv[0]).name
                    ))
lggr.info('Connected to AWS: %r' % s3)
bckt = s3.Bucket(s3bucket)

# New S3 logs to parse...
new_logs = 0
failed_logs = list()

# Loop over all S3 logs...
lggr.info('Processing available S3 logs...')
for s3logf in bckt.objects.filter(Prefix=s3prefix):
    try:
        # Local name of the S3 log file...
        local_logf = log_dir.joinpath(PurePosixPath(s3logf.key).name)

        if local_logf.exists() and local_logf.stat().st_size == s3logf.size:
            lggr.info('{} exists. Skipping download.'.format(local_logf))
        else:
            # Download the S3 log file...
            lggr.info('Downloading {} to {}'.format(s3logf.key, local_logf))
            bckt.download_file(s3logf.key, str(local_logf))
            new_logs += 1

            log_entries = process_log(local_logf)

            if log_entries:
                # Write the parsed log data to output file...
                with csvfile.open('a', newline='') as f:
                    w = csv.writer(f)
                    w.writerows(log_entries)
                    f.flush()

        if arg.delete:
            try:
                lggr.info('Deleting S3 object {}'.format(s3logf.key))
                bckt.Object(s3logf.key).delete()
            except Exception as e:
                lggr.exception('Failed to delete S3 object:')
                failed_logs.append((s3logf.key, str(e)))

    except Exception as e:
        lggr.exception('There was an exception:')
        failed_logs.append((s3logf.key, str(e)))


lggr.info('Finished downloading {} new S3 log files'.format(new_logs))
if len(failed_logs):
    lggr.info('Processing of {} S3 logs failed'.format(len(failed_logs)))
    print('Failed S3 logs:')
    for l in failed_logs:
        print('Key {} Error: {}'.format(l[0], l[1]))
lggr.info('Done!')
logging.shutdown()
