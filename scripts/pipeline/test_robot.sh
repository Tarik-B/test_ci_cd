#!/usr/bin/env -S bash

script_dir=$(dirname "$0")
source $script_dir/common.sh

function print_usage {
    echo "usage: $0 <executable-path> <robot-file-path>" >&2
}

if [[ $# != 2 ]] ; then
    print_usage
    exit 23
fi

executable_path="$1"
robot_file_path="$2"

robot_path=$(dirname "$robot_file_path")

if [ ! -d "$robot_path/.venv/" ] ; then
    python3 -m venv "$robot_path/.venv"
    exit_if_last_result_not_zero
fi

source "$robot_path/.venv/bin/activate"
exit_if_last_result_not_zero

pip3 install robotframework
exit_if_last_result_not_zero

robot --outputdir "$robot_path/output" --variable "EXECUTABLE_PATH:$executable_path" "$robot_file_path"
exit_if_last_result_not_zero

deactivate
exit_if_last_result_not_zero

exit 0
