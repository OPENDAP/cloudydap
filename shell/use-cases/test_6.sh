#!/bin/bash
# Copyright (C) 2016-2017 The HDF Group
# All rights reserved.
#
# MERRA aggregation test.
# Run it on AWS EC2 instance where Hyrax server is running.

# Set path and environment variable.
cd ~/hyrax
. spath.sh

# Run aggregation script.
cd ~/hyrax/cloudydap/shell/aggEmulator
rm -rf merra2
rm -f /tmp/getDAP_*
date >> ~/test_6_arch1.log
./arch1_aggTestMerra2 UC6
date >> ~/test_6_arch1.log
diff -r merra2 ~/arch1/merra2


