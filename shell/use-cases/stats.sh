#!/bin/bash


mean_stdev()
{
    echo "$1" |
        awk '
        {
            sum+=$1; 
            sumsq+=$1*$1}
        END{ 
            mean=sum/NR; 
            stdev=sqrt(sumsq/NR - (sum/NR)**2); 
            printf("n: %d mean: %.2f stdev: %.2f",NR,mean,stdev);
        }' -
}


for file in "$@"
do
    vals=`grep real $file | awk '{print $2}' -`;
    echo  $file" "$( mean_stdev "$vals" );    

done
