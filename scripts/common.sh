#!/usr/bin/env bash

function exit_if_last_result_not_zero {
    result=$?
#     echo "result is $result"
    if [ $result -ne 0 ] ; then
#         echo "result $result not zero, exiting"
        exit $result
#     else
#         echo "result zero, ok"
    fi
}