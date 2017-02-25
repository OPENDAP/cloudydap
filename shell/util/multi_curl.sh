#!/bin/sh
#
#  Simple response time tester for comparing the original sequentialy reading 
# DMR++ code with new CuRL multi interface that reads many things at once.
#
#


#  time curl -s http://curlmulti.opendap.org:8080/opendap/arch2/airs/AIRS.2015.01.02.L3.RetStd_IR001.v6.0.11.0.G15005190621.nc.h5.dmrpp.dap?dap4.ce=Temperature_A > multi.dap

#  time curl -s http:/cloudydap.opendap.org:8080/opendap/arch2/airs/AIRS.2015.01.02.L3.RetStd_IR001.v6.0.11.0.G15005190621.nc.h5.dmrpp.dap?dap4.ce=Temperature_A > seq.dap


airs_dataset="airs/AIRS.2015.01.02.L3.RetStd_IR001.v6.0.11.0.G15005190621.nc.h5.dmrpp.dap?dap4.ce=Temperature_A"

merra2_dataset="merra2/MERRA2_100.tavgM_2d_int_Nx.198002.nc4.dmrpp.dap?dap4.ce=PRECCU"


function get_it()
{
    url=$1;
    output_file=$2;
    
    curl -s "$url" > $output_file;
}


sequential_server="cloudydap.opendap.org:8080/opendap";
sequential_output="seq.dap";
ssum=0;

# multi_server="curlmulti.opendap.org:8080/opendap";
multi_server="52.1.239.194:8080/opendap";
multi_output="multi.dap";
msum=0;

dataset=$airs_dataset
arch="arch2"

for i in {1..100}
do    
    
    
    url="http://$multi_server/$arch/$dataset"
#    (time -p get_it "$url" "$multi_output") &>multi.time


    url="http://$sequential_server/$arch/$dataset"   
    (time -p get_it "$url" "$sequential_output") &>seq.time

    mtime=`head -1 multi.time | awk '{print $2;}' - `
    stime=`head -1 seq.time | awk '{print $2;}' - `
    ratio=`echo "3 k $mtime $stime / 100 * p" | dc`
#    echo "mtime: $mtime stime: $stime ratio: $ratio%" 

    msum=`echo "$msum $mtime + p" | dc`
    ssum=`echo "$ssum $stime + p" | dc`


    mavg=`echo "3 k $msum 100 / p" | dc `
    savg=`echo "3 k $ssum 100 / p" | dc `
    avg_ratio=`echo "3 k $mavg $savg / 100 * p" | dc`
    echo "mtime: $mtime stime: $stime ratio: $ratio% avg_mtime: $mavg avg_stime: $savg avg_ratio: $avg_ratio" 

done
echo "----------------------------------------------------------"
echo "curl_multi: $mavg   sequential: $savg:  avg_ratio: $avg_ratio" 
