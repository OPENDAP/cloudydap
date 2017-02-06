#!/bin/bash
# Copyright (C) 2017 The HDF Group
# All rights reserved.
#
# AIRS aggregation test.
# https://github.com/OPENDAP/cloudydap/wiki/Trady-Study-Use-Case-7----Simulate-NcML-JoinNew-aggreegation

# Set path and environment variable.
cd ~/hyrax
. spath.sh

# Run aggregation script.
cd ~/hyrax/cloudydap/shell/aggEmulator
rm -rf arch3/airs
rm -f /tmp/getDAP_*
date >> test_7_arch3.log
./arch3_aggTestAirs UC7
date >> test_7_arch3.log
diff -r arch3/airs ~/arch3/airs
