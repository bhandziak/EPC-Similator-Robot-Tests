*** Settings ***
Resource          ../resources/features/ue_attachment.resource
Resource          ../resources/features/ue_detachment.resource
Resource          ../resources/common.resource
Variables         ../config/env.yaml

Test Teardown     Reset Simulation

*** Test Cases ***
1. Successful UE Detachment
    # Attach UE first
    Attach UE with ID = 1 To Network
    Attachment Should Be Successful For UE ID = 1

    # Detach UE
    Detach UE with ID = 1 From Network
    Detachment Status Should Be Successful For UE ID = 1


2. Failed Detachment When UE Is Not Connected
    UE with ID = 1 Should Not Be Attached
    Detach UE with ID = 1 From Network
    Detachment Should Be Rejected Due To Already Attached UE ID
    UE with ID = 1 Should Not Be Attached

3. Failed Detachment With Invalid UE ID
    Detach UE with ID = abc From Network
    Detachment Should Be Rejected Due To Invalid UE ID
    Error Message Should Be Input should be a valid integer, unable to parse string as an integer
