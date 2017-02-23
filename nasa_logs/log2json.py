#
# encoding=UTF-8
# Foo
#
#
# Authors: Nathan Potter
#
# Date:    12/28/2016
#
#

#import numpy as np
import sys;
import re;
import argparse;
import json;
 

###############################################################################
# get_resource_id
#    Implements a heuristic procedure to remove the various DAP and 
# other return format suffixes from the client_request path in order to 
# identify the name/id of the underlying granule against which the request 
# is being assesed.
#
def get_resource_id(client_request, verbose ):
    request_suffix =  None;
    #print "client_request: %s" % client_request;

    parts = client_request.split("?");

    #for i in range(len(parts)):
    #    print "parts[%d]: %s" % (i, parts[i]); 
        
    resource = parts[0];
    
    # This deals with {} request notation
    #if(match(resource,".*%7B.*$")) {
    #    curly_brace_request = substr(resource, index(resource,"%7B"));
    #    resource =  substr(resource, 1, index(resource,"%7B")-1);        
    #}
    curly_brace_request = 0;
    p = re.compile('.*%7B.*$');
    if(p.match(resource)):
        curly_brace_request = resource[resource.index("%7B"):];
        resource = resource[:resource.index("%7B")]
        if(verbose): print "Found curly-brace request! resource: %s curly_brace_request: %s" % (resource, curly_brace_request); 
        
     
    #while(resource[1]=="/" and len(resource)>1):
    #    resource = resource[2:];
    while(resource[-1:]=="/" and len(resource)>1):
        resource = resource[:-1];
            
          
    if(verbose): print "resource: %s " % resource;
        
    basename = resource;

    if(basename.endswith("catalog.xml")):
        basename = "catalog.xml";
    
    if(basename.endswith("catalog.html")):
        basename = "catalog.html";

    
    if(basename.endswith("contents.html")):
        basename = "contents.html";
    
    
    weebits = basename.split(".");
    component_count = len(weebits);
    if(verbose): print "component_count: %s" % component_count

    n = component_count;
   
    suffix_pattern = re.compile("dap|dmr|ddx|dds|das|dods|info|rdf");
    if( suffix_pattern.match(weebits[-1]) ):
        secondary_pattern = re.compile("html|dat|h5|H5|HDFEOS");
        if(weebits[-2]=="html" and
            (secondary_pattern.match(weebits[-3]))):
            request_suffix=".%s.%s" % (weebits[-2],weebits[-1]);
            if(verbose): print "Dropping suffix: %s" % request_suffix;
            component_count-=2;
        elif(re.compile("dds|dmr|dds").match(weebits[-2])):
            request_suffix=".%s.%s" % (weebits[-2],weebits[-1]);
            if(verbose): print "Dropping suffix: %s" % request_suffix;
            component_count-=2;
        else :
            request_suffix=".%s" % weebits[-1];
            if(verbose): print "Dropping suffix %s" % request_suffix;
            component_count-=1;
        
  
    suffix_pattern = re.compile("html|xml|csv|nc|nc4|tiff|ascii|bogus|json");
    
    if(suffix_pattern.match(weebits[-1])):
        dap_pattern =  re.compile("dmr|dds|dap");
        data_pattern = re.compile("hdf|H5|HDFEOS|csv|tif|nc|dat",re.IGNORECASE);
        if(dap_pattern.match(weebits[-2])):
            request_suffix=".%s.%s" % (weebits[-2],weebits[-1]);
            if(verbose): print "Dropping suffix: %s" % request_suffix;
            component_count-=2;
        elif(data_pattern.match(weebits[-2])):             
            request_suffix=".%s" % weebits[-1];
            if(verbose): print "Dropping suffix %s" % request_suffix;
            component_count-=1;
        

  
    if(verbose): print "component_count: %s" % component_count;
    resource_id="";
    
    for i in range(0, component_count):
        if(i>0): resource_id+=".";
        resource_id+=weebits[i];

    return resource_id, request_suffix, curly_brace_request;






################################################################################################################################
#
# gesdisc_log_line_to_json()
#
# This method takes a single log line from a GSFC
# GESDISC log file and converts it into a JSON representation
# using terms from the cloudydap_log mappping for Elastic 
# Search.
#
# Example Log Line:
#01-MAR-16|GESDISC|GET /opendap/Aqua_AIRS_Level1/AIRIBRAD.005/2006/316/AIRS.2006.11.12.054.L1B.AIRS_Rad.v5.0.0.0.G07126215250.hdf.dods?L1B%5fAIRS%5fScience%5fData%5fFields%5fstate HTTP/1.1|2cd9719610a6ebd60eb4d4c5298ce062f45c8a35|United Kingdom|bath.ac.uk|AIRIBRAD|AIRS/Aqua infrared geolocated radiances|AQUA|AIRS|1B|005|OpenDAP|science|48798
#
# Description:
#  1 date: 01-MAR-16
#  2 site: GESDISC
#  3 http_verb: GET
#  4 path_n_query: /opendap/Aqua_AIRS_Level1/AIRIBRAD.005/2006/316/AIRS.2006.11.12.054.L1B.AIRS_Rad.v5.0.0.0.G07126215250.hdf.dods?L1B%5fAIRS%5fScience%5fData%5fFields%5fstate 
#  5 protocol: HTTP/1.1
#  6 ip: 2cd9719610a6ebd60eb4d4c5298ce062f45c8a35
#  7 client_country: United Kingdom
#  8 client_domain: bath.ac.uk
#  9 product AIRIBRAD
# 10 instrument: AIRS
# 11 description: Aqua infrared geolocated radiances
# 12 platform: AQUA
# 13 instrument: AIRS
# 14 procesing Level: 1B
# 15 btfom: 005
# 16 service: OpenDAP
# 17 use-case: science
# 18 response_size: 48798
#
#
#
# @param log_line The GESDISC log line to be converted to JSON.
# @param index_name The log source key for this log.
# @param use_null Use nulls for missing values.
# @param only_queries Only convert log lines where the request 
#  contains a query string.
# @param verbose Debug mode baby...
# @return The JSON representation of 'log_line'
#
def gesdisc_log_line_to_json(log_line, index_name, use_null, only_queries, verbose ):
 
    curly_brace_request=0;
    request_suffix=0;
    query=0;

    
    if(verbose): print "------------------------------------------------------"
    if(verbose): print log_line;
    pattern = "|";
    log_fields = log_line.split(pattern);
    if(verbose): print "Found %d fields with pattern '%s'" % (len(log_fields), pattern); 
    
    time_str = log_fields[0];
    if(verbose): print "time_str: %s" % time_str;
    
    site=log_fields[1];
    if(verbose): print "site: &s " % site;


    http_stuff = log_fields[2].split();
    
    http_verb = http_stuff[0];
    if(verbose): print "http_verb: %s" % http_verb;

    resource_id, request_suffix, curly_brace_request = get_resource_id(http_stuff[1], verbose);
    if(verbose): print "resource_id: %s" % resource_id;
    if(verbose): print "request_suffix: %s" % request_suffix;
    if(verbose): print "curly_brace_request: %s" % curly_brace_request;


    path_n_query=http_stuff[1];
    if(verbose): print "path_n_query: %s" % path_n_query;

    qmark_index = path_n_query.find("?");
    if(qmark_index<0):
        path = path_n_query;
    else:
        path = path_n_query[:qmark_index];
        query =  path_n_query[qmark_index+1:];
    
    if(curly_brace_request):
        query =  "%s?%s" % (curly_brace_request,query);

    if(verbose): print "path:  %s" % path;
    if(verbose): print "query: %s" % query;

    protocol=http_stuff[2];
    if(verbose): print "protocol: %s" % protocol;
    
    ip_addr=log_fields[3];
    if(verbose): print "hashed_ip: %s" % ip_addr;


    client_country = log_fields[4];
    if(verbose): print "client_country: %s" % client_country;

    client_doman = log_fields[5];
    if(verbose): print "client_doman: %s" % client_doman;
    
    product = log_fields[6];
    if(verbose): print "product: %s" % product;
        
    description = log_fields[7];
    if(verbose): print "description: %s" % description;

    platform = log_fields[8];
    if(verbose): print "platform: %s" % platform;

    instrument = log_fields[9];
    if(verbose): print "instrument: %s" % instrument;

    processing_level = log_fields[10];
    if(verbose): print "procesing_level: %s" % procesing_level;
    
    btfom = log_fields[11];
    if(verbose): print "btfom: %s" % btfom;
    
    service = log_fields[12];
    if(verbose): print "service: %s" % service;
    
    use_case = log_fields[13];
    if(verbose): print "use_case: %s" % use_case;
    
    response_size = log_fields[14];
    if(verbose): print "response_size: %s" % response_size;
        
  
    resource_id, request_suffix, curly_brace_request = get_resource_id(log_fields[6], verbose);
    if(verbose): print "resource_id: %s" % resource_id;
    if(verbose): print "request_suffix: %s" % request_suffix;
    if(verbose): print "curly_brace_request: %s" % curly_brace_request;

    
    try: 
        http_status = int(log_fields[7]);
    except ValueError:
        http_status = None;
    if(verbose): print "http_status: %s" % http_status;


    try: 
        response_size = int(log_fields[8]);
    except ValueError:
        response_size = None;
    if(verbose): print "response_size: %d" % response_size;
    
    if(len(log_fields)>9): user_id = log_fields[9];
    else: user_id = None;
    if(verbose): print "user_id: %s" % user_id;

 
     # Build JSON response as a string...
    json_record="{";
    json_record =  "%s\"time\":\"%s\", " % (json_record, time_str);
        
    json_record = "%s\"ip_addr\":\"%s\", "   % (json_record, ip_addr);
    json_record = "%s\"protocol\":\"%s\", "   % (json_record, protocol);
    json_record = "%s\"http_verb\":\"%s\", "   % (json_record, http_verb);
    
    if(response_size): json_record = "%s\"response_size\":%d, " % (json_record, int(response_size));
    elif(use_null): json_record = "%s \"response_size\": null, " % json_record;
    
    json_record = "%s\"resource_id\":\"%s\", " % (json_record, resource_id);
    
    if(request_suffix):
        json_record = "%s\"request_suffix\":\"%s\", " % (json_record,request_suffix);
    elif(use_null): json_record = "%s\"request_suffix\": null, " % json_record;
    
    json_record = "%s\"path\":\"%s\", " % (json_record, path);
    
    if(query):
        json_record = "%s\"query\":%s, " % (json_record, json.dumps(query));
    elif(use_null): json_record = "%s\"query\": null, " % json_record;


    json_record = "%s\"site\":\"%s\", " % (json_record,site);
    json_record = "%s\"client_country\":\"%s\", " % (json_record,client_country);
    json_record = "%s\"client_doman\":\"%s\", " % (json_record,client_doman);
    json_record = "%s\"instrument\":\"%s\", " % (json_record,instrument);
    json_record = "%s\"description\":\"%s\", " % (json_record,description);
    json_record = "%s\"platform\":\"%s\", " % (json_record,platform);
    json_record = "%s\"processing_level\":\"%s\", " % (json_record,processing_level);
    json_record = "%s\"btfom\":\"%s\", " % (json_record,btfom);
    json_record = "%s\"service\":\"%s\", " % (json_record,service);
    json_record = "%s\"use_case\":\"%s\", " % (json_record,use_case)

    if(use_null):    
        json_record = "%s\"http_status\": null, " % json_record;
        json_record = "%s\"user_agent\": null, "  % json_record;
        json_record = "%s\"uid\": null, "  % json_record;
        json_record = "%s\"product_version\": null, "  % json_record;
        json_record = "%s\"requested_pixels\": null, "  % json_record;
        json_record = "%s\"available_pixels\": null, "  % json_record;
        json_record = "%s\"data_product\": null, "  % json_record;
        json_record = "%s\"uid\": null, "  % json_record;
        
        
    json_record = "%s\"index_name\":\"%s\"" % (json_record,index_name);
    json_record =  "%s }" % json_record;

    if( not only_queries or query):
        return json_record;
        
            
    return;


 
################################################################################################################################
#
# asdc_log_line_to_json()
#
# This method takes a single log line from a LaRC
# ASDC log file and converts it into a JSON representation
# using terms from the cloudydap_log mappping for Elastic 
# Search.
# Example line:
# 2cd7bde57986b28a10fa97c0f8323df9c45e4c1b5756a73de3edf4ac - - [01/Jan/2016:00:00:00 -0500] "GET /opendap/level1/MISR/MB2LME.002/2002.09.05/MISR_AM1_GRP_ELLIPSOID_LM_P097_O014441_AA_SITE_TWPMANUS_F03_0024.hdf.dods?LatitudeU3[68][679] HTTP/1.1" 200 152
#
# @param log_line The ASDC log line to be converted to JSON.
# @param index_name The log source key for this log.
# @param use_null Use nulls for missing values.
# @param only_queries Only convert log lines where the request 
#  contains a query string.
# @param verbose Debug mode baby...
# @return The JSON representation of 'log_line'
#
def asdc_log_line_to_json(log_line, index_name, use_null, only_queries, verbose ):
 
    curly_brace_request=0;
    request_suffix=0;
    query=0;

    
    if(verbose): print "------------------------------------------------------"
    if(verbose): print log_line;
    
    fields = log_line.split();
 
    ip_addr=fields[0];
    if(verbose): print "hashed_ip: %s" % ip_addr;
    
    
    time_str="%s %s" % ( fields[3], fields[4]);
    #gsub("\\[|\\]","",time_str);
    time_str = re.sub("\\[|\\]", "", time_str)
    if(verbose): print "time_str: %s" % time_str;
    
    http_verb=fields[5];
    http_verb = http_verb.replace("\"","");
    if(verbose): print "http_verb: %s" % http_verb;
    
    resource_id, request_suffix, curly_brace_request = get_resource_id(fields[6], verbose);
    if(verbose): print "resource_id: %s" % resource_id;
    if(verbose): print "request_suffix: %s" % request_suffix;
    if(verbose): print "curly_brace_request: %s" % curly_brace_request;

    path_n_query=fields[6];
    if(verbose): print "path_n_query: %s" % path_n_query;

    qmark_index = path_n_query.find("?");
    if(qmark_index<0):
        path = path_n_query;
    else:
        path = path_n_query[:qmark_index];
        query =  path_n_query[qmark_index+1:];
    
    if(curly_brace_request):
        query =  "%s?%s" % (curly_brace_request,query);
    
    if(verbose): print "path:  %s" % path;
    if(verbose): print "query: %s" % query;

    protocol = fields[7];
    protocol = protocol.replace("\"","");
    if(verbose): print "protocol: %s" % protocol;
    
    try: 
        http_status = int(fields[8]);
    except ValueError:
        http_status = None;
    if(verbose): print "http_status: %s" % http_status;
    
    response_size = fields[9];
    if(verbose): print "response_size: %s" % response_size;

 
     # Build JSON response as a string...
    json_record="{";
    json_record =  "%s\"time\":\"%s\", " % (json_record, time_str);
        
    json_record = "%s\"ip_addr\":\"%s\", "   % (json_record, ip_addr);
    json_record = "%s\"protocol\":\"%s\", "  % (json_record, protocol);
    json_record = "%s\"http_verb\":\"%s\", " % (json_record, http_verb);
    
    if(http_status): json_record = "%s\"http_status\": %d, "  % (json_record, http_status);
    elif(use_null): json_record = "%s\"http_status\": null, " % json_record;

    if(response_size=="-"):
        if(use_null): json_record = "%s \"response_size\": null, " % json_record;
    else:
        json_record = "%s\"response_size\":%d, " % (json_record, int(response_size));
    
    json_record = "%s\"resource_id\":\"%s\", " % (json_record, resource_id);
    
    if(request_suffix):
        json_record = "%s\"request_suffix\":\"%s\", " % (json_record,request_suffix);
    else: 
        if(use_null): json_record = "%s\"request_suffix\": null, " % json_record;
    
    json_record = "%s\"path\":\"%s\", " % (json_record, path);
    
    if(query):
        json_record = "%s\"query\":%s, " % (json_record, json.dumps(query));
    else:
        if(use_null): json_record = "%s\"query\": null, " % json_record;


    
  
    if(use_null):
        json_record = "%s\"service\": null, " % json_record;
        json_record = "%s\"user_agent\": null, "  % json_record;
        json_record = "%s\"data_product\": null, " % json_record;
        json_record = "%s\"product_version\": null, " % json_record;
        json_record = "%s\"requested_pixels\": null, " % json_record;
        json_record = "%s\"available_pixels\": null, " % json_record;
        json_record = "%s\"uid\": null, " % json_record;
        json_record = "%s\"site\": null, " % json_record;
        json_record = "%s\"client_country\": null, " % json_record;
        json_record = "%s\"client_doman\": null, " % json_record;
        json_record = "%s\"instrument\": null, " % json_record;
        json_record = "%s\"description\": null, " % json_record;
        json_record = "%s\"platform\": null, " % json_record;
        json_record = "%s\"processing_level\": null, " % json_record;
        json_record = "%s\"btfom\": null, " % json_record;
        json_record = "%s\"service\": null, " % json_record;
        json_record = "%s\"use_case\": null, " % json_record;
        
    json_record = "%s\"index_name\":\"%s\"" % (json_record,index_name);
    json_record =  "%s }" % json_record;

    if( not only_queries or query):
        return json_record;
    
    return;


################################################################################################################################
# LPDAAC
#
# lpdaac_log_line_to_json()
#
# This method takes a single log line from an LPDAAC
# log file and converts it into a JSON representation
# using terms from the cloudydap_log mappping for Elastic 
# Search.
# 
# Line Format:
#  date-time |&| obfuscated ip address |&| product |&| version |&| requested pixels |&| available pixels (not used yet, ignore) |&| url path |&| request status |&| bytes |&| obfuscated user name (added after 9/2016 )
#
#
#  1 date-time |&| 2015-02-15 05:11AM
#  2 obfuscated ip address |&| 0b3a0a4591c506cfecc8d53de6df54b52a68c9a3
#  3 product |&| ASTGTM
#  4 version |&| 2
#  5 requested pixels |&| 7202
#  6 available pixels (not used yet, ignore) |&| 12974403
#  7 url path |&|  /opendap/hyrax/ASTGTM.002/ASTGTM.002_N60W133_dem.nc.dods?crs,lat,lon
#  8 request status |&| 200
#  9 bytes |&| 57752
# 10 obfuscated user name (added after 9/2016 )
#
# 2015-02-15 05:11AM|&|0b3a0a4591c506cfecc8d53de6df54b52a68c9a3|&|ASTGTM|&|2|&|7202|&|12974403|&|/opendap/hyrax/ASTGTM.002/ASTGTM.002_N60W133_dem.nc.dods?crs,lat,lon|&|200|&|57752
#
#
#
# @param log_line The LPDAAC log line to be converted to JSON.
# @param index_name The log source key for this log.
# @param use_null Use nulls for missing values.
# @param only_queries Only convert log lines where the request 
#  contains a query string.
# @param verbose Debug mode baby...
# @return The JSON representation of 'log_line'
#
def lpdaac_log_line_to_json(log_line, index_name, use_null, only_queries, verbose ):
 
    curly_brace_request=0;
    request_suffix=0;
    query=0;

    
    if(verbose): print "------------------------------------------------------"
    if(verbose): print log_line;
    pattern = "|&|";
    log_fields = log_line.split(pattern);
    if(verbose): print "Found %d fields with pattern '%s'" % (len(log_fields), pattern); 
    
    time_str = log_fields[0];
    if(verbose): print "time_str: %s" % time_str;

    ip_addr=log_fields[1];
    if(verbose): print "hashed_ip: %s" % ip_addr;
    
    
    data_product=log_fields[2];
    if(verbose): print "data_product: %s" % data_product;
    
    product_version=log_fields[3];
    if(verbose): print "product_version: %s" % product_version;
    
    try: 
        requested_pixels = int(log_fields[4]);
    except ValueError:
        requested_pixels = None;
    if(verbose): print "requested_pixels: %s" % requested_pixels;
    
    try: 
        available_pixels = int(log_fields[5]);
    except ValueError:
        available_pixels = None;
    if(verbose): print "available_pixels: %s" % available_pixels;
   
    
    resource_id, request_suffix, curly_brace_request = get_resource_id(log_fields[6], verbose);
    if(verbose): print "resource_id: %s" % resource_id;
    if(verbose): print "request_suffix: %s" % request_suffix;
    if(verbose): print "curly_brace_request: %s" % curly_brace_request;

    path_n_query=log_fields[6];
    if(verbose): print "path_n_query: %s" % path_n_query;

    qmark_index = path_n_query.find("?");
    if(qmark_index<0):
        path = path_n_query;
    else:
        path = path_n_query[:qmark_index];
        query =  path_n_query[qmark_index+1:];
  
    if(curly_brace_request):
        query =  "%s?%s" % (curly_brace_request,query);
    
    if(verbose): print "path:  %s" % path;
    if(verbose): print "query: %s" % query;

   
    try: 
        http_status = int(log_fields[7]);
    except ValueError:
        http_status = None;
    if(verbose): print "http_status: %s" % http_status;


    try: 
        response_size = int(log_fields[8]);
    except ValueError:
        response_size = None;
    if(verbose): print "response_size: %d" % response_size;
    
    if(len(log_fields)>9): user_id = log_fields[9];
    else: user_id = None;
    if(verbose): print "user_id: %s" % user_id;

 
     # Build JSON response as a string...
    json_record="{";
    json_record =  "%s\"time\": \"%s\", " % (json_record, time_str);
        
    json_record = "%s\"ip_addr\": \"%s\", "   % (json_record, ip_addr);
    
    if(http_status): json_record = "%s\"http_status\": %d, "  % (json_record, http_status);
    elif(use_null): json_record = "%s\"http_status\": null, " % json_record;

    if(response_size): json_record = "%s\"response_size\": %d, " % (json_record, int(response_size));
    elif(use_null): json_record = "%s \"response_size\": null, " % json_record;
    
    json_record = "%s\"resource_id\": \"%s\", " % (json_record, resource_id);
    
    if(request_suffix):
        json_record = "%s\"request_suffix\": \"%s\", " % (json_record,request_suffix);
    elif(use_null): json_record = "%s\"request_suffix\": null, " % json_record;
    
    json_record = "%s\"path\": \"%s\", " % (json_record, path);
    
    if(query):
        json_record = "%s\"query\": %s, " % (json_record, json.dumps(query));
    elif(use_null): json_record = "%s\"query\": null, " % json_record;

    json_record = "%s\"data_product\": \"%s\", " % (json_record,data_product);
    json_record = "%s\"product_version\": \"%s\", " % (json_record,product_version);
    
    if(requested_pixels):
        json_record = "%s\"requested_pixels\": \"%s\", " % (json_record,requested_pixels);
    elif(use_null): json_record = "%s\"requested_pixels\": null, " % json_record;

    if(available_pixels):
        json_record = "%s\"available_pixels\":\"%s\", " % (json_record,available_pixels);
    elif(use_null): json_record = "%s\"available_pixels\": null, " % json_record;

    if(user_id):
        json_record = "%s\"uid\": \"%s\", " % (json_record, user_id);
    elif(use_null): json_record = "%s\"uid\": null, " % json_record;    


    if(use_null):
        json_record = "%s\"http_verb\": null, " % json_record;
        json_record = "%s\"protocol\": null, " % json_record;

        json_record = "%s\"service\": null, " % json_record;
        json_record = "%s\"user_agent\": null, "  % json_record;
        
        
        json_record = "%s\"site\": null, " % json_record;
        json_record = "%s\"client_country\": null, " % json_record;
        json_record = "%s\"client_doman\": null, " % json_record;
        json_record = "%s\"instrument\": null, " % json_record;
        json_record = "%s\"description\": null, " % json_record;
        json_record = "%s\"platform\": null, " % json_record;
        json_record = "%s\"processing_level\": null, " % json_record;
        json_record = "%s\"btfom\": null, " % json_record;
        json_record = "%s\"service\": null, " % json_record;
        json_record = "%s\"use_case\": null, " % json_record;
        
    json_record = "%s\"index_name\": \"%s\"" % (json_record,index_name);
    json_record =  "%s }" % json_record;

    if( not only_queries or query):
        return json_record;
        
            
    return;


################################################################
# nsidc_log_line_to_json
# This method takes a single log line from an
# NSIDC log file and converts it into a JSON representation
# using terms from the cloudydap_log mappping for Elastic 
# Search.
# @param log_line The NSIDC log line to be converted to JSON.
# @param index_name The log source key for this log.
# @param use_null Use nulls for missing values.
# @param only_queries Only convert log lines where the request 
#  contains a query string.
# @param verbose Debug mode baby...
# @return The JSON representation of 'log_line'
def nsidc_log_line_to_json(log_line, index_name, use_null, only_queries, verbose ):

    curly_brace_request=0;
    request_suffix=0;
    query=0;

    
    if(verbose): print "------------------------------------------------------"
    if(verbose): print log_line;
    
    fields = log_line.split();
    

    ip_addr=fields[0];
    if(verbose): print "hashed_ip: %s" % ip_addr;
    
    time_str="%s %s" % ( fields[3], fields[4]);
    #gsub("\\[|\\]","",time_str);
    time_str = re.sub("\\[|\\]", "", time_str)
    if(verbose): print "time_str: %s" % time_str;


    http_verb=fields[5];
    http_verb = http_verb.replace("\"","");
    if(verbose): print "http_verb: %s" % http_verb;
    
    resource_id, request_suffix, curly_brace_request = get_resource_id(fields[6], verbose);
    if(verbose): print "resource_id: %s" % resource_id;
    if(verbose): print "request_suffix: %s" % request_suffix;
    if(verbose): print "curly_brace_request: %s" % curly_brace_request;

    path_n_query=fields[6];
    if(verbose): print "path_n_query: %s" % path_n_query;
    
    qmark_index = path_n_query.find("?");
    if(qmark_index<0):
        path = path_n_query;
    else:
        path = path_n_query[:qmark_index];
        query =  path_n_query[qmark_index+1:];
    
    if(curly_brace_request):
        query =  "%s?%s" % (curly_brace_request,query);
    
    if(verbose): print "path:  %s" % path;
    if(verbose): print "query: %s" % query;
    
    protocol = fields[7];
    protocol = protocol.replace("\"","");
    if(verbose): print "protocol: %s" % protocol;
    
    http_status = int(fields[8]);
    if(verbose): print "http_status: %s" % http_status;
    
    response_size = fields[9];
    if(verbose): print "response_size: %s" % response_size;
    
    if(len(fields)>10):
        service = fields[10];
        service = service.replace("\"",""); 
        ua_index = log_line.find(fields[10]) + len(fields[10]);
        user_agent=log_line[ua_index:].replace("\"","").strip();  
    else:
        service=None;
        user_agent=None;
        
    if(verbose): print "service: %s" % service;
    if(verbose): print "user_agent: '%s'" % user_agent; 
   
    

    
    # Build JSON response as a string...
    json_record="{";
    json_record =  "%s\"time\":\"%s\", " % (json_record, time_str);
        
    json_record = "%s\"ip_addr\":\"%s\", "   % (json_record, ip_addr);
    json_record = "%s\"protocol\":\"%s\", "  % (json_record, protocol);
    json_record = "%s\"http_verb\":\"%s\", " % (json_record, http_verb);
    json_record = "%s\"http_status\": %d, "  % (json_record, http_status);
        
    if(response_size=="-"):
        if(use_null): json_record = "%s \"response_size\": null, " % json_record;
    else:
        json_record = "%s\"response_size\":%d, " % (json_record, int(response_size));
    
    json_record = "%s\"resource_id\":\"%s\", " % (json_record, resource_id);
    
    if(request_suffix): json_record = "%s\"request_suffix\":\"%s\", " % (json_record,request_suffix);
    elif(use_null): json_record = "%s\"request_suffix\": null, " % json_record;
    
    json_record = "%s\"path\":\"%s\", " % (json_record, path);
    
    if(query): json_record = "%s\"query\":%s, " % (json_record, json.dumps(query));
    elif(use_null): json_record = "%s\"query\": null, " % json_record;

    if(service and service!="-"):
        json_record = "%s\"service\":\"%s\", " % (json_record,service);
    elif(use_null): json_record = "%s\"service\": null, " % json_record;

    if(user_agent): json_record = "%s\"user_agent\":\"%s\", "  % (json_record, user_agent);
    elif(use_null): json_record = "%s\"user_agent\": null, " % json_record;

    if(use_null):
        json_record = "%s\"data_product\": null, " % json_record;
        json_record = "%s\"product_version\": null, " % json_record;
        json_record = "%s\"requested_pixels\": null, " % json_record;
        json_record = "%s\"available_pixels\": null, " % json_record;
        json_record = "%s\"uid\": null, " % json_record;
        json_record = "%s\"site\": null, " % json_record;
        json_record = "%s\"client_country\": null, " % json_record;
        json_record = "%s\"client_doman\": null, " % json_record;
        json_record = "%s\"instrument\": null, " % json_record;
        json_record = "%s\"description\": null, " % json_record;
        json_record = "%s\"platform\": null, " % json_record;
        json_record = "%s\"processing_level\": null, " % json_record;
        json_record = "%s\"btfom\": null, " % json_record;
        json_record = "%s\"service\": null, " % json_record;
        json_record = "%s\"use_case\": null, " % json_record;
        
    json_record = "%s\"index_name\":\"%s\"" % (json_record,index_name);
    json_record =  "%s }" % json_record;

    if( not only_queries or query):
        return json_record;
    
    return;
    
   
################################################################
# log_file_to_json
def log_file_to_json(log_file, line_converter, index_name, es_type, id_base,  use_null, only_queries, verbose ):
    line_num=0;
    with open(log_file) as f:
        for line in f:
            record_id = id_base + line_num;
            json_record =  line_converter(line.rstrip(), index_name, use_null, only_queries, verbose);
            if(json_record):
                print "{\"index\":{\"_index\":\"%s\",\"_id\":\"%d\",\"_type\":\"%s\"}}" % (index_name, record_id, es_type);
                print json_record;
                
            sys.stdout.flush();
            line_num+=1;
            
    return;
 



################################################################################
#
# main(), as it were
#
parser = argparse.ArgumentParser(description="Convert access log file to json");
parser.add_argument("--index-name",required=True);
parser.add_argument("--log-file",required=True);
parser.add_argument("--log-type",required=True);
parser.add_argument("--es-type",required=False);
parser.add_argument("-v","--verbose",default=False,action="store_true");
parser.add_argument("-n","--use_null",default=False,action="store_true");
parser.add_argument("-q","--only_queries",default=False,action="store_true");
args = parser.parse_args();

index_name = args.index_name;
log_file = args.log_file;
log_type = args.log_type;

verbose = 0;
if hasattr(args, 'verbose'):
    verbose=args.verbose;

use_null=0;        
if hasattr(args, 'use_null'):    
    use_null=args.use_null;

only_queries=0;
if hasattr(args, 'only_queries'):  
    only_queries=args.only_queries;


es_type="cloudydap_log";
if hasattr(args, 'es-type'):  
    es_type=args.es_type;

sys.stderr.write("ES index name: %s\n" % index_name);
sys.stderr.write("Converting log file: %s to json.\n" % log_file);
sys.stderr.write("Verbose Mode: %s\n" % verbose);
sys.stderr.write("Missing values set to NULL: %s\n" % use_null);
sys.stderr.write("Only convert log lines that contain a query string: %s\n" % only_queries);



if(log_type=="GESDISC"): log_file_to_json(log_file, gesdisc_log_line_to_json, index_name, es_type, 0, use_null, only_queries, verbose);

elif(log_type=="ASDC"): log_file_to_json(log_file, asdc_log_line_to_json, index_name, es_type, 0, use_null, only_queries, verbose);

elif(log_type=="LPDAAC"): log_file_to_json(log_file, lpdaac_log_line_to_json, index_name, es_type, 0, use_null, only_queries, verbose);

elif (log_type=="NSIDC"): log_file_to_json(log_file, nsidc_log_line_to_json, index_name, es_type, 0, use_null, only_queries, verbose);

else: raise SystemExit












