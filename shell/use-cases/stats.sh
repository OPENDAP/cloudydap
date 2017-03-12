#!/bin/bash


basic_stats()
{
    echo "$1" |
        awk '
        {
            #print "Value: "$1;
            if(NR==1){
                max=$1;
                min=$1;
                #print "initialized max: "max" min: "min;
            }
            sum+=$1; 
            sumsq+=$1*$1
            if(max<$1){
                max=$1;
                #print "********** Changed max to "max;
            }
            if(min>$1){
                min=$1;
                #print "********** Changed min to "min;
            }
        }
        END{ 
            mean=sum/NR; 
            stdev=sqrt(sumsq/NR - (sum/NR)**2); 
            printf("n=%4d, min=%4.2f,  mean=%6.2f +/-%6.2f,  max=%6.2f",NR,min,mean,stdev,max);
        }' -
}


for file in "$@"
do
    vals=`grep real $file | awk '{print $2}' -`;
    #stats "$vals";    
    echo  $file"  "$( basic_stats "$vals" );    

done
