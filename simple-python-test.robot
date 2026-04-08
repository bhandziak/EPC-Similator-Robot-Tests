*** Settings ***
Documentation    Example: default counter value, variables/tags, Python library, and composed keywords.
Library          SimpleExampleLibrary.py

*** Variables ***
# Suite-wide values keep data out of the steps and easy to change.
${DEFAULT_COUNT}         0
${EXPECTED_COUNT}        5
${EXPECTED_AFTER_TWO}    10

*** Test Cases ***
Counter Default Value Is Zero
    [Documentation]    Library starts at 0 in Python (__init__); with scope TEST a new instance runs per test.
    [Tags]    example    default
    Verify Counter Is    ${DEFAULT_COUNT}

Counter With Python Library
    [Documentation]    Reset, add five once, then expect five.
    [Tags]    example    python-library
    Reset Counter
    Add Five To Counter
    Verify Counter Is    ${EXPECTED_COUNT}

Counter With Composed Robot Keywords
    [Documentation]    Composed keyword adds five twice after an explicit reset inside the keyword.
    [Tags]    example    keywords
    Build Counter To Ten
    Verify Counter Is    ${EXPECTED_AFTER_TWO}

*** Keywords ***
Build Counter To Ten
    [Documentation]    Reset, then call the Python keyword twice so the counter reaches ten.
    Reset Counter
    Add Five To Counter
    Add Five To Counter

Verify Counter Is
    [Documentation]    Reads the counter from the Python library and asserts with BuiltIn.
    [Arguments]    ${expected}
    ${current}=    Get Counter Value
    Should Be Equal As Integers    ${current}    ${expected}
