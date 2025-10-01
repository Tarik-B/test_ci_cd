#!/usr/bin/env bash

script_dir=$(dirname "$0")
source $script_dir/common.sh

function print_usage {
    echo "usage: $0 <executable-path> <executable-arguments>" >&2
}

if [[ $# < 2 ]] ; then
    print_usage
    exit 23
fi

executable_path="$1"
executable_arguments=${@:2} # all arguments after the first one

valgrind --tool=memcheck --leak-check=full --error-exitcode=23 "$executable_path" $executable_arguments
# --log-file=<filename> --xml=yes --xml-file=<filename>
# --gen-suppressions=all --track-origins=yes
exit_if_last_result_not_zero

exit 0