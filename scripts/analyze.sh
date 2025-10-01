#!/usr/bin/env bash

script_dir=$(dirname "$0")
source $script_dir/common.sh

function print_usage {
    echo "usage: $0 <source-paths>" >&2
}

if [[ $# == 0 ]] ; then
    print_usage
    exit 23
fi

source_paths="$@"

cppcheck --language=c++ --std=c++17 --enable=all --suppress=missingIncludeSystem --suppress=checkersReport --suppress=unmatchedSuppression --error-exitcode=23 $source_paths
# --project=builds/build_${BUILD_TYPE}/compile_commands.json # find a way to exclude moc files (-i) and run cmake -B before this
# --checkers-report=cppcheck.report
# --inline-suppr # "unusedFunction check can't be used with '-j'"
# -j 8
exit_if_last_result_not_zero

# run-clang-tidy -j 8 -p builds/build_${BUILD_TYPE} # run-clang-tidy runs clang-tidy over everything in compile_commands.json at specified path
# exit_if_last_result_not_zero

exit 0