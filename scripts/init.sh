#!/usr/bin/env bash

# script_dir=$(dirname "$0")
# source $script_dir/common.sh

# check if env variables (BUILD_TYPE, etc.) correctly set?

rm -rf builds/build_${BUILD_TYPE}
rm -rf artifacts
mkdir artifacts

# exit_if_last_result_not_zero

exit 0