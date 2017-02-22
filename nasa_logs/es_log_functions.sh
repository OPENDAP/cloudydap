#!/bin/sh

export logFile="access_log_opendap_hashed_n5eil01"



function es_cloudydap_lcd_mappings() {

    index_name="$1";
    if [[ -z "${index_name// }" ]] || [ ! -n $index_name ] 
    then 
        >&2 echo "Missing ElasticSearch Index name! Needed as first parameter."
        return 2;
    fi
    >&2 echo "Adding NSIDC log mappings to index: $index_name"
    
    curl -XPUT http://localhost:9200/$index_name -d '
    {
     "mappings" : {
      "cloudydap_lcd_log" : {
       "properties" : {
        "time" : {
            "type":   "date",
            "format": "dd/MMM/yyyy:HH:mm:ss Z"
        },
        "unix_time" : {
            "type": "date",
            "format": "epoch_second"
        },
        "ip_addr"     : { 
            "type" : "keyword" 
        },
        "http_status" : { "type" : "long" },
        "size"        : { "type" : "long" },
        "resource_id" : { "type" : "keyword" },
        "path"        : { "type" : "keyword" },
        "query"       : { "type" : "keyword" },
       }
      }
     }
    }
    ';    
}


function es_cloudydap_mappings() {

    index_name="$1";
    if [[ -z "${index_name// }" ]] || [ ! -n $index_name ] 
    then 
        >&2 echo "Missing ElasticSearch Index name! Needed as first parameter."
        return 2;
    fi
    >&2 echo "Adding NSIDC log mappings to index: $index_name"
    
    curl -XPUT http://localhost:9200/$index_name -d '
    {
     "mappings" : {
      "cloudydap_log" : {
       "properties" : {
        "time" : {
            "type":   "date",
            "format": "dd/MMM/yyyy:HH:mm:ss Z||yyy-MM-dd HH:mma||dd-MMM-yy"
        },
        "ip_addr"     : { 
            "type" : "keyword" 
        },
        "protocol"          : { "type" : "keyword" },
        "http_verb"         : { "type" : "keyword" },
        "http_status"       : { "type" : "long" },
        "response_size"     : { "type" : "long" },
        "resource_id"       : { "type" : "keyword" },
        "request_suffix"    : { "type" : "keyword" },
        "path"              : { "type" : "keyword" },
        "query"             : { "type" : "keyword" },
        "user_agent"        : { "type" : "keyword" },
        "service"           : { "type" : "keyword" },
        "data_product"      : { "type" : "keyword" },
        "product_version"   : { "type" : "long" },
        "requested_pixels"  : { "type" : "long" },
        "available_pixels"  : { "type" : "long" },
        "uid"               : { "type" : "keyword" },
        "site"              : { "type" : "keyword" },
        "client_country"    : { "type" : "keyword" },
        "client_doman"      : { "type" : "keyword" },
        "instrument"        : { "type" : "keyword" },
        "description"       : { "type" : "text" },
        "platform"          : { "type" : "keyword" },
        "processing_level"  : { "type" : "keyword" },
        "btfom"             : { "type" : "keyword" },
        "service"           : { "type" : "keyword" },
        "use_case"          : { "type" : "keyword" },
        "index_name"        : { "type" : "keyword" }
       }
      }
     }
    }
    ';    
}



function es_list_indices(){       
    curl -XGET 'localhost:9200/_cat/indices?v&pretty'
}

function es_has_index(){       
    index_name="$1";
    if [[ -z "${index_name// }" ]] || [ ! -n $index_name ] 
    then 
        >&2 echo "Missing ElasticSearch Index name! Needed as first parameter."
        return 2;
    fi
    >&2 echo "Checking for index: $index_name"
    
    status=`curl -sIL -XHEAD "http://localhost:9200/$index_name?pretty" | head -1 | awk '{print $2}' -` 
    if [ "$status" = "200" ] 
    then
        >&2 echo "The index  $index_name was found."
        return 0;
    else 
        >&2 echo "No index names $index_name was located."
        return $status;
    fi
}




function es_get(){       
    index_name="$1";
    if [[ -z "${index_name// }" ]] || [ ! -n $index_name ] 
    then 
        >&2 echo "Missing ElasticSearch Index name! Needed as first parameter."
        return 2;
    fi
    >&2 echo "Retrieving from index: $index_name"

    id="$2";    
    if [[ -z "${id// }" ]] || [ ! -n $id ] 
    then 
        >&2 echo "Missing id of thing to get from Elastic Search! Needed as second parameter."
        return 2;
    fi
    >&2 echo "ID: $file"
    
    curl -XGET 'localhost:9200/'$index_name'/cloudydap_log/'$id'?pretty&pretty'
}

function es_get_mappings(){       
    index_name="$1";
    if [[ -z "${index_name// }" ]] || [ ! -n $index_name ] 
    then 
        >&2 echo "Missing ElasticSearch Index name! Needed as first parameter."
        return 2;
    fi
    >&2 echo "Retrieving mappings for index: $index_name"

    
    curl -XGET 'localhost:9200/'$index_name'/_mappings?pretty&pretty'
}




function es_delete_index(){
    index_name="$1";
    if [[ -z "${index_name// }" ]] || [ ! -n $index_name ] 
    then 
        >&2 echo "Missing ElasticSearch Index name! Needed as first parameter."
        return 2;
    fi
    >&2 echo "DELETING: $index_name"
       
    curl -XDELETE 'localhost:9200/'$index_name'?pretty&pretty'

}

function es_add_index(){
    index_name="$1";
    if [[ -z "${index_name// }" ]] || [ ! -n $index_name ] 
    then 
        >&2 echo "Missing ElasticSearch Index name! Needed as first parameter."
        return 2;
    fi
    >&2 echo "ADDING: $index_name"
       
    curl -XPUT 'localhost:9200/'$index_name'?pretty&pretty'

}

function es_index(){
    index_name="$1";
    if [[ -z "${index_name// }" ]] || [ ! -n $index_name ] 
    then 
        >&2 echo "Missing ElasticSearch Index name! Needed as first parameter."
        return 2;
    fi
    >&2 echo "Writing to index: $index_name"

    file="$2";    
    if [[ -z "${file// }" ]] || [ ! -n $file ] 
    then 
        >&2 echo "Missing Log File to have Elastic Search index! Needed as second parameter."
        return 2;
    fi
    >&2 echo "Indexing: $file into index $index_name"
  

    curl -s -XPUT "localhost:9200/"$index_name"/external/_bulk?pretty&pretty" -H "Content-Type: application/json" --data-binary "@"$file 

}



function convert_logs_to_json() {   
    
        
    # sample_cmd="head -500 "; 
    sample_cmd="cat "; 
    echo "-----------------------------------------------"
    echo "Converting nsidc/access_log_opendap_hashed_n5eil01 to json..."
    # $sample_cmd nsidc/access_log_opendap_hashed_n5eil01 | awk -v index_name=cloudydap-nsidc_n5eil01 $JRWQ -f nsidc/nsidc_log2json.awk > log_nsidc_n5eil01.json &
    python log2json.py --log-file nsidc/access_log_opendap_hashed_n5eil01 --index-name=cloudydap-nsidc_n5eil01 --log-type=NSIDC  > log_nsidc_n5eil01.json &
    
    echo "-----------------------------------------------"
    echo "Converting nsidc/access_log_opendap_hashed_n5dpl01 to json..."
    #$sample_cmd nsidc/access_log_opendap_hashed_n5dpl01 | awk -v index_name=cloudydap-nsidc_n5dpl01  $JRWQ -f nsidc/nsidc_log2json.awk > log_nsidc_n5dpl01.json &
    python log2json.py --log-file nsidc/access_log_opendap_hashed_n5dpl01 --index-name=cloudydap-nsidc_n5dpl01 --log-type=NSIDC  > log_nsidc_n5dpl01.json &

    echo "-----------------------------------------------"
    echo "Converting lpdaac/lpdaac_2015.02.15-2017.02.08_log.txt to json..."
    #$sample_cmd lpdaac/lpdaac_2015.02.15-2017.02.08_log.txt | awk  -v index_name=cloudydap-lpdaac $JRWQ -f lpdaac/lpdaac_log2json.awk -v id_base=0 > log_lpdaac.json &
    python log2json.py --log-file lpdaac/logs_for_opendap.txt --index-name=cloudydap-lpdaac --log-type=LPDAAC  > log_lpdaac.json &

    echo "-----------------------------------------------"
    echo "Converting larc_asdc/ASDC_access_clean.log to json..."
    #$sample_cmd larc_asdc/ASDC_access_clean.log | awk  -v index_name=cloudydap-asdc $JRWQ -f larc_asdc/asdc_log2json.awk -v id_base=0 > log_asdc.json &
    python log2json.py --log-file larc/ASDC_access_clean.log --index-name=cloudydap-asdc --log-type=ASDC  > log_asdc.json &

    echo "-----------------------------------------------"
    echo "Converting gsfc/opendap_mungaddr.txt to json..."
    # $sample_cmd gsfc/opendap_mungaddr.txt | awk  -v index_name=cloudydap-gesdisc $JRWQ -f gsfc/gesdisc_log2json.awk -v id_base=0 > log_gesdisc.json &
    python log2json.py --log-file gsfc/opendap_mungaddr.txt --index-name=cloudydap-gesdisc --log-type=GESDISC  > log_gesdisc.json &
    
    echo "JSON conversion running waiting for completion..."
    wait $(jobs -p);
    echo "JSON Conversion Finished."

}    

function unpack() {  
    
    echo "Unpacking GSFC Logs."
    gzcat gsfc/opendap_mungaddr.txt.gz > gsfc/opendap_mungaddr.txt &
    
    echo "Unpacking ASDC Logs."
    gzcat larc/ASDC_access_clean.log.gz > larc/ASDC_access_clean.log &
    
    echo "Unpacking LPDAAC Logs."
    gzcat lpdaac/logs_for_opendap.txt.gz > lpdaac/logs_for_opendap.txt &
    
    echo "Unpacking NSIDC Logs."
    cd nsidc; 
    tar -xvf access_logs.tgz &
    cd ..

    echo "Waiting for completion..."
    wait $(jobs -p);
    echo "Unpacking Is Finished."

}    



##########################################################################################
##########################################################################################
##########################################################################################
##########################################################################################
##########################################################################################



function es_load_log(){
    
    index_name="$1";
    if [[ -z "${index_name// }" ]] || [ ! -n $index_name ] 
    then 
        >&2 echo "Missing ElasticSearch Index name! Needed as first parameter."
        return 2;
    fi
    >&2 echo "Writing to index: $index_name"

    json_log_file="$2";    
    if [[ -z "${json_log_file// }" ]] || [ ! -n $json_log_file ] 
    then 
        >&2 echo "Missing Log File to have Elastic Search index! Needed as second parameter."
        return 2;
    fi
    >&2 echo "Indexing: $json_log_file into index $index_name"
  
    ingest_log=$json_log_file"_ingest.log"
    
    mkdir -p scratch
    rm -f scratch/*

    >&2 echo "Splitting $json_log_file into Elastic Search size bites for ingest,"
    shard_base="scratch/"`basename $json_log_file`"_shard_"
    
    split -l 200000  $json_log_file $shard_base
    
    es_has_index $index_name;
    has_index=$?;
    echo "has_index: " $has_index
    if [ $has_index -eq 0 ]
    then
        echo "Deleting index: " $has_index
        es_delete_index $index_name;
    fi
    es_list_indices;
    es_cloudydap_mappings $index_name;
    for shard_file in $shard_base*
    do
        >&2 echo "Indexing Shard: $shard_file into index $index_name"
        es_index $index_name $shard_file >> $ingest_log 2>&1
    done
    
    es_list_indices;
}


function load_logs_into_es(){
    index_base="cloudydap";
    
    mkdir -p scratch
    rm -f scratch/*
    
    
    for log_base in nsidc_n5eil01 nsidc_n5dpl01 lpdaac asdc gesdisc
    do
        log_file_to_index="log_"$log_base".json"
        index_name=$index_base"-"$log_base
        ingest_index_log=$log_file_to_index"_ingest.log"
        echo "Indexing log file $log_file_to_index";
        es_load_log $index_name  $log_file_to_index > $ingest_index_log 2>&1 &
    done 


    echo "Log Ingest Is Running. Waiting for completion..."
    wait $(jobs -p);
    echo "Log Ingest Is Finished."
}




