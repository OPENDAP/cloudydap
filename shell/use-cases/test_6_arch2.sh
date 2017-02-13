#!/bin/bash
# Copyright (C) 2016-2017 The HDF Group
# All rights reserved.
#
# MERRA aggregation test.
# Run it on AWS EC2 instance where Hyrax server is running.
#
# Set path and environment variable.
cd ~/hyrax
. spath.sh

# Run aggregation script.
cd ~/hyrax/cloudydap/shell/aggEmulator
rm -rf UC6_A2CFT
rm -f /tmp/getDAP_*
date >> ~/test_6_arch2.log
# ./arch2_aggTestMerra2 UC6
./arch2_merra2_agg_test_single_value UC6
date >> ~/test_6_arch2.log
diff -r UC6_A2CFT ~/arch2/merra2
