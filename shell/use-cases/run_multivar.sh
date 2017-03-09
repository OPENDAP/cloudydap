#!/bin/bash


function run_multivar() {

for i in 17 18 19 20 21
do
    echo "";
    echo "Test $i A1"
    time -p { "test_"$i".sh"       > log/"test_"$i"_arch1.log" 2>&1 ;}
    
    echo "";
    echo "Test $i A2"
    time -p { "test_"$i"_arch2.sh" > log/"test_"$i"_arch2.log" 2>&1 ;}
    
    echo "";
    echo "Test $i A3"
    time -p { "test_"$i"_arch3.sh" > log/"test_"$i"_arch3.log" 2>&1 ;}

done

}
