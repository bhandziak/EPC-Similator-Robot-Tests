*** Settings ***
Resource          ../resources/features/eu_attachment.resource
Resource          ../resources/common.resource
Variables         ../config/env.yaml

*** Keywords ***

UE Attachment is Rejected
    [Arguments]    ${UE_ID}    ${expected_message}
    
    Attach ${UE_ID} To Network
    Attachment Status Should Be Rejected
    Verify If Error Message Is ${expected_message}


*** Test Cases ***
Successful UE Attachment
    [Template]         UE Attaches Successfully
    [Teardown]    Reset Simulation
    # UE IDS
    1
    2
    99
    100

Failed UE Attachment With Out Of Range UE ID
    [Template]         UE Attachment is Rejected
    [Teardown]    Reset Simulation
    # UE_ID    EXPECTED_MESSAGE
    0    Input should be greater than or equal to 1
    101    Input should be less than or equal to 100

Failed UE Attachment With Non-Integer UE ID
    [Template]         UE Attachment is Rejected
    [Teardown]    Reset Simulation
    # UE_ID    EXPECTED_MESSAGE
    string     Input should be a valid integer, unable to parse string as an integer
    1.5        Input should be a valid integer, unable to parse string as an integer

Failed UE Attachment With Null UE ID
    [Template]         UE Attachment is Rejected
    [Teardown]    Reset Simulation
    # UE_ID    EXPECTED_MESSAGE
    ${null}     Input should be a valid integer

Failed UE Attachment When UE ID Is Already Attached
    [Setup]    UE Attaches Successfully    ${1}

    Attach ${1} To Network
    Attachment Should Be Rejected Due To Already Attached UE ID

    [Teardown]    Reset Simulation

Attached UE Automatically Receives Default Bearer
    [Setup]    UE Attaches Successfully    ${1}
      
    Verify If ${1} Has Default Bearer

    [Teardown]    Reset Simulation