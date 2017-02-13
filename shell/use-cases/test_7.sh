#!/bin/bash
# Copyright (C) 2016-2017 The HDF Group
# All rights reserved.
#
# AIRS aggregation test.
# https://github.com/OPENDAP/cloudydap/wiki/Trady-Study-Use-Case-7----Simulate-NcML-JoinNew-aggreegation

# Set path and environment variable.
cd ~/hyrax
. spath.sh

# Run aggregation script.
cd ~/hyrax/cloudydap/shell/aggEmulator
rm -rf UC7_A1CFT
rm -f /tmp/getDAP_*
date >> ~/test_7_arch1.log
#./arch1_aggTestAirs UC7
./arch1_airs_agg_test_single_value UC7
date >> ~/test_7_arch1.log
diff -r UC7_A1CFT ~/arch1/airs


