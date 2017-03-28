# Logging and Analysis Tools

This repository directory contains software tools for downloading, parsing, and analysis of various log-related data to Amazon Web Services (AWS) usage.

The tools are written for Python 3 (tested with Python 3.5.2).

## Log Download and Parsing

Common features of these tools:

* `-h`/`--help` command-line option for detailed usage explanation.
* AWS identification key and its secret can also be provided with two environment variables: `$AWS_ACCESS_KEY_ID` and `$AWS_SECRET_ACCESS_KEY`.
* `-v`/`--verbose` command-line option for runtime messages.

### S3 Access Log

`parse-s3logs.py` downloads S3 access logs and stores their information in a CSV file. Access date and time are reformatted into an ISO 8601-compatible string, all other access information is left unchanged.

The destination CSV file will be created if it does not already exist, otherwise the new access data is appended.

S3 access logs are downloaded to the specified destination directory, opened, parsed, and their data immediately added to the output CSV file. Any access log already present in the destination directory with the same size as its S3 object namesake will not be downloaded and processed again.

The `-d`/`--delete` command-line option will delete any successfully processed S3 access log from its S3 storage location. Using this option is strongly recommended for repeated incremental access log collection because it avoids the requirement to keep downloaded logs as well as reducing the overall S3 storage amount occupied by the logs.

### AWS Cost and Usage Report

`get-aws-cost.py` downloads the hourly AWS Cost and Usage reports from their S3 location. The default setting is to download the report for the current month and year but the user can supply when needed.

The `-d`/`--delete` option removes all the older copies of the report for the same billing period. This is useful because what is the latest report copy is obscured by using UUIDs as part of the reports' S3 object key. Each run of the `get-aws-cost.py -d ...` will leave only the latest report copy in S3 object store. Doing so for any previous billing period will effectively keep only the final copy of the report and make it much easier to access from the AWS web console.

## Log Analysis

The following are [Jupyter](http://jupyter.org) notebooks developed for various analysis tasks for this project.

### [`Cloudydap_Cost_Data.ipynb`](https://github.com/OPENDAP/cloudydap/blob/master/python/logging/Cloudydap_Cost_Data.ipynb):

* Read in AWS Cost and Usage Report data from a CSV file into a `pandas` DataFrame.
* Specify use case run periods for each of the Cloudydap Architectures.
* Create a new column, named "Arch", for storing Cloudydap architecture identifiers.
* Select cost and usage data based on use case run periods and assign corresponding architecture identifiers (`A1`, `A2`, and `A3`).
* Remove all the other cost and usage data.
* Save the remaining use case cost and usage data into a CSV file.

### [`Cloudydap_Cost_Analysis.ipynb`](http://nbviewer.jupyter.org/github/OPENDAP/cloudydap/blob/master/python/logging/Cloudydap_Cost_Analysis.ipynb)

Analyzes the usage and cost data for different architectures prepared by the above notebook.

### [`AWS_Cost_and_Usage_Report_Analysis.ipynb`](http://nbviewer.jupyter.org/github/OPENDAP/cloudydap/blob/master/python/logging/AWS_Cost_and_Usage_Report_Analysis.ipynb)

Analyzes Detailed Hourly AWS Cost and Usage Report with Resource IDs and Tags. These reports are downloaded using the get-aws-cost.py command-line program developed for this project.

### [`s3log-analysis.ipynb`](http://nbviewer.jupyter.org/github/OPENDAP/cloudydap/blob/master/python/logging/s3log-analysis.ipynb)

Comprehensive analysis of S3 request (with a lot of graphs) performance from S3 access logs.
