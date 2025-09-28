#!/usr/bin/env bash

script_dir=$(dirname "$0")
source $script_dir/common.sh

ctest --test-dir builds/build_${BUILD_TYPE} -T test
exit_if_last_result_not_zero

ctest --test-dir builds/build_${BUILD_TYPE} -T coverage
exit_if_last_result_not_zero

exit 0