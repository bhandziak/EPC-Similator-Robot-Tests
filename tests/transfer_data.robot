*** Settings ***
Resource    ../resources/features/eu_attachment.resource
Resource    ../resources/features/transfer_data.resource
Resource    ../resources/features/transfer_stats.resource
Resource    ../resources/common.resource
Variables   ../config/env.yaml

Test Setup       UE Attaches Successfully    ${1}
Test Teardown    Reset Simulation

*** Test Cases ***

# 1. Successful Data Transmission Start
1. Successful Data Transmission Start
    [Documentation]    Transmission should start successfully for valid UE, bearer and speed.

    Start Data Transmission    1    9    50
    Transmission Should Be Successful


# 2. Failed Data Transmission With Out Of Range Speed
2. Failed Data Transmission With Out Of Range Speed
    [Documentation]    Transmission should be rejected when speed exceeds allowed limit.

    Start Data Transmission    1    9    200
    Transmission Should Be Rejected
    

# 3. Failed Data Transmission For Inactive Bearer
3. Failed Data Transmission For Inactive Bearer
    [Documentation]    Transmission should fail if bearer is not active.

    Add Bearer    1    5
    Start Data Transmission    1    5    50
    Transmission Should Be Rejected

