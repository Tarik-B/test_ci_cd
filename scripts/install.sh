#!/usr/bin/env bash

# if [ $EUID -ne 0 ] ; then
#    echo "Must be run as root" 
#    exit 23
# fi

# sudo
cmake --install builds/build_${BUILD_TYPE} --strip --prefix "install/"

exit 0