*** Settings ***
Resource    ../resources/features/eu_attachment.resource
Resource    ../resources/features/transfer_data.resource
Resource    ../resources/features/transfer_stats.resource
Resource    ../resources/common.resource
Variables   ../config/env.yaml

Test Setup       UE Attaches Successfully    1
Test Teardown    Reset Simulation

*** Test Cases ***

4. Check Transfer For Single Bearer
    [Documentation]    System should return correct transfer value for specific bearer.

    Add Bearer with ID = 5 To UE with ID = 1
    Start Data Transmission for UE with ID = 1, BEARER with ID = 5 and SPEED = 50
    ${result}=    Get Transfer For Bearer with ID = 5 and UE with ID = 1
    Should Be Equal As Integers    ${result}[target_bps]    50000000

    
5. Check Total Transfer For UE
    [Documentation]    System should return sum of all active bearer transfers.

    Add Bearer with ID = 5 To UE with ID = 1
    Start Data Transmission for UE with ID = 1, BEARER with ID = 9 and SPEED = 30
    Start Data Transmission for UE with ID = 1, BEARER with ID = 5 and SPEED = 50
    ${sum}=    Sum up Target BPS For UE 1 And Bearers 9 5
    Should Be Equal As Integers    ${sum}    80000000


6. Check Transfer In Default Unit
    [Documentation]    Transfer should be returned in kbps when unit is not specified.

    Start Data Transmission for UE with ID = 1, BEARER with ID = 9 and SPEED = 1
    ${result}=    Get Transfer For Bearer with ID = 9 and UE with ID = 1
     Should Be Equal As Integers    ${result}[target_bps]    1000