#!/usr/bin/env bash

script_dir=$(dirname "$0")
source $script_dir/common.sh

function print_usage {
    echo "usage: $0 <executable-path> <robot-output-path> <output-package-filename>" >&2
}

if [[ $# != 3 ]] ; then
    print_usage
    exit 23
fi

executable_path="$1"
robot_output_path="$2"
package_filename=$3

mkdir artifacts

cp "$executable_path" artifacts/
exit_if_last_result_not_zero

mkdir -p artifacts/robot

cp -a "$robot_output_path/." artifacts/robot
exit_if_last_result_not_zero

tar -czf $package_filename.tar.gz artifacts
exit_if_last_result_not_zero

rm -rf artifacts

exit 0