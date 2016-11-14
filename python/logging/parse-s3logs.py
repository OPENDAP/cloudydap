#!/usr/bin/env python
"""
Download and parse S3 access logs from a specified S3 bucket.
"""
import sys
import argparse
from pathlib import Path, PurePosixPath
from datetime import datetime
from urllib.parse import urlparse
import csv
import boto3


def log(*msg):
    if arg.verbose:
        print(*msg)


parser = argparse.ArgumentParser(
    description='Download and parse S3 access logs',
    epilog='Developed under the NASA/Raytheon EED-2 Task 28 contract.')

parser.add_argument('s3loc',
                    help='S3 location of the logs (s3://[BUCKET]/[PATH]/)')
parser.add_argument('to',
                    help='Directory to download S3 logs to (may be created)')
parser.add_argument('csvfile', help='Output CSV file for parsed information')
parser.add_argument('aws_key', help='Amazon identification key', default=None)
parser.add_argument('aws_secret', help='Amazon identification key secret',
                    default=None)
parser.add_argument('-v', '--verbose', help='Verbose output',
                    action='store_true', default=False)
parser.add_argument('-d', '--delete', action='store_true',
                    help='Delete S3 logs after download')
arg = parser.parse_args()

# Parse and fix up bucket and logs key prefix...
s3loc = urlparse(arg.s3loc)
s3bucket = s3loc.netloc
s3prefix = s3loc.path
if s3prefix[0] == '/':
    s3prefix = s3prefix[1:]
if s3prefix[-1] != '/':
    s3prefix += '/'

log('S3 log location: bucket = {}, key prefix = {}'.format(s3bucket,
                                                           s3prefix))

# Directory where S3 logs should be downloaded to. Make one if it does not
# exist...
log_dir = Path(arg.to)
if not log_dir.exists():
    log('Creating directory for log files {}'.format(log_dir))
    log_dir.mkdir(mode=0o774, parents=True)
log('Download S3 logs to directory: {}'.format(log_dir.resolve()))

# Connect to AWS and the S3 bucket...
log('Connecting to AWS')
s3 = boto3.resource('s3', aws_access_key_id=arg.aws_key,
                    aws_secret_access_key=arg.aws_secret)
bckt = s3.Bucket(s3bucket)

# New S3 logs to parse...
new_logs = list()

# Loop over all S3 logs...
for s3logf in bckt.objects.filter(Prefix=s3prefix):
    # Local name of the S3 log file...
    local_logf = log_dir.joinpath(PurePosixPath(s3logf.key).name)

    if local_logf.exists() and local_logf.stat().st_size == s3logf.size:
        log('{} exists. Skipping.'.format(local_logf))
        continue

    # Download the S3 log file...
    log('Downloading {} to {}'.format(s3logf.key, local_logf))
    bckt.download_file(s3logf.key, str(local_logf))

    if arg.delete:
        log('Deleting {} from the bucket'.format(s3logf.key))
        bckt.Object(s3logf.key).delete()

    new_logs.append(local_logf)

log('Finished downloading {} new S3 log files'.format(len(new_logs)))
if len(new_logs) == 0:
    log('Done!')
    sys.exit()

# The CSV files to store parse S3 log data...
csvfile = Path(arg.csvfile)
if not csvfile.exists():
    columns = ['Bucket_Owner', 'Bucket', 'Time', 'Remote_IP', 'Requester',
               'Request_ID', 'Operation', 'Key', 'HTTP_method', 'Request_URI',
               'HTTP_status', 'Error_Code', 'Bytes_Sent', 'Object_Size',
               'Total_Time_ms', 'Turn_Around_Time_ms', 'Referrer',
               'User_Agent', 'Version_Id']
    with csvfile.open('w', newline='') as f:
        csv.writer(f).writerow(columns)
log('Store parsed log information in the CSV file: {}'
    .format(csvfile.resolve()))

# Parse the access info in the new log files...
for l in new_logs:
    log_entries = []
    with l.open(mode='r') as f:
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

    if log_entries:
        with csvfile.open('a', newline='') as f:
            w = csv.writer(f)
            w.writerows(log_entries)

log('Done!')
