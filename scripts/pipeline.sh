#!/usr/bin/env bash

# required environment variables:
#     CMAKE_PREFIX_PATH (qt-install-path/6.7.2/gcc_64)
#     QT_DIR (qt-install-path/6.7.2/gcc_64/lib/cmake/Qt6/)
# optional environment variables: BUILD_NUMBER

script_dir=$(dirname "$0")
source $script_dir/pipeline/common.sh

# usage: ./pipeline.sh --configure --analyze --build --sanity --test --robot --package --all --all-build-only
function print_usage {
    echo "usage: $0 [-c | --configure] [-l | --analyze] [-b | --build] [-s | --sanity] [-t | --test] [-r | --robot] [-p | --package] <build-type>
    or $0 [ -a | --all ] <build-type>
    or $0 [ -o | --all-build-only  ] <build-type>" >&2 # redirect stdout to stderr
#     exit 2
}

# if ! env | grep -q '^CMAKE_PREFIX_PATH=' ; then
#     echo "CMAKE_PREFIX_PATH must be set" >&2
#     exit 23
# elif ! env | grep -q '^QT_DIR=' ; then
#     echo "QT_DIR must be set" >&2
#     exit 23
# fi

# use "$@" to let command-line parameters expand to separate words
# options=$(getopt -n "pipeline" -a --options "a,b:,c::,h" --longoptions "a-long,b-long:,c-long::,help" -- "$@")
options=$(getopt -n "pipeline" -a --options "c,l,b,s,t,r,p,a,o,h" --longoptions "configure,analyze,build,sanity,test,robot,package,all,all-build-only,help" -- "$@")

valid_arguments=$# # the count of arguments that are in short or long options
if [[ $? != 0 ]] || [[ $valid_arguments == 0 ]] ; then
    print_usage
    exit 23
fi

eval set -- "$options"
unset options

declare -A pipeline_options=( ["configure"]=false ["analyze"]=false ["build"]=false ["sanity"]=false ["test"]=false ["robot"]=false ["package"]=false )

# ${pipeline_options[configure]} # value
# ${!pipeline_options[@]} # all keys
# ${pipeline_options[@]} # all values

# echo 
while true ; do
    case "$1" in
        "-h" | "--help") print_usage ; exit 0 ;;
        
        "-a"|"--all")
            for key in "${!pipeline_options[@]}"; do
                pipeline_options[$key]=true
            done
            shift
            continue
        ;;
        "-o"|"--all-build-only")
            pipeline_options["configure"]=true
            pipeline_options["build"]=true
            shift
            continue
        ;;
        
        "-c"|"--configure") pipeline_options["configure"]=true ; shift ; continue ;;
        "-l"|"--analyze") pipeline_options["analyze"]=true ; shift ; continue ;;
        "-b"|"--build") pipeline_options["build"]=true ; shift ; continue ;;
        "-s"|"--sanity") pipeline_options["sanity"]=true ; shift ; continue ;;
        "-t"|"--test") pipeline_options["test"]=true ; shift ; continue ;;
        "-r"|"--robot") pipeline_options["robot"]=true ; shift ; continue ;;
        "-p"|"--package") pipeline_options["package"]=true ; shift ; continue ;;
        
        "--")
            shift
            break
        ;;
        *)
            echo "unexpected option: $1" >&2
            print_usage
            exit 23
        ;;
    esac
done

# echo "remaining arguments: count = $#, value = $@"
# for arg in "$@" ; do
# for arg ; do # same as above but shorter
#     echo "--> '$arg'"
# done

if [[ $# != 1 ]] ; then
    print_usage
    exit 23
fi

build_type=$1

# for key in "${!pipeline_options[@]}"; do echo "$key -> ${pipeline_options[$key]}" ; done

# BUILD_NUMBER is an optional environment variable (only set by jenkins), set it if not already
if ! env | grep -q '^BUILD_NUMBER=' ; then
   export BUILD_NUMBER=0
fi

# if ${pipeline_options["init"]} ; then
version=$(cat version.txt | xargs)
project_name=$(basename "$PWD")
# fi

echo "pipeline params: version=${version}, project_name=${project_name}, build_type=$build_type, BUILD_NUMBER=$BUILD_NUMBER"

# exit 0

# set -x

if ${pipeline_options["configure"]} ; then scripts/pipeline/configure.sh $build_type ; exit_if_last_result_not_zero ; fi
if ${pipeline_options["analyze"]} ; then scripts/pipeline/analyze.sh src/ tests/unit_tests/ ; exit_if_last_result_not_zero ; fi
if ${pipeline_options["build"]} ; then scripts/pipeline/build.sh $build_type ; exit_if_last_result_not_zero ; fi
if ${pipeline_options["sanity"]} ; then scripts/pipeline/test_sanity.sh builds/build_${build_type}/${project_name} hello world ; exit_if_last_result_not_zero ; fi
if ${pipeline_options["test"]} ; then scripts/pipeline/test_units.sh $build_type ; exit_if_last_result_not_zero ; fi
if ${pipeline_options["robot"]} ; then scripts/pipeline/test_robot.sh builds/build_${build_type}/${project_name} tests/robot/tests.robot ; exit_if_last_result_not_zero ; fi
if ${pipeline_options["package"]} ; then scripts/pipeline/package.sh builds/build_${build_type}/${project_name} tests/robot/output/ ${project_name}_v${version}-build.${BUILD_NUMBER}_${build_type} ; exit_if_last_result_not_zero ; fi

# set +x

# ansi escape codes
red='\033[0;31m'
green='\033[0;32m'
uncolored='\033[0m' # No Color

echo -e "pipeline ${green}successful${uncolored}!"

exit 0