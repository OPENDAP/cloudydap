#!/bin/bash
# Copyright (C) 2016 The HDF Group
# All rights reserved.
#
# https://github.com/OPENDAP/cloudydap/wiki/Trade-Study-Use-Case-1---DAP2-with-CF
#
echo 'Test AIRS DAS.'
time curl -s http://52.55.197.86:8080/s3/dap/cloudydap/airs/AIRS.2015.01.01.L3.RetStd_IR001.v6.0.11.0.G15013155825.nc.h5.das -o airs.das

echo 'Test AIRS DDS.'
time curl -s http://52.55.197.86:8080/s3/dap/cloudydap/airs/AIRS.2015.01.01.L3.RetStd_IR001.v6.0.11.0.G15013155825.nc.h5.dds -o airs.dds

echo 'Test AIRS DODS.'
time curl -s http://52.55.197.86:8080/s3/dap/cloudydap/airs/AIRS.2015.01.01.L3.RetStd_IR001.v6.0.11.0.G15013155825.nc.h5.dods\?Latitude,Longitude,Topography -o airs_d2_ll.bin


echo 'Test AIRS DODS subsetting.'
time curl -s -g http://52.55.197.86:8080/s3/dap/cloudydap/airs/AIRS.2015.01.01.L3.RetStd_IR001.v6.0.11.0.G15013155825.nc.h5.dods\?Topography\[0:20:179\]\[0:20:359\] -o airs_d2_ss.bin

# echo 'Test AIRS DAS (local).'
# time curl -s http://localhost:8081/opendap/s3/dap/cloudydap/airs/AIRS.2015.01.01.L3.RetStd_IR001.v6.0.11.0.G15013155825.nc.h5.das -o airs_local.das

# echo 'Test AIRS DDS (local).'
# time curl -s http://localhost:8081/opendap/s3/dap/cloudydap/airs/AIRS.2015.01.01.L3.RetStd_IR001.v6.0.11.0.G15013155825.nc.h5.dds -o airs_local.dds

# echo 'Test AIRS DODS (local).'
# time curl -s http://localhost:8081/opendap/s3/dap/cloudydap/airs/AIRS.2015.01.01.L3.RetStd_IR001.v6.0.11.0.G15013155825.nc.h5.dods\?Latitude,Longitude,Topography -o airs_local_d2_ll.bin


# echo 'Test AIRS DODS subsetting (local).'
# time curl -s -g http://localhost:8081/opendap/s3/dap/cloudydap/airs/AIRS.2015.01.01.L3.RetStd_IR001.v6.0.11.0.G15013155825.nc.h5.dods\?Topography\[0:20:179\]\[0:20:359\] -o airs_local_d2_ss.bin

diff airs_local.das airs.das
diff airs_local.dds airs.dds
diff airs_local_d2_ll.bin airs_d2_ll.bin
diff airs_local_d2_ss.bin airs_d2_ss.bin
