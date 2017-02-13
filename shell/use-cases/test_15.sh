#!/bin/bash
# Copyright (C) 2016-2017 The HDF Group
# All rights reserved.
#
# AIRS aggregation test.
# https://github.com/OPENDAP/cloudydap/wiki/Trady-Study-Use-Case-7----Simulate-NcML-JoinNew-aggreegation

a=1;
uc=15;

# Set path and environment variable.
cd ~/hyrax
. spath.sh

# Run aggregation script.
cd ~/hyrax/cloudydap/shell/aggEmulator
rm -rf UC$uc"_A"$a"CFT"
rm -f /tmp/getDAP_*
date >> ~/test_$uc"_arch"$a.log
./arch$a"_airs_agg_test_random_subset" UC$uc
date >> ~/test_$uc"_arch"$a.log
diff -r UC$uc"_A"$a"CFT" ~/arch$a/uc$uc


