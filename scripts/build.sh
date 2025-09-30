#!/usr/bin/env bash

script_dir=$(dirname "$0")
source $script_dir/common.sh

cmake --build builds/build_${BUILD_TYPE} # -- VERBOSE=1 # the -- before VERBOSE=1 passes the argument to the underlying make process
exit_if_last_result_not_zero

exit 0