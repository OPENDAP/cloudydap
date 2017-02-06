#!/bin/bash
# Copyright (C) 2016-2017 The HDF Group
# All rights reserved.
#
# This shell script runs all use case test scripts.
#
echo 'Test Arch #1 UC2.'
./test_2.sh
echo 'Test Arch #2 UC2.'
./test_2_arch2.sh
echo 'Test Arch #3 UC2.'
./test_2_arch3.sh

# Change your key.
echo 'Test Arch #1 UC6.'
ssh -i /Users/hyoklee/.ssh/RayrayAWS.pem centos@cloudydap.opendap.org '/home/centos/hyrax/cloudydap/shell/use-cases/test_6.sh'
echo 'Test Arch #2 UC6.'
ssh -i /Users/hyoklee/.ssh/RayrayAWS.pem centos@cloudydap.opendap.org '/home/centos/hyrax/cloudydap/shell/use-cases/test_6_arch2.sh'
echo 'Test Arch #3 UC6.'
ssh -i /Users/hyoklee/.ssh/RayrayAWS.pem centos@cloudydap.opendap.org '/home/centos/hyrax/cloudydap/shell/use-cases/test_6_arch3.sh'

echo 'Test Arch #1 UC7.'
ssh -i /Users/hyoklee/.ssh/RayrayAWS.pem centos@cloudydap.opendap.org '/home/centos/hyrax/cloudydap/shell/use-cases/test_7.sh'
echo 'Test Arch #2 UC7.'
ssh -i /Users/hyoklee/.ssh/RayrayAWS.pem centos@cloudydap.opendap.org '/home/centos/hyrax/cloudydap/shell/use-cases/test_7_arch2.sh'
echo 'Test Arch #3 UC7.'
ssh -i /Users/hyoklee/.ssh/RayrayAWS.pem centos@cloudydap.opendap.org '/home/centos/hyrax/cloudydap/shell/use-cases/test_7_arch3.sh'
