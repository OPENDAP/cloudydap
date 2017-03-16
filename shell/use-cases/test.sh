#!/bin/bash
#
# This shell script runs all use case test scripts.
#
# Update your auth key location.
AUTH_KEY="/Users/ndp/.ssh/RayrayAWS.pem";
USER=centos
SYSTEM=cloudydap.opendap.org
TEST_DIR="/home/centos/hyrax/cloudydap/shell/use-cases";
REMOTE_TESTS="6 7 10 11 12 13 14 15 16 17 18 19 20 21"

source ./nap_time.sh

function remote_test(){
    test_name=$1;
    #ssh -i $AUTH_KEY $USER"@"$SYSTEM "$TEST_DIR/$test_name";
}
   
    


echo "##################################"
echo "Running All Architecture 1 Tests."

echo "Testing UC2 Arch #1"
time -p { ./test_2.sh > logs/test_2_arch1.log 2>&1 ; }
for i in $REMOTE_TESTS
do
    echo "Testing UC"$i" Arch #1"
    time -p { remote_test "test_"$i".sh" > "logs/test_"$i"_arch1.log" 2>&1 ; }
done

sleep_until_5_past;

echo "##################################"
echo "Running All Architecture 2 Tests."
    
echo "Testing UC2 Arch #2"
time -p { ./test_2_arch2.sh > logs/test_2_arch2.log 2>&1 ; }

for i in $REMOTE_TESTS
do
    echo "Testing UC"$i" Arch #2"
    time -p { remote_test "test_"$i"_arch2.sh" > "logs/test_"$i"_arch2.log" 2>&1 ; }

done
    
sleep_until_5_past;

echo "##################################"
echo "Running All Architecture 3 Tests."

echo "Testing UC2 Arch #3"
time -p { ./test_2_arch3.sh > logs/test_2_arch3.log 2>&1 ; }

for i in $REMOTE_TESTS
do
    echo "Testing UC"$i" Arch #3";
    time -p { remote_test "test_"$i"_arch3.sh" > "logs/test_"$i"_arch3.log" 2>&1 ; }

done
    



