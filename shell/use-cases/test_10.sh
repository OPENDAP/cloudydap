#!/bin/bash
# Copyright (C) 2016 The HDF Group
# All rights reserved.
#
# Test GSSTF HDF-EOS5 product that doesn't have chunking and compression.
# Test DAP4.
#
echo 'Test GSSTF DMR.'
time curl -s http://52.55.197.86:8080/s3/dap/cloudydap/samples/GSSTFYC.3.Year.1988_2008.he5.dmr -o gsstf.dmr

echo 'Test GSSTF DAP4.'
time curl -s http://52.55.197.86:8080/s3/dap/cloudydap/samples/GSSTFYC.3.Year.1988_2008.he5.dap\?dap4.ce=lat\;lon\;NCEP_SST -o gsstf_d4_ll.bin

echo 'Test GSSTF DAP4 subsetting.'
time curl -s -g http://52.55.197.86:8080/s3/dap/cloudydap/samples/GSSTFYC.3.Year.1988_2008.he5.dap\?dap4.ce=lat\[0:100:719\]\;lon\[0:100:1339\]\;NCEP_SST\[0:100:719\]\[0:100:1339\] -o gsstf_d4_ss.bin

# echo 'Test GSSTF DMR (local).'
# time curl -s http://localhost:8081/opendap/s3/dap/cloudydap/samples/GSSTFYC.3.Year.1988_2008.he5.dmr -o gsstf_local.dmr

# echo 'Test GSSTF DAP4 (local).'
# time curl -s http://localhost:8081/opendap/s3/dap/cloudydap/samples/GSSTFYC.3.Year.1988_2008.he5.dap\?dap4.ce=lat\;lon\;NCEP_SST -o gsstf_local_d4_ll.bin

# echo 'Test GSSTF DAP4 subsetting (local).'
# time curl -s -g http://localhost:8081/opendap/s3/dap/cloudydap/samples/GSSTFYC.3.Year.1988_2008.he5.dap\?dap4.ce=lat\[0:100:719\]\;lon\[0:100:1339\]\;NCEP_SST\[0:100:719\]\[0:100:1339\] -o gsstf_local_d4_ss.bin

# There should be only URL name difference:
# 
# < <Dataset xmlns="http://xml.opendap.org/ns/DAP/4.0#" xml:base="http://localhost:8081/opendap/s3/dap/cloudydap/samples/GSSTFYC.3.Year.1988_2008.he5" dapVersion="4.0" dmrVersion="1.0" name="GSSTF.2015.01.01.L3.RetStd_IR001.v6.0.11.0.G15013155825.nc.h5">
# ---
# > <Dataset xmlns="http://xml.opendap.org/ns/DAP/4.0#" xml:base="http://52.55.197.86:8080/s3/dap/cloudydap/samples/GSSTFYC.3.Year.1988_2008.he5" dapVersion="4.0" dmrVersion="1.0" name="GSSTF.2015.01.01.L3.RetStd_IR001.v6.0.11.0.G15013155825.nc.h5">
diff gsstf_local.dmr gsstf.dmr
cat gsstf_d4_ll.bin | getdap4 -D -M - > gsstf_d4_ll.asc
# cat gsstf_local_d4_ll.bin | getdap4 -D -M - > gsstf_local_d4_ll.asc
diff gsstf_local_d4_ll.asc gsstf_d4_ll.asc
cat gsstf_d4_ss.bin | getdap4 -D -M - > gsstf_d4_ss.asc
# cat gsstf_local_d4_ss.bin | getdap4 -D -M - > gsstf_local_d4_ss.asc
diff gsstf_local_d4_ss.asc gsstf_d4_ss.asc
