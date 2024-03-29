#!/bin/bash
# Copyright (C) 2016-2017 The HDF Group
# All rights reserved.
#
# AIRS aggregation test.
# https://github.com/OPENDAP/cloudydap/wiki/Trady-Study-Use-Case-7----Simulate-NcML-JoinNew-aggreegation

a=2;
uc=15;

# Set path and environment variable.
cd ~/hyrax
. spath.sh

# Run aggregation script.
cd ~/cloudydap/shell/aggEmulator
rm -rf UC$uc"_A"$a"CFT"
rm -f /tmp/getDAP_*
date >> ~/test_$uc"_arch"$a.log
for i in {1..10}
do
    ./arch$a"_airs_agg_test_random_subset" UC$uc
done 
date >> ~/test_$uc"_arch"$a.log
diff -r UC$uc"_A"$a"CFT" ~/arch$a/uc$uc


