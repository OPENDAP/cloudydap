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
rm -rf UC6_A3CFT
rm -f /tmp/getDAP_*
date >> ~/test_6_arch3.log
# ./arch3_aggTestMerra2 UC6
arch3_merra2_agg_test_single_value UC6
date >> ~/test_6_arch3.log
diff -r UC6_A3CFT ~/arch3/merra2
