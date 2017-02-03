#!/bin/bash
# Copyright (C) 2017 The HDF Group
# All rights reserved.
#
# AIRS aggregation test.
# https://github.com/OPENDAP/cloudydap/wiki/Trady-Study-Use-Case-7----Simulate-NcML-JoinNew-aggreegation

cd /home/centos/hyrax/cloudydap/shell/use-cases
# Download expected results if you haven't downloaded them yet.
curl -s https://gamma.hdfgroup.org/ftp/pub/outgoing/opendap/data/HDF5/cloudydap/airs.tar.gz -o airs.tar.gz
tar zxvf airs.tar.gz

# Set path and environment variable.
cd ~/hyrax
. spath.sh

# Run aggregation script.
cd ~/hyrax/cloudydap/shell/aggEmulator
rm -rf arch3/airs
rm -f /tmp/getDAP_*
date >> test_7.log
./arch3_aggTestAirs UC7
date >> test_7.log
diff -r arch3/airs ../use-cases/airs
