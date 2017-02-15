#!/bin/bash
# Copyright (C) 2016-2017 The HDF Group
# All rights reserved.
#
# This shell script runs all use case test scripts.
#
# Update your auth key location.
AUTH_KEY="/Users/ndp/.ssh/RayrayAWS.pem";
USER=centos
SYSTEM=cloudydap.opendap.org
TEST_DIR="/home/centos/hyrax/cloudydap/shell/use-cases";

function remote_test(){
    test_name=$1;
    ssh -i $AUTH_KEY $USER"@"$SYSTEM "$TEST_DIR/$test_name";
}
   
    
echo 'Test Arch #1 UC2.'
./test_2.sh
echo 'Test Arch #2 UC2.'
./test_2_arch2.sh
echo 'Test Arch #3 UC2.'
./test_2_arch3.sh

for i in 6 7 10 11 12 13 14 15
do
    echo 'Test Arch #1 UC'$i
    remote_test "test_"$i".sh"
    echo 'Test Arch #2 UC'$i
    remote_test "test_"$i"_arch2.sh"
    echo 'Test Arch #3 UC'$i
    remote_test "test_"$i"_arch3.sh"
done
    



