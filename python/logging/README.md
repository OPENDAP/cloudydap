# Logging Tools

This repository directory contains software tools for downloading and parsing various log data related to Amazon Web Services (AWS) usage.

The tools are written for Python 3 (tested with Python 3.5.2).

Common features of all these tools:

* `-h`/`--help` command-line option for detailed usage explanation.
* AWS identification key and its secret can also be provided with two environment variables: `$AWS_ACCESS_KEY_ID` and `$AWS_SECRET_ACCESS_KEY`.
* `-v`/`--verbose` command-line option for runtime messages.

## S3 Access Log

`parse-s3logs.py` downloads S3 access logs and stores their information in a CSV file. Access date and time are reformatted into an ISO 8601-compatible string, all other access information is left unchanged.

The destination CSV file will be created if it does not already exist, otherwise the new access data is appended.

S3 access logs are downloaded to the specified destination directory, opened, parsed, and their data immediately added to the output CSV file. Any access log already present in the destination directory with the same size as its S3 object namesake will not be downloaded and processed again.

The `-d`/`--delete` command-line option will delete any successfully processed S3 access log from its S3 storage location. Using this option is strongly recommended for repeated incremental access log collection because it avoids the requirement to keep downloaded logs as well as reducing the overall S3 storage amount occupied by the logs.

## AWS Cost and Usage Report

`get-aws-cost.py` downloads the hourly AWS Cost and Usage reports from their S3 location. The default setting is to download the report for the current month and year but the user can supply when needed.

The `-d`/`--delete` option removes all the older copies of the report for the same billing period. This is useful because what is the latest report copy is obscured by using UUIDs as part of the reports' S3 object key. Each run of the `get-aws-cost.py -d ...` will leave only the latest report copy in S3 object store. Doing so for any previous billing period will effectively keep only the final copy of the report and make it much easier to access from the AWS web console.
