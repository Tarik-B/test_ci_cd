*** Settings ***
Library	Process

*** Test Cases ***
Run executable with valid arguments
    [Template]    Example of valid
    hello    world

Run executable with too many characters
    [Template]    Example of too many characters
    hello1    world2
    123456    1
    1    123456

*** Keyword ***
Executable
    [Arguments]     ${arg1}     ${arg2}
    ${result} =	Run Process	${CURDIR}/../../builds/build_${BUILD_TYPE}/test_ci_cd   ${arg1}     ${arg2}
    [Return]    ${result}

Example of valid
    [Arguments]     ${arg1}     ${arg2}
    ${result} =	Executable     ${arg1}     ${arg2}
    Should be equal as strings  ${result.stdout}    hello, world

Example of too many characters
    [Arguments]     ${arg1}     ${arg2}
    ${result} =	Executable     ${arg1}     ${arg2}
    Should be equal as strings  ${result.stdout}    Error: Too many chracter
