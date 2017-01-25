#!/bin/bash
# Copyright (C) 2016 The HDF Group
# All rights reserved.
#
# AIRS aggregation test.
# https://github.com/OPENDAP/cloudydap/wiki/Trady-Study-Use-Case-7----Simulate-NcML-JoinNew-aggreegation

cd /home/centos/cloudydap/shell/use-cases

# Download expected results if you haven't downloaded them yet.
# curl -s https://gamma.hdfgroup.org/ftp/pub/outgoing/opendap/data/HDF5/cloudydap/airs.tar.gz -o airs.tar.gz
# tar zxvf airs.tar.gz

# Set path and environment variable.
cd ~/hyrax
. spath.sh

# Run aggregation script.
cd ~/cloudydap/shell/aggEmulator
rm -rf airs
rm -f /tmp/getDAP_*
date >> test_7.log
./aggTestAirs S3_GATEWAY UC7 A1CFT
date >> test_7.log
diff -r airs ../use-cases/airs


