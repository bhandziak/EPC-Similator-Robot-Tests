*** Settings ***
Resource          ../resources/features/check_connected_bearers.resource
Resource          ../resources/features/ue_attachment.resource
Resource          ../resources/common.resource
Variables         ../config/env.yaml

Test Teardown     Reset Simulation

*** Test Cases ***
1. Successful Connected Bearers Retrieval For Attached UE
    Attach UE with ID = 1 To Network
    Attachment Status Should Be Successful
    UE with ID = 1 Should Be Attached

    Get Connected Bearers For UE With ID = 1
    Connected Bearers Retrieval Should Be Successful
    Connected Bearers List Should Contain Bearer 9

2. Failed Connected Bearers Retrieval For Not Attached UE
    UE With ID = 1 Should Not Be Attached

    Get Connected Bearers For UE With ID = 1
    Connected Bearers Retrieval Should Be Rejected
    check_connected_bearers.Error Message Should Be UE not found