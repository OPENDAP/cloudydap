#!/bin/bash
# Copyright (C) 2017 The HDF Group
# All rights reserved.
#
# MERRA aggregation test.
# Run it on AWS EC2 instance where Hyrax server is running.
#
# https://github.com/OPENDAP/cloudydap/wiki/Trade-Study-Use-Case-6-----Simulate-NcML-JoinExisting-aggregation

cd /home/centos/hyrax/cloudydap/shell/use-cases
# Download the expected results if you haven't downloaded them yet.
curl -s https://gamma.hdfgroup.org/ftp/pub/outgoing/opendap/data/HDF5/cloudydap/merra2.tar.gz -o merra2.tar.gz
tar zxvf merra2.tar.gz

# Set path and environment variable.
cd ~/hyrax
. spath.sh

# Run aggregation script.
cd ~/hyrax/cloudydap/shell/aggEmulator
rm -rf arch3/merra2
rm -f /tmp/getDAP_*
date >> test_6.log
./arch3_aggTestMerra2 UC6
date >> test_6.log
diff -r arch3/merra2 ../use-cases/merra2
