*** Settings ***
Resource    ../resources/features/ue_attachment.resource
Resource    ../resources/features/transfer_start.resource
Resource    ../resources/features/transfer_stats.resource
Resource    ../resources/common.resource
Variables   ../config/env.yaml

Test Setup       UE with ID = 1 Attaches Successfully
Test Teardown    Reset Simulation

*** Test Cases ***

1. Successful Data Transmission Start
    [Documentation]    Transmission should start successfully for valid UE, bearer and speed.

    Start Data Transmission for UE with ID = 1, BEARER with ID = 9 and SPEED = 50 Mbps
    Transmission Should Be Successful


2. Failed Data Transmission With Out Of Range Speed
    [Documentation]    Transmission should be rejected when speed exceeds allowed limit.

    Start Data Transmission for UE with ID = 1, BEARER with ID = 9 and SPEED = 200 Mbps
    Transmission Should Be Rejected
    

3. Failed Data Transmission For Inactive Bearer
    [Documentation]    Transmission should fail if bearer is not active.

    Start Data Transmission for UE with ID = 1, BEARER with ID = 5 and SPEED = 50 Mbps
    Transmission Should Be Rejected

4. Failed Data Transmission For Negative Speed
    [Documentation]    Transmission should be rejected when speed is negative.

    Start Data Transmission for UE with ID = 1, BEARER with ID = 9 and SPEED = -10 Mbps
    Transmission Should Be Rejected

5. Double Data Transmission Start
    [Documentation]    Starting transmission twice should be rejected.

    Start Data Transmission for UE with ID = 1, BEARER with ID = 9 and SPEED = 50 Mbps
    Transmission Should Be Successful

    Start Data Transmission for UE with ID = 1, BEARER with ID = 9 and SPEED = 50 Mbps
    Transmission Should Be Rejected
    Error Detail Message Should Be Traffic already running