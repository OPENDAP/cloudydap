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
rm -rf arch2/merra2
rm -f /tmp/getDAP_*
date >> ~/test_6_arch2.log
./arch2_aggTestMerra2 UC6
date >> ~/test_6_arch2.log
diff -r arch2/merra2 ~/arch2/merra2
