#!/usr/bin/env bash

script_dir=$(dirname "$0")
source $script_dir/common.sh

function print_usage {
    echo "usage: $0 <build-type>" >&2
}

if [[ $# != 1 ]] ; then
    print_usage
    exit 23
fi

build_type=$1

cmake -DCMAKE_BUILD_TYPE=$build_type -S . -B builds/build_$build_type
exit_if_last_result_not_zero

exit 0