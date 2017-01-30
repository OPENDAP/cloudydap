#!/bin/sh
#
# Takes a dmrpp file (name from the command line) and extracts all of the h4:byteStream
# elements and produces a list of all the md5 values.
#
# Next,the list of md5 values is used to build S3 URLs to retrive each of the 
# binary blobs associated with each byteStream from the bytestream collection in the 
# cloudydap bucket:
#
#    https://s3.amazonaws.com/cloudydap/bytestream
#
#
#

#file="../../../../../build/share/hyrax/arch3/merra2/MERRA2_100.instM_2d_asm_Nx.198001.nc4.dmrpp"
file=$1
if [[ -z "${file// }" ]] || [ ! -n $file ] 
then 
    echo "You must supply a relevant file name.";
    exit 2;
fi
echo "file: $file"; 


collection_url=$2
#if [ -z ${collection_url+"true"} ]
if [[ -z "${collection_url// }" ]] || [ ! -n $collection_url ] 
then 
    collection_url="https://s3.amazonaws.com/cloudydap/bytestream";
fi
echo "collection_url: '$collection_url'"; 

#exit

md5_list=`grep md5 $file | awk '
    {
        for(i=1; i<=NF ;i++){
            if(match($i,"md5=\"")){
                split($i,md5,"\"");
                print md5[2];
            }
        }
    }' - | sort | uniq`
    

echo "Located "`echo $md5_list | wc -w`" unique md5 tags in $file"
for md5 in $md5_list 
do
    echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
    echo "byteStreams: "
    bs_list=`grep $md5 $file`
    for bs in $bs_list
    do
        echo "    "$bs
    done
    echo "md5: "$md5
    resource_url=$collection_url"/"$md5;
    echo "resource_url: "$resource_url
    #curl -s $resource_url > $md5
    
    http_status=`curl -sL -w "%{http_code}\n" "$resource_url" -o $md5`
    curl_status=$?
    if [  $http_status -gt 299 ]
    then
        echo "DOWNLOAD FAILED! HTTP STATUS: $http_status   curl_status: $curl_status"  
    else
        echo "http_status: "$http_status" curl status: "$curl_status
    fi
done
