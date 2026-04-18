*** Settings ***
Resource    ../resources/features/eu_attachment.resource
Resource    ../resources/features/transfer_data.resource
Resource    ../resources/features/transfer_stats.resource
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

