#!/usr/bin/env bash

script_dir=$(dirname "$0")
source $script_dir/common.sh

cmake -DCMAKE_BUILD_TYPE=${BUILD_TYPE} -S . -B builds/build_${BUILD_TYPE}
exit_if_last_result_not_zero

exit 0