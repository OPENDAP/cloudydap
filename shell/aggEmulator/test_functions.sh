#!/bin/sh


function all_agg_tests() {
    
    use_case_id=$1;
    
    tests=`ls arch?_*`
    for myTest in $tests
    do
        ./$myTest $use_case_id
    done

}

function all_airs_agg_tests() {
    
    use_case_id=$1;
    
    tests=`ls arch?_airs_agg_test_*`
    for myTest in $tests
    do
        ./$myTest $use_case_id
    done

}

function all_merra2_agg_tests() {
    
    use_case_id=$1;
    
    tests=`ls arch?_merra2_agg_test_*`
    for myTest in $tests
    do
        ./$myTest $use_case_id
    done

}

function all_arch1_agg_tests() {
    
    use_case_id=$1;
    
    tests=`ls arch1_*_agg_test_*`
    for myTest in $tests
    do
        ./$myTest $use_case_id
    done

}

function all_arch2_agg_tests() {
    
    use_case_id=$1;
    
    tests=`ls arch2_*_agg_test_*`
    for myTest in $tests
    do
        ./$myTest $use_case_id
    done

}

function all_arch3_agg_tests() {
    
    use_case_id=$1;
    
    tests=`ls arch3_*_agg_test_*`
    for myTest in $tests
    do
        ./$myTest $use_case_id
    done

}


function all_single_value_agg_tests() {
    
    use_case_id=$1;
    
    tests=`ls *_agg_test_single_value`
    for myTest in $tests
    do
        ./$myTest $use_case_id
    done

}

function all_decimate_subset_agg_tests() {
    
    use_case_id=$1;
    
    tests=`ls *_agg_test_decimate_subset`
    for myTest in $tests
    do
        ./$myTest $use_case_id
    done

}


function all_area_subset_agg_tests() {
    
    use_case_id=$1;
    
    tests=`ls *_agg_test_area_subset`
    for myTest in $tests
    do
        ./$myTest $use_case_id
    done

}


