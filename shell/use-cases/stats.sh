#!/bin/bash


mean_stdev()
{
    echo "$1" |
        awk '
        {
            if(NR==0){
                max=$1;
                min=$1;
            }
            sum+=$1; 
            sumsq+=$1*$1
            if(max<$1){
                max=$1;
            }
            if(min>$1){
                min=$1;
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
    echo  $file" "$( mean_stdev "$vals" );    

done
