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
rm -rf arch2/airs
rm -f /tmp/getDAP_*
date >> ~/test_7_arch2.log
./arch2_aggTestAirs UC7
date >> ~/test_7_arch2.log
diff -r arch2/airs ~/arch2/airs


