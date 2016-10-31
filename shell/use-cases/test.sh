#!/bin/bash
# Copyright (C) 2016 The HDF Group
# All rights reserved.
#
# This shell script measures the performance of Hyrax server that runs on
# Amazon Web Service (EC2/S3).
#
echo 'Test AIRS DAS.'
time curl -s http://52.55.197.86:8080/s3/dap/cloudydap/airs/AIRS.2015.01.01.L3.RetStd_IR001.v6.0.11.0.G15013155825.nc.h5.das -o airs.das

echo 'Test MERRA DAS.'
time curl -s http://52.55.197.86:8080/s3/dap/cloudydap/merra2/MERRA2_400.tavgM_2d_slv_Nx.201607.nc4.das -o merra.das

echo 'Test AIRS DDS.'
time curl -s http://52.55.197.86:8080/s3/dap/cloudydap/airs/AIRS.2015.01.01.L3.RetStd_IR001.v6.0.11.0.G15013155825.nc.h5.dds -o airs.dds

echo 'Test MERRA DDS.'
time curl -s http://52.55.197.86:8080/s3/dap/cloudydap/merra2/MERRA2_400.tavgM_2d_slv_Nx.201607.nc4.dds -o merra.dds

echo 'Test AIRS DMR.'
time curl -s http://52.55.197.86:8080/s3/dap/cloudydap/airs/AIRS.2015.01.01.L3.RetStd_IR001.v6.0.11.0.G15013155825.nc.h5.dmr -o airs.dmr

echo 'Test MERRA DMR.'
time curl -s http://52.55.197.86:8080/s3/dap/cloudydap/merra2/MERRA2_400.tavgM_2d_slv_Nx.201607.nc4.dmr -o merra.dmr

echo 'Test AIRS DODS.'
time curl -s http://52.55.197.86:8080/s3/dap/cloudydap/airs/AIRS.2015.01.01.L3.RetStd_IR001.v6.0.11.0.G15013155825.nc.h5.dods\?Latitude,Longitude,Topography -o airs_d2_ll.bin

echo 'Test MERRA DODS.'
time curl -s http://52.55.197.86:8080/s3/dap/cloudydap/merra2/MERRA2_400.tavgM_2d_slv_Nx.201607.nc4.dods\?lat,lon,time,U10M -o merra_d2_ll.bin

echo 'Test AIRS DAP4.'
time curl -s http://52.55.197.86:8080/s3/dap/cloudydap/airs/AIRS.2015.01.01.L3.RetStd_IR001.v6.0.11.0.G15013155825.nc.h5.dap\?dap4.ce=Latitude\;Longitude\;Topography -o airs_d4_ll.bin

echo 'Test MERRA DAP4.'
time curl -s http://52.55.197.86:8080/s3/dap/cloudydap/merra2/MERRA2_400.tavgM_2d_slv_Nx.201607.nc4.dap\?dap4.ce=lat\;lon\;time\;U10M -o merra_d4_ll.bin


echo 'Test AIRS DODS subsetting.'
time curl -s -g http://52.55.197.86:8080/s3/dap/cloudydap/airs/AIRS.2015.01.01.L3.RetStd_IR001.v6.0.11.0.G15013155825.nc.h5.dods\?Topography\[0:20:179\]\[0:20:359\] -o airs_d2_ss.bin

echo 'Test AIRS DAP4 subsetting.'
time curl -s -g http://52.55.197.86:8080/s3/dap/cloudydap/airs/AIRS.2015.01.01.L3.RetStd_IR001.v6.0.11.0.G15013155825.nc.h5.dap\?dap4.ce=Topography\[0:20:179\]\[0:20:359\] -o airs_d4_ss.bin


echo 'Test AIRS DAS without CF.'
time curl -s http://52.20.142.186:8080/s3/dap/cloudydap/airs/AIRS.2015.01.01.L3.RetStd_IR001.v6.0.11.0.G15013155825.nc.h5.das -o airs_nocf.das

echo 'Test AIRS DDS without CF.'
time curl -s http://52.20.142.186:8080/s3/dap/cloudydap/airs/AIRS.2015.01.01.L3.RetStd_IR001.v6.0.11.0.G15013155825.nc.h5.das -o airs_nocf.dds

echo 'Test AIRS DMR without CF.'
time curl -s http://52.20.142.186:8080/s3/dap/cloudydap/airs/AIRS.2015.01.01.L3.RetStd_IR001.v6.0.11.0.G15013155825.nc.h5.das -o airs_nocf.dmr



echo 'Test AIRS netCDF-3 conversion with subsetting.'
time curl -s http://52.55.197.86:8080/s3/dap/cloudydap/airs/AIRS.2015.01.01.L3.RetStd_IR001.v6.0.11.0.G15013155825.nc.h5.nc\?Latitude,Longitude,Topography -o airs_ss.nc

echo 'Test AIRS netCDF-3 conversion.'
time curl -s http://52.55.197.86:8080/s3/dap/cloudydap/airs/AIRS.2015.01.01.L3.RetStd_IR001.v6.0.11.0.G15013155825.nc.h5.nc -o airs.nc

echo 'Test MERRA2 netCDF-3 conversion.'
time curl -s http://52.55.197.86:8080/s3/dap/cloudydap/airs/MERRA2_400.tavgM_2d_slv_Nx.201607.nc4.nc -o merra.nc

echo 'Test AIRS netCDF-4 conversion.'
time curl -s http://52.55.197.86:8080/s3/dap/cloudydap/airs/AIRS.2015.01.01.L3.RetStd_IR001.v6.0.11.0.G15013155825.nc.h5.nc4 -o airs.nc4

echo 'Test AIRS netCDF-4 conversion with subsetting.'
time curl -s http://52.55.197.86:8080/s3/dap/cloudydap/airs/AIRS.2015.01.01.L3.RetStd_IR001.v6.0.11.0.G15013155825.nc.h5.nc4\?Latitude,Longitude,Topography -o airs_ss.nc4

echo 'Test MERRA2 netCDF-4 conversion.'
time curl -s http://52.55.197.86:8080/s3/dap/cloudydap/airs/MERRA2_400.tavgM_2d_slv_Nx.201607.nc4.nc4 -o merra.nc4

echo 'Test GSSTF Grid DODS without CF.'
time curl -s -g 'http://52.20.142.186:8080/s3/dap/cloudydap/samples/GSSTFYC.3.Year.1988_2008.he5.dods?/HDFEOS/GRIDS/NCEP/Data%20Fields/SST' -o gsstf_d2.bin

echo 'Test GSSTF Grid DAP4 without CF.'
time curl -s -g  'http://52.20.142.186:8080/s3/dap/cloudydap/samples/GSSTFYC.3.Year.1988_2008.he5.dap?dap4.ce=/HDFEOS/GRIDS/NCEP/"Data%20Fields"/SST' -o gsstf_d4.bin

echo 'Test 3A GPM DODS without CF.'
time curl -s http://52.20.142.186:8080/s3/dap/cloudydap/samples/3A-MO.GPM.GMI.GRID2014R1.20140601-S000000-E235959.06.V03A.h5.dods\?/Grid/rainWater -o 3agpm_d2.bin

echo 'Test 3A GPM DAP4 without CF.'
time curl -s http://52.20.142.186:8080/s3/dap/cloudydap/samples/3A-MO.GPM.GMI.GRID2014R1.20140601-S000000-E235959.06.V03A.h5.dap\?dap4.ce=/Grid/rainWater -o 3agpm_d4.bin


