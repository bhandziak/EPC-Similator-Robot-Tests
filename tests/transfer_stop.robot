*** Settings ***
Resource    ../resources/features/transfer_stop.resource
Resource    ../resources/features/transfer_start.resource
Resource    ../resources/features/ue_attachment.resource
Resource    ../resources/common.resource
Variables   ../config/env.yaml

Test Setup       UE with ID = 1 Attaches Successfully
Test Teardown    Reset Simulation

*** Test Cases ***

1. Successful Stop Transmission For Single Bearer
    [Documentation]    Transmission should stop for a specific bearer.

    Add Bearer with ID = 5 To UE with ID = 1
    Start Data Transmission for UE with ID = 1, BEARER with ID = 5 and SPEED = 50 Mbps
    Stop data transmission for UE with ID = 1 and bearer with ID = 5
    Transmission for bearer with ID = 5 of UE with ID = 1 should be stopped


2. Successful Stop Transmission For All Bearers
    [Documentation]    Transmission should stop for all bearers when bearer ID is not provided.

    Add Bearer with ID = 5 To UE with ID = 1
    Start Data Transmission for UE with ID = 1, BEARER with ID = 9 and SPEED = 30 Mbps
    Start Data Transmission for UE with ID = 1, BEARER with ID = 5 and SPEED = 50 Mbps
    Stop data transmission for UE with ID = 1 and bearer with ID = 9
    Stop data transmission for UE with ID = 1 and bearer with ID = 5
    Transmission for bearers with ID = 9, 5 for UE with ID = 1 should be stopped


3. Stop Transmission For Non-Existing Bearer
    [Documentation]    System should return error when stopping transmission for non-existing bearer.

    Stop data transmission for UE with ID = 1 and bearer with ID = 99
    Transmission stop should be rejected
    Error detail message should contain Bearer not found

4. Stop Transmission For Non-Existing UE ID
    [Documentation]    System should return error when stopping transmission for non-existing UE ID.

    Stop data transmission for UE with ID = 5 and bearer with ID = 5
    Transmission stop should be rejected
    Error detail message should contain UE not found


5. Stop Transmission For Bearer Not Started
    [Documentation]    System should return error when stopping transmission for bearer that has not started transmission

    Add Bearer with ID = 5 To UE with ID = 1
    Stop data transmission for UE with ID = 1 and bearer with ID = 5
    Transmission for bearer with ID = 5 of UE with ID = 1 should be stopped

6. Stop Transmission For Bearer With Invalid ID
    [Documentation]    System should return error when stopping transmission for bearer with invalid ID

    Stop data transmission for UE with ID = 1 and bearer with ID = abc
    Transmission stop should be rejected Due To Invalid UE ID
    Error message should contain Input should be a valid integer, unable to parse string as an integer