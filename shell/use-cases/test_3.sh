#!/bin/bash
# Copyright (C) 2016 The HDF Group
# All rights reserved.
#
# https://github.com/OPENDAP/cloudydap/wiki/Trade-Study-Use-Case-3---DAP2-with-the-default-option
#
echo 'Test AIRS DAS without CF.'
time curl -s http://52.20.142.186:8080/s3/dap/cloudydap/airs/AIRS.2015.01.01.L3.RetStd_IR001.v6.0.11.0.G15013155825.nc.h5.das -o airs_def.das

echo 'Test AIRS DDS without CF.'
time curl -s http://52.20.142.186:8080/s3/dap/cloudydap/airs/AIRS.2015.01.01.L3.RetStd_IR001.v6.0.11.0.G15013155825.nc.h5.dds -o airs_def.dds

echo 'Test AIRS DODS without CF.'
time curl -s http://52.20.142.186:8080/s3/dap/cloudydap/airs/AIRS.2015.01.01.L3.RetStd_IR001.v6.0.11.0.G15013155825.nc.h5.dods\?/Latitude,/Longitude,/Topography -o airs_d2_ll_def.bin


echo 'Test AIRS DODS subsetting without CF.'
time curl -s -g http://52.20.142.186:8080/s3/dap/cloudydap/airs/AIRS.2015.01.01.L3.RetStd_IR001.v6.0.11.0.G15013155825.nc.h5.dods\?/Topography\[0:20:179\]\[0:20:359\] -o airs_d2_ss_def.bin

# echo 'Test AIRS DAS without CF (local).'
# time curl -s http://localhost:8081/opendap/s3/dap/cloudydap/airs/AIRS.2015.01.01.L3.RetStd_IR001.v6.0.11.0.G15013155825.nc.h5.das -o airs_local_def.das

# echo 'Test AIRS DDS without CF (local).'
# time curl -s http://localhost:8081/opendap/s3/dap/cloudydap/airs/AIRS.2015.01.01.L3.RetStd_IR001.v6.0.11.0.G15013155825.nc.h5.dds -o airs_local_def.dds

# echo 'Test AIRS DODS without CF (local).'
# time curl -s http://localhost:8081/opendap/s3/dap/cloudydap/airs/AIRS.2015.01.01.L3.RetStd_IR001.v6.0.11.0.G15013155825.nc.h5.dods\?/Latitude,/Longitude,/Topography -o airs_local_d2_ll_def.bin

# echo 'Test AIRS DODS without CF subsetting (local).'
# time curl -s -g http://localhost:8081/opendap/s3/dap/cloudydap/airs/AIRS.2015.01.01.L3.RetStd_IR001.v6.0.11.0.G15013155825.nc.h5.dods\?/Topography\[0:20:179\]\[0:20:359\] -o airs_local_d2_ss_def.bin

diff airs_local_def.das airs_def.das
diff airs_local_def.dds airs_def.dds
diff airs_local_d2_ll_def.bin airs_d2_ll_def.bin
diff airs_local_d2_ss_def.bin airs_d2_ss_def.bin
