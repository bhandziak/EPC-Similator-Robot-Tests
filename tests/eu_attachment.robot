*** Settings ***
Resource          ../resources/features/eu_attachment.resource
Resource          ../resources/common.resource
Variables         ../config/env.yaml

*** Keywords ***
UE attaches successfully
    [Arguments]    ${UE_ID}
    
    Attach ${UE_ID} To Network
    Attachment Status Should Be Successful
    Verify If ${UE_ID} Is Attached

    [Teardown]    Reset Simulation

UE attachment is rejected
    [Arguments]    ${UE_ID}    ${expected_message}
    
    Attach ${UE_ID} To Network
    Attachment Status Should Be Rejected
    Verify If Error Message Is ${expected_message}

    [Teardown]    Reset Simulation


*** Test Cases ***
Successful UE Attachment
    [Template]         UE attaches successfully
    # UE IDS
    1
    2
    99
    100

Failed UE Attachment With Out Of Range UE ID
    [Template]         UE attachment is rejected
    # UE_ID    EXPECTED_MESSAGE
    0    Input should be greater than or equal to 1
    101    Input should be less than or equal to 100

Failed UE Attachment With Non-Integer UE ID
    [Template]         UE attachment is rejected
    # UE_ID    EXPECTED_MESSAGE
    string     Input should be a valid integer, unable to parse string as an integer
    1.5        Input should be a valid integer, unable to parse string as an integer

Failed UE Attachment With Null UE ID
    [Template]         UE attachment is rejected
    # UE_ID    EXPECTED_MESSAGE
    ${null}     Input should be a valid integer
    