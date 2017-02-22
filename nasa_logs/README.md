
In this directory find the NASA access logs given to the cloudydap project 
along with software to massage them into JSON form and upload them into a 
locally running instance of Kibana/Elastic Search.

What To Do:

1) In a bash shell change directories to the one with this README.md file.

2) Source the shell script es_log_functions.sh:

        source ./es_log_functions.sh

3) Unpack the logs:

        unpack

4) Convert the logs to JSON:

        convert_logs_to_json

5) With Elastic Search running on your local machine, load the logs:

        load_logs_into_es
        
6) Fire Up Kibana and have a look...


