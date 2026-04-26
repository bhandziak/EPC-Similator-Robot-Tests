*** Settings ***
Resource          ../resources/features/ue_attachment.resource
Resource          ../resources/features/ue_detachment.resource
Resource          ../resources/features/add_bearer_to_ue.resource
Resource          ../resources/features/remove_bearer_from_ue.resource
Resource          ../resources/features/transfer_start.resource
Resource          ../resources/common.resource
Variables         ../config/env.yaml

Test Teardown     Reset Simulation

*** Test Cases ***
1. Successful UE Detachment
    # Attach UE first
    [Setup]    UE with ID = 1 Attaches Successfully

    # Detach UE
    Detach UE with ID = 1 From Network
    Detachment Status Should Be Successful For UE ID = 1


2. Failed Detachment When UE Is Not Connected
    UE with ID = 1 Should Not Be Attached
    Detach UE with ID = 1 From Network
    Detachment Should Be Rejected Due To Already Attached UE ID
    UE with ID = 1 Should Not Be Attached

3. Failed Detachment With Invalid UE ID
    Detach UE with ID = abc From Network
    Detachment Should Be Rejected Due To Invalid UE ID
    Error Message Should Be Input should be a valid integer, unable to parse string as an integer

4. Double Detachment of the Same UE
    # Attach UE first
    [Setup]    UE with ID = 1 Attaches Successfully

    # First detachment
    Detach UE with ID = 1 From Network
    Detachment Status Should Be Successful For UE ID = 1

    # Second detachment with same UE ID
    Detach UE with ID = 1 From Network
    Detachment Should Be Rejected Due To To Non-Existing UE ID

5. Successful UE Detachment With Added Bearer
    # Attach UE first
    [Setup]    UE with ID = 1 Attaches Successfully

    # Add bearer to attached UE
    Add Bearer With ID = 5 To UE With ID = 1
    Bearer Addition With ID = 5 To UE With ID = 1 Should Be Successful

    # Detach UE
    Detach UE with ID = 1 From Network
    Detachment Status Should Be Successful For UE ID = 1

    # Attach UE again to check if previous bearer was removed
    UE with ID = 1 Attaches Successfully
    UE with ID = 1 Should Not Have Bearer With ID = 5

6. Successful UE Detachment With Active Transmission On Added Bearer
    # Attach UE first
    [Setup]    UE with ID = 1 Attaches Successfully

    # Add bearer to attached UE
    Add Bearer With ID = 5 To UE With ID = 1
    Bearer Addition With ID = 5 To UE With ID = 1 Should Be Successful

    # Start data transmission on bearer
    Start Data Transmission for UE with ID = 1, BEARER with ID = 5 and SPEED = 50 Mbps

    # Detach UE
    Detach UE with ID = 1 From Network
    Detachment Status Should Be Successful For UE ID = 1

    # Attach UE again and start transmission 
    UE with ID = 1 Attaches Successfully
    Start Data Transmission for UE with ID = 1, BEARER with ID = 5 and SPEED = 50 Mbps
    Transmission Should Be Successful

