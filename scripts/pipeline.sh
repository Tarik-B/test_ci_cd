#!/usr/bin/env bash

# script_dir=$(dirname "$0")
# source $script_dir/common.sh

# usage: ./pipeline.sh --init --configure --analyze --build --sanity --test --robot --package --all --all-build-only
function print_usage {
    echo "Usage: $0 [-i | --init] [-c | --configure] [-l | --analyze] [-b | --build] [-s | --sanity] [-t | --test] [-r | --robot] [-p | --package]
    or $0 [ -a | --all ]
    or $0 [ -o | --all-build-only  ]" >&2 # redirect stdout to stderr
#     exit 2
}

# use "$@" to let command-line parameters expand to separate words
# options=$(getopt -n "pipeline" -a --options "a,b:,c::,h" --longoptions "a-long,b-long:,c-long::,help" -- "$@")
options=$(getopt -n "pipeline" -a --options "i,c,l,b,s,t,r,p,a,o,h" --longoptions "init,configure,analyze,build,sanity,test,robot,package,all,all-build-only,help" -- "$@")

valid_arguments=$# # the count of arguments that are in short or long options
if [ $? -ne 0 ] || [ $valid_arguments -eq 0 ] ; then
    print_usage
    exit 23
fi

eval set -- "$options"
unset options

declare -A pipeline_options=( ["init"]=false ["configure"]=false ["analyze"]=false ["build"]=false ["sanity"]=false ["test"]=false ["robot"]=false ["package"]=false )

# ${pipeline_options[init]} # value
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
#             pipeline_options["init"]=true
            pipeline_options["configure"]=true
            pipeline_options["build"]=true
            shift
            continue
        ;;
        
        "-i"|"--init") pipeline_options["init"]=true ; shift ; continue ;;
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

# echo "Remaining arguments:"
# for arg; do
#     echo "--> '$arg'"
# done

for key in "${!pipeline_options[@]}"; do echo "$key -> ${pipeline_options[$key]}" ; done

# if ${pipeline_options["init"]} ; then scripts/init.sh ; fi
# if ${pipeline_options["configure"]} ; then scripts/configure.sh ; fi
# if ${pipeline_options["analyze"]} ; then scripts/analyze.sh src/ tests/unit_tests/ ; fi
# if ${pipeline_options["build"]} ; then scripts/build.sh ; fi
# if ${pipeline_options["sanity"]} ; then scripts/test_sanity.sh hello world ; fi
# if ${pipeline_options["test"]} ; then scripts/test_units.sh ; fi
# if ${pipeline_options["robot"]} ; then  ; fi
# if ${pipeline_options["package"]} ; then scripts/package_artifacts.sh ${PROJECT_NAME}_v${VERSION}-build.${BUILD_NUMBER}_${BUILD_TYPE} ; fi

# exit_if_last_result_not_zero

exit 0