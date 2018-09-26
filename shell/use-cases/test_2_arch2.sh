#!/bin/bash
# Copyright (C) 2016-2017 The HDF Group
# All rights reserved.
#
# https://github.com/OPENDAP/cloudydap/wiki/Trade-Study-Use-Case-2---DAP4-with-CF
#
random_string=$(dirname ${BASH_SOURCE[0]})/random_string.sh
echo "random_string.sh = $random_string"
source $random_string

CLOUDYDAP_TAG="UC2_A2CFT_STARTED_"`date +%s`".h5"
echo 'Test AIRS DMR.'
time -p curl -s http://$HYRAX:8080/opendap/arch2/airs/AIRS.2015.01.01.L3.RetStd_IR001.v6.0.11.0.G15013155825.nc.h5.dmrpp.dmr -o airs.dmr

echo 'Test AIRS DAP4.'
UNQID=$(unique_id)
CLOUDYDAP=$UNQID"_"$CLOUDYDAP_TAG
time -p curl -s http://$HYRAX:8080/opendap/arch2/airs/AIRS.2015.01.01.L3.RetStd_IR001.v6.0.11.0.G15013155825.nc.h5.dmrpp.dap\?dap4.ce=Latitude\;Longitude\;Topography\&cloudydap=$CLOUDYDAP -o airs_d4_ll.bin

echo 'Test AIRS DAP4 subsetting.'
UNQID=$(unique_id)
CLOUDYDAP=$UNQID"_"$CLOUDYDAP_TAG
time -p curl -s -g http://$HYRAX:8080/opendap/arch2/airs/AIRS.2015.01.01.L3.RetStd_IR001.v6.0.11.0.G15013155825.nc.h5.dmrpp.dap\?dap4.ce=Topography\[0:20:179\]\[0:20:359\]\&cloudydap=$CLOUDYDAP -o airs_d4_ss.bin

# echo 'Test AIRS DMR (local).'
# time curl -s http://localhost:8081/opendap/s3/dap/arch2/airs/AIRS.2015.01.01.L3.RetStd_IR001.v6.0.11.0.G15013155825.nc.h5.dmrpp.dmr -o airs_local.dmr

# echo 'Test AIRS DAP4 (local).'
# time curl -s http://localhost:8081/opendap/s3/dap/arch2/airs/AIRS.2015.01.01.L3.RetStd_IR001.v6.0.11.0.G15013155825.nc.h5.dmrpp.dap\?dap4.ce=Latitude\;Longitude\;Topography -o airs_local_d4_ll.bin

# echo 'Test AIRS DAP4 subsetting (local).'
# time curl -s -g http://localhost:8081/opendap/s3/dap/arch2/airs/AIRS.2015.01.01.L3.RetStd_IR001.v6.0.11.0.G15013155825.nc.h5.dmrpp.dap\?dap4.ce=Topography\[0:20:179\]\[0:20:359\] -o airs_local_d4_ss.bin

# There should be only URL name difference:
#
# < <Dataset xmlns="http://xml.opendap.org/ns/DAP/4.0#" xml:base="http://localhost:8081/opendap/s3/dap/arch2/airs/AIRS.2015.01.01.L3.RetStd_IR001.v6.0.11.0.G15013155825.nc.h5.dmrpp" dapVersion="4.0" dmrVersion="1.0" name="AIRS.2015.01.01.L3.RetStd_IR001.v6.0.11.0.G15013155825.nc.h5.dmrpp">
# ---
# > <Dataset xmlns="http://xml.opendap.org/ns/DAP/4.0#" xml:base="http://$HYRAX:8080/s3/dap/arch2/airs/AIRS.2015.01.01.L3.RetStd_IR001.v6.0.11.0.G15013155825.nc.h5.dmrpp" dapVersion="4.0" dmrVersion="1.0" name="AIRS.2015.01.01.L3.RetStd_IR001.v6.0.11.0.G15013155825.nc.h5.dmrpp">
# There are too many differences in Arch #1 and Arch #2 XML.
diff airs_arch2.dmr airs.dmr
cat airs_d4_ll.bin | getdap4 -D -M - | tail -5 > airs_d4_ll.asc
# cat airs_local_d4_ll.bin | getdap4 -D -M - > airs_local_d4_ll.asc
diff airs_arch2_d4_ll.asc airs_d4_ll.asc
cat airs_d4_ss.bin | getdap4 -D -M - | tail -3 > airs_d4_ss.asc
# cat airs_local_d4_ss.bin | getdap4 -D -M - > airs_local_d4_ss.asc
diff airs_local_d4_ss.asc airs_d4_ss.asc
