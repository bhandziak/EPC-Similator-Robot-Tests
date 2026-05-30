*** Settings ***
Resource          ../resources/features/ue_attachment.resource
Resource          ../resources/features/ue_detachment.resource
Resource          ../resources/features/add_bearer_to_ue.resource
Resource          ../resources/features/additional_tests.resource
Resource          ../resources/features/transfer_start.resource
Resource          ../resources/features/remove_bearer_from_ue.resource
Resource          ../resources/features/transfer_stop.resource
Resource          ../resources/common.resource
Resource          ../resources/features/check_connected_bearers.resource
Variables         ../config/env.yaml

Test Teardown     Reset Simulation


*** Test Cases ***
1. Failed UE Attachment With Negative UE ID
    Attach UE with ID = -1 To Network
    Attachment Should Be Rejected To Invalid UE ID
    Error Message Should Be Input should be greater than or equal to 1

2. Failed Addition of Bearer With Non-Attached UE
    Add Bearer With ID = 5 To UE With ID = 1
    Bearer Addition Should Be Rejected Due To Non-Attached UE
    Error Detail Message Should Be UE not found

3. Failed Data Transmission For Invalid Bearer ID
    [Setup]    UE with ID = 1 Attaches Successfully
    Start Data Transmission for UE with ID = 1, BEARER with ID = 19 and SPEED = 50 Mbps
    Transmission Should Be Rejected

4. Failed Data Transmission For Non-Attached UE ID
    Start Data Transmission for UE with ID = 10, BEARER with ID = 1 and SPEED = 50 Mbps
    Transmission Should Be Rejected
    Error Detail Message Should Be UE not found

5. Failed Removal Of Bearer With Non-Attached UE ID
    Remove Bearer With ID = 5 From UE With ID = 10
    Bearer Removal Should Be Rejected
    Error Detail Message Should Be UE not found

6. Successful UE Dettachment With Maximum Valid UE ID
    [Setup]    UE with ID = 100 Attaches Successfully
    Detach UE with ID = 100 From Network
    Detachment Status Should Be Successful For UE ID = 100

7. Stop Transmission For Bearer With Non-Attached UE ID
    Stop data transmission for UE with ID = 10 and bearer with ID = 5
    Transmission stop should be rejected
    Error Detail Message Should Be UE not found

8. Successful Connected Bearers Retrieval For Attached UE
    [Setup]    UE with ID = 1 Attaches Successfully
    Get Connected Bearers For UE With ID = 1
    Connected Bearers Retrieval Should Be Successful

9. Successful Connected Bearers Retrieval For Attached UE With Added Bearer
    [Setup]    Successful Bearer With ID = 5 Addition To Attached UE With ID = 1
    Get Connected Bearers For UE With ID = 1
    Connected Bearers Retrieval Should Be Successful
    Connected Bearers List Should Contain Bearer 5

