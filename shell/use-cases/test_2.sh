#!/bin/bash
# Copyright (C) 2016 The HDF Group
# All rights reserved.
#
# https://github.com/OPENDAP/cloudydap/wiki/Trade-Study-Use-Case-2---DAP4-with-CF
#
echo 'Test AIRS DMR.'
time curl -s http://52.55.197.86:8080/s3/dap/cloudydap/airs/AIRS.2015.01.01.L3.RetStd_IR001.v6.0.11.0.G15013155825.nc.h5.dmr -o airs.dmr

echo 'Test AIRS DAP4.'
time curl -s http://52.55.197.86:8080/s3/dap/cloudydap/airs/AIRS.2015.01.01.L3.RetStd_IR001.v6.0.11.0.G15013155825.nc.h5.dap\?dap4.ce=Latitude\;Longitude\;Topography -o airs_d4_ll.bin

echo 'Test AIRS DAP4 subsetting.'
time curl -s -g http://52.55.197.86:8080/s3/dap/cloudydap/airs/AIRS.2015.01.01.L3.RetStd_IR001.v6.0.11.0.G15013155825.nc.h5.dap\?dap4.ce=Topography\[0:20:179\]\[0:20:359\] -o airs_d4_ss.bin

echo 'Test AIRS DMR (local).'
time curl -s http://localhost:8081/opendap/s3/dap/cloudydap/airs/AIRS.2015.01.01.L3.RetStd_IR001.v6.0.11.0.G15013155825.nc.h5.dmr -o airs_local.dmr

echo 'Test AIRS DAP4 (local).'
time curl -s http://localhost:8081/opendap/s3/dap/cloudydap/airs/AIRS.2015.01.01.L3.RetStd_IR001.v6.0.11.0.G15013155825.nc.h5.dap\?dap4.ce=Latitude\;Longitude\;Topography -o airs_local_d4_ll.bin

echo 'Test AIRS DAP4 subsetting (local).'
time curl -s -g http://localhost:8081/opendap/s3/dap/cloudydap/airs/AIRS.2015.01.01.L3.RetStd_IR001.v6.0.11.0.G15013155825.nc.h5.dap\?dap4.ce=Topography\[0:20:179\]\[0:20:359\] -o airs_local_d4_ss.bin

# There should be only URL name difference:
# 
# < <Dataset xmlns="http://xml.opendap.org/ns/DAP/4.0#" xml:base="http://localhost:8081/opendap/s3/dap/cloudydap/airs/AIRS.2015.01.01.L3.RetStd_IR001.v6.0.11.0.G15013155825.nc.h5" dapVersion="4.0" dmrVersion="1.0" name="AIRS.2015.01.01.L3.RetStd_IR001.v6.0.11.0.G15013155825.nc.h5">
# ---
# > <Dataset xmlns="http://xml.opendap.org/ns/DAP/4.0#" xml:base="http://52.55.197.86:8080/s3/dap/cloudydap/airs/AIRS.2015.01.01.L3.RetStd_IR001.v6.0.11.0.G15013155825.nc.h5" dapVersion="4.0" dmrVersion="1.0" name="AIRS.2015.01.01.L3.RetStd_IR001.v6.0.11.0.G15013155825.nc.h5">
diff airs_local.dmr airs.dmr
cat airs_d4_ll.bin | getdap4 -D -M - > airs_d4_ll.asc
# cat airs_local_d4_ll.bin | getdap4 -D -M - > airs_local_d4_ll.asc
diff airs_local_d4_ll.asc airs_d4_ll.asc
cat airs_d4_ss.bin | getdap4 -D -M - > airs_d4_ss.asc
# cat airs_local_d4_ss.bin | getdap4 -D -M - > airs_local_d4_ss.asc
diff airs_local_d4_ss.asc airs_d4_ss.asc
