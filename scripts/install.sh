#!/usr/bin/env bash

function print_usage {
    echo "usage: $0 <build-type>" >&2
}

if [[ $# != 1 ]] ; then
    print_usage
    exit 23
fi

build_type=$1

# if [ $EUID -ne 0 ] ; then
#    echo "Must be run as root" 
#    exit 23
# fi

# sudo
cmake --install builds/build_$build_type --strip --prefix "install/"

exit 0