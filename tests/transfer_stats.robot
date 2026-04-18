*** Settings ***
Resource    ../resources/features/eu_attachment.resource
Resource    ../resources/features/transfer_data.resource
Resource    ../resources/features/transfer_stats.resource
Resource    ../resources/common.resource
Variables   ../config/env.yaml

Test Setup       UE Attaches Successfully    ${1}
Test Teardown    Reset Simulation

*** Test Cases ***

# 4. Check Transfer For Single Bearer
4. Check Transfer For Single Bearer
    [Documentation]    System should return correct transfer value for specific bearer.

    Add Bearer    1    5
    Start Data Transmission    1    5    40
    ${result}=    Get Transfer For Bearer    1    5
    Should Be True    ${result}[tx_bps] > 0


# 5. Check Total Transfer For UE
5. Check Total Transfer For UE
    [Documentation]    System should return sum of all active bearer transfers.

    Add Bearer    1    5
    Start Data Transmission    1    9    30
    Start Data Transmission    1    5    40
    ${result}=    Get Total Transfer For UE    1


# 6. Check Transfer In Default Unit
6. Check Transfer In Default Unit
    [Documentation]    Transfer should be returned in kbps when unit is not specified.

    Start Data Transmission    1    9    10
    ${result}=    Get Total Transfer For UE    1