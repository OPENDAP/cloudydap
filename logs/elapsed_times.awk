BEGIN {
    start = 0;
    stop = 1;
    name = "NONAME"
}   
{

    if($0 ~ /^date.*/ ){
        gsub(/`|'/, "",$0);
        name  = $4;
        start = 0;
        stop  = 1;
    }
    else if(stop == 0){
        stop=$1;
        #print "stop " stop;
        elapsed = stop - start;
        printf("%s start: %d stop: %d elapsed: %d\n",name, start, stop, elapsed);
        start = 0;
    }
    else if(start == 0){
        start = $1;
        #print "start " start;
        stop = 0;
    }
        
    
}