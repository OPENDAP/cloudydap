#!/bin/bash
# Copyright (C) 2016 The HDF Group
# All rights reserved.
#
# MERRA aggregation test.
# Run it on AWS EC2 instance where Hyrax server is running.
#
# https://github.com/OPENDAP/cloudydap/wiki/Trade-Study-Use-Case-6-----Simulate-NcML-JoinExisting-aggregation

# Download expected results.
curl -s https://gamma.hdfgroup.org/ftp/pub/outgoing/opendap/data/HDF5/cloudydap/merra2.tar.gz -o merra2.tar.gz
tar zxvf merra2.tar.gz

# Set path and environment variable.
cd ~/hyrax
. spath.sh

# Run aggregation script.
cd ~/cloudydap/shell/aggEmulator
rm -rf merra2
date >> test_6.log
./aggTestMerra2 S3_GATEWAY
date >> test_6.log
diff -r merra2 ../use-cases/merra2
