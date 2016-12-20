#!/bin/bash
# Copyright (C) 2016 The HDF Group
# All rights reserved.
#
# Test GSSTF HDF-EOS5 product that doesn't have chunking and compression.
#
echo 'Test GSSTF DAS.'
time curl -s http://52.55.197.86:8080/s3/dap/cloudydap/samples/GSSTFYC.3.Year.1988_2008.he5.das -o gsstf.das

echo 'Test GSSTF DDS.'
time curl -s http://52.55.197.86:8080/s3/dap/cloudydap/samples/GSSTFYC.3.Year.1988_2008.he5.dds -o gsstf.dds

echo 'Test GSSTF DODS.'
time curl -s http://52.55.197.86:8080/s3/dap/cloudydap/samples/GSSTFYC.3.Year.1988_2008.he5.dods\?lon,lat,NCEP_SST -o gsstf_d2_ll.bin


echo 'Test GSSTF DODS subsetting.'
time curl -s -g http://52.55.197.86:8080/s3/dap/cloudydap/samples/GSSTFYC.3.Year.1988_2008.he5.dods\?lat\[0:100:719\],lon\[0:100:1339\],NCEP_SST\[0:100:719\]\[0:100:1339\] -o gsstf_d2_ss.bin

# echo 'Test GSSTF DAS (local).'
# time curl -s http://localhost:8081/opendap/s3/dap/cloudydap/samples/GSSTFYC.3.Year.1988_2008.he5.das -o gsstf_local.das

# echo 'Test GSSTF DDS (local).'
# time curl -s http://localhost:8081/opendap/s3/dap/cloudydap/samples/GSSTFYC.3.Year.1988_2008.he5.dds -o gsstf_local.dds

# echo 'Test GSSTF DODS (local).'
3 time curl -s http://localhost:8081/opendap/s3/dap/cloudydap/samples/GSSTFYC.3.Year.1988_2008.he5.dods\?lon,lat,NCEP_SST -o gsstf_local_d2_ll.bin


# echo 'Test GSSTF DODS subsetting (local).'
# time curl -s -g http://localhost:8081/opendap/s3/dap/cloudydap/samples/GSSTFYC.3.Year.1988_2008.he5.dods\?lat\[0:100:719\],lon\[0:100:1339\],NCEP_SST\[0:100:719\]\[0:100:1339\] -o gsstf_local_d2_ss.bin

diff gsstf_local.das gsstf.das
diff gsstf_local.dds gsstf.dds
diff gsstf_local_d2_ll.bin gsstf_d2_ll.bin
diff gsstf_local_d2_ss.bin gsstf_d2_ss.bin
