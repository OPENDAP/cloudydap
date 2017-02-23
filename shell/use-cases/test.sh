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
   
    
echo 'Testing UC2 Arch #1'
./test_2.sh
echo 'Testing UC2 Arch #2'
./test_2_arch2.sh
echo 'Testing UC2 Arch #3.'
./test_2_arch3.sh

for i in 6 7 10 11 12 13 14 15 16 17
do
    echo 'Testing UC'$i' Arch #1'
    remote_test "test_"$i".sh"
    
    echo 'Testing UC'$i' Arch #2'
    remote_test "test_"$i"_arch2.sh"
    
    echo 'Testing UC'$i' Arch #3'
    remote_test "test_"$i"_arch3.sh"

done
    



