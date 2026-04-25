*** Settings ***
Resource    ../resources/features/ue_attachment.resource
Resource    ../resources/features/transfer_data.resource
Resource    ../resources/features/transfer_stats.resource
Resource    ../resources/common.resource
Variables   ../config/env.yaml

Test Setup       UE with ID = 1 Attaches Successfully
Test Teardown    Reset Simulation

*** Test Cases ***

4. Check Transfer For Single Bearer
    [Documentation]    System should return correct transfer value for specific bearer.

    Add Bearer with ID = 5 To UE with ID = 1
    Start Data Transmission for UE with ID = 1, BEARER with ID = 5 and SPEED = 50 Mbps
    Transfer for bearer with ID = 5 of UE with ID = 1 should be equal to 50 Mbps
    
    
5. Check Total Transfer For UE
    [Documentation]    System should return sum of all active bearer transfers.

    Add Bearer with ID = 5 To UE with ID = 1
    Start Data Transmission for UE with ID = 1, BEARER with ID = 9 and SPEED = 30 Mbps
    Start Data Transmission for UE with ID = 1, BEARER with ID = 5 and SPEED = 50 Mbps
    Total transfer for UE with ID = 1 and bearers with ID = 9, 5 should be equal to 80 Mbps


6. Check Transfer In Default Unit
    [Documentation]    Transfer should be returned in kbps when unit is not specified.

    Start Data Transmission for UE with ID = 1, BEARER with ID = 9 and SPEED = 1 Mbps
    Transfer for bearer with ID = 9 of UE with ID = 1 should be equal to 1 Mbps