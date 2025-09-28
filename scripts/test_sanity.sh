#!/usr/bin/env bash

script_dir=$(dirname "$0")
source $script_dir/common.sh

parameters="$@"

valgrind --tool=memcheck --leak-check=full --error-exitcode=23 builds/build_${BUILD_TYPE}/${PROJECT_NAME} $parameters
# --log-file=<filename> --xml=yes --xml-file=<filename>
# --gen-suppressions=all --track-origins=yes
exit_if_last_result_not_zero

exit 0