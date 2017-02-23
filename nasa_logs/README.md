
In this directory find processing scripts for various NASA access logs 
given to the cloudydap project. The scripts will massage the logs into 
JSON form and upload them into a locally running instance of 
Kibana/Elastic Search. In the process a resource_id representing each 
granule file accessed in the log are extracted from the request 
paths submnitted bye the client. This allows us to examine traffic on 
a a particular resource as a conglomerate of the various alternative 
services and encodings layered upon it.

What To Do:

1) In a bash shell change directories to the one with this README.md file.

2) Get the file "log_collections.tgz" from our NSIDC DropBox
   and unpack it in this directory.
   
3) Source the shell script es_log_functions.sh:

        source ./es_log_functions.sh

4) Unpack the logs:

        unpack

5) Convert the logs to JSON:

        convert_logs_to_json

6) With Elastic Search running on your local machine, load the logs:

        load_logs_into_es
        
7) Fire Up Kibana and have a look...


