*** Settings ***
Resource    ../resources/features/eu_attachment.resource
Resource    ../resources/features/data_transfer.resource
Resource    ../resources/common.resource
Variables   ../config/env.yaml


*** Test Cases ***


# 1. Successful Data Transmission Start
Successful Data Transmission Start
    [Documentation]    Transmission should start successfully for valid UE, bearer and speed.
    [Setup]       UE Attaches Successfully    ${1}
    [Teardown]    Reset Simulation

    Start Data Transmission    1    9    50

    Transmission Should Be Successful


# 2. Failed Data Transmission With Out Of Range Speed
Failed Data Transmission With Out Of Range Speed
    [Documentation]    Transmission should be rejected when speed exceeds allowed limit.
    [Setup]       UE Attaches Successfully    ${1}
    [Teardown]    Reset Simulation

    Start Data Transmission    1    9    200

    Transmission Should Be Rejected
    


# 3. Failed Data Transmission For Inactive Bearer
Failed Data Transmission For Inactive Bearer
    [Documentation]    Transmission should fail if bearer is not active.
    [Setup]       UE Attaches Successfully    ${1}
    [Teardown]    Reset Simulation

    Add Bearer    1    5

    Start Data Transmission    1    5    50

    Transmission Should Be Rejected


# 4. Check Transfer For Single Bearer
Check Transfer For Single Bearer
    [Documentation]    System should return correct transfer value for specific bearer.
    [Setup]       UE Attaches Successfully    ${1}
    [Teardown]    Reset Simulation

    Add Bearer    1    5
    Start Data Transmission    1    5    40

    ${result}=    Get Transfer For Bearer    1    5

    Should Be True    ${result}[tx_bps] > 0


# 5. Check Total Transfer For UE
Check Total Transfer For UE
    [Documentation]    System should return sum of all active bearer transfers.
    [Setup]       UE Attaches Successfully    ${1}
    [Teardown]    Reset Simulation

    Add Bearer    1    5

    Start Data Transmission    1    9    30
    Start Data Transmission    1    5    40

    ${result}=    Get Total Transfer For UE    1


# 6. Check Transfer In Default Unit
Check Transfer In Default Unit
    [Documentation]    Transfer should be returned in kbps when unit is not specified.
    [Setup]       UE Attaches Successfully    ${1}
    [Teardown]    Reset Simulation

    Start Data Transmission    1    9    10

    ${result}=    Get Total Transfer For UE    1
