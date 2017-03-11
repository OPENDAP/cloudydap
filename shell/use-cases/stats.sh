#!/bin/bash


mean_stdev()
{
    echo "$1" |
        awk '
        {
            print "Value: "$1;
            if(NR==1){
                max=$1;
                min=$1;
                print "initialized max: "max" min: "min;
            }
            sum+=$1; 
            sumsq+=$1*$1
            if(max<$1){
                max=$1;
                print "********** Changed max to "max;
            }
            if(min>$1){
                min=$1;
                print "********** Changed min to "min;
            }
        }
        END{ 
            mean=sum/NR; 
            stdev=sqrt(sumsq/NR - (sum/NR)**2); 
            printf("n: %d min: %d max: %d mean: %.2f stdev: %.2f",NR,min,max,mean,stdev);
        }' -
}


for file in "$@"
do
    vals=`grep real $file | awk '{print $2}' -`;
    mean_stdev "$vals";    
    #echo  $file" "$( mean_stdev "$vals" );    

done
