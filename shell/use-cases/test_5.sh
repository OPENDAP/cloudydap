#!/bin/bash
# Copyright (C) 2016 The HDF Group
# All rights reserved.
#
# https://github.com/OPENDAP/cloudydap/wiki/Trade-Study-Use-Case-5---FilenetCDF-output

echo 'Test AIRS netCDF-4 conversion.'
time curl -s http://52.55.197.86:8080/s3/dap/cloudydap/airs/AIRS.2015.01.01.L3.RetStd_IR001.v6.0.11.0.G15013155825.nc.h5.nc4 -o airs.nc4

# echo 'Test AIRS netCDF-4 conversion (local).'
# time curl -s http://localhost:8081/opendap/s3/dap/cloudydap/airs/AIRS.2015.01.01.L3.RetStd_IR001.v6.0.11.0.G15013155825.nc.h5.nc4 -o airs_local.nc4

# You can download the local test file from here:
# ftp://ftp.hdfgroup.uiuc.edu/pub/outgoing/opendap/data/HDF5/cloudydap/airs_local.nc4

# You'll see the difference in history attribute becuase 
# the history attribute has the origin URL value.
# 
# attribute: <history of </>> and <history of </>>
# 123 differences found
h5diff airs_local.nc4 airs.nc4

