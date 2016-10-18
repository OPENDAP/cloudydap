#!/bin/bash
# Copyright (C) 2016 The HDF Group
# All rights reserved.
#
# This shell script measures the performance of Hyrax server that runs on
# Amazon Web Service (EC2/S3).
#
echo 'Test AIRS DAS.'
time curl -s http://52.55.197.86:8080/s3/dap/cloudydap/airs/AIRS.2015.01.01.L3.RetStd_IR001.v6.0.11.0.G15013155825.nc.h5.das -o airs.das

echo 'Test AIRS DDS.'
time curl -s http://52.55.197.86:8080/s3/dap/cloudydap/airs/AIRS.2015.01.01.L3.RetStd_IR001.v6.0.11.0.G15013155825.nc.h5.dds -o airs.dds

echo 'Test AIRS DMR.'
time curl -s http://52.55.197.86:8080/s3/dap/cloudydap/airs/AIRS.2015.01.01.L3.RetStd_IR001.v6.0.11.0.G15013155825.nc.h5.dmr -o airs.dmr

echo 'Test AIRS DODS.'
time curl -s http://52.55.197.86:8080/s3/dap/cloudydap/airs/AIRS.2015.01.01.L3.RetStd_IR001.v6.0.11.0.G15013155825.nc.h5.dods\?Latitude,Longitude -o airs_d2_ll.bin

echo 'Test AIRS DAP4.'
time curl -s http://52.55.197.86:8080/s3/dap/cloudydap/airs/AIRS.2015.01.01.L3.RetStd_IR001.v6.0.11.0.G15013155825.nc.h5.dap\?dap4.ce=Latitude\;Longitude -o airs_d4_ll.bin

echo 'Test MERRA DODS.'
time curl -s http://52.55.197.86:8080/s3/dap/cloudydap/merra2/MERRA2_400.tavgM_2d_slv_Nx.201607.nc4.dods\?lat,lon -o merra_d2_ll.bin


echo 'Test MERRA DAP4.'
time curl -s http://52.55.197.86:8080/s3/dap/cloudydap/merra2/MERRA2_400.tavgM_2d_slv_Nx.201607.nc4.dap\?dap4.ce=lat\;lon -o merra_d4_ll.bin


echo 'Test AIRS DODS subsetting.'
time curl -s -g http://52.55.197.86:8080/s3/dap/cloudydap/airs/AIRS.2015.01.01.L3.RetStd_IR001.v6.0.11.0.G15013155825.nc.h5.dods\?Topography\[0:20:179\]\[0:20:359\] -o airs_d2_ss.bin

echo 'Test AIRS DAP4 subsetting.'
time curl -s -g http://52.55.197.86:8080/s3/dap/cloudydap/airs/AIRS.2015.01.01.L3.RetStd_IR001.v6.0.11.0.G15013155825.nc.h5.dap\?dap4.ce=Topography\[0:20:179\]\[0:20:359\] -o airs_d4_ss.bin


echo 'Test netCDF-3 conversion.'
time curl -s http://52.55.197.86:8080/s3/dap/cloudydap/airs/AIRS.2015.01.01.L3.RetStd_IR001.v6.0.11.0.G15013155825.nc.h5.nc -o AIRS.nc

echo 'Test netCDF-4 conversion.'
time curl -s http://52.55.197.86:8080/s3/dap/cloudydap/airs/AIRS.2015.01.01.L3.RetStd_IR001.v6.0.11.0.G15013155825.nc.h5.nc4 -o AIRS.nc4


echo 'Test AIRS DAS with no CF.'
time curl -s http://52.20.142.186:8080/s3/dap/cloudydap/airs/AIRS.2015.01.01.L3.RetStd_IR001.v6.0.11.0.G15013155825.nc.h5.das -o airs_nocf.das

