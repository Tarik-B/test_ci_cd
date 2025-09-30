#!/usr/bin/env -S bash

if [ ! -d .venv/ ] ; then
    python3 -m venv .venv
fi

source .venv/bin/activate
pip3 install robotframework

robot --outputdir output --variable BUILD_TYPE:${BUILD_TYPE} tests.robot

deactivate

exit 0
