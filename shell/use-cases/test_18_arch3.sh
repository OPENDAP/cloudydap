#!/bin/bash
# Copyright (C) 2017 OPeNDAP Inc.
# All rights reserved.
#
# MERRA2 randomly positioned area subset test.


a=3;
uc=18;

# Set path and environment variable.
cd ~/hyrax
. spath.sh

cd ~/cloudydap/shell/aggEmulator
rm -rf UC$uc"_A"$a"CFT"
date >> ~/test_$uc"_arch"$a.log
./arch$a"_merra2_multivar_series" UC$uc 
date >> ~/test_$uc"_arch"$a.log



