#!/bin/bash
# Copyright (C) 2017 The HDF Group
# All rights reserved.
#
# MERRA aggregation test.
# Run it on AWS EC2 instance where Hyrax server is running.
#
# https://github.com/OPENDAP/cloudydap/wiki/Trade-Study-Use-Case-6-----Simulate-NcML-JoinExisting-aggregation

# Set path and environment variable.
cd ~/hyrax
. spath.sh

# Run aggregation script.
cd ~/hyrax/cloudydap/shell/aggEmulator
rm -rf arch3/merra2
rm -f /tmp/getDAP_*
date >> ~/test_6_arch3.log
./arch3_aggTestMerra2 UC6
date >> ~/test_6_arch3.log
diff -r arch3/merra2 ~/arch3/merra2
