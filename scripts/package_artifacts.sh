#!/usr/bin/env bash

script_dir=$(dirname "$0")
source $script_dir/common.sh

function print_usage {
    echo "Usage: $0 [output package filename]" >&2 # redirect stdout to stderr
}

if [[ $# -ne 1 ]]; then
    print_usage
    exit 23
fi

package_filename=$1

tar -czf $package_filename.tar.gz artifacts
exit_if_last_result_not_zero

exit 0