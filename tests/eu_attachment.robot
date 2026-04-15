*** Settings ***
Resource          ../resources/features/eu_attachment.resource
Resource          ../resources/common.resource
Variables         ../config/env.yaml

Test Teardown     Reset Simulation

*** Test Cases ***
1. Successful UE Attachment
    Attach UE with ID = 1 To Network
    Attachment Status Should Be Successful
    UE with ID = 1 Should Be Attached

2. Failed UE Attachment With Out Of Range UE ID (UE ID = 0)
    Attach UE with ID = 0 To Network
    Attachment Should Be Rejected To Invalid UE ID
    Error Message Should Be Input should be greater than or equal to 1

3. Failed UE Attachment With Out Of Range UE ID (UE ID = 101)
    Attach UE with ID = 101 To Network
    Attachment Should Be Rejected To Invalid UE ID
    Error Message Should Be Input should be less than or equal to 100

4. Failed UE Attachment With Non-Integer UE ID
    Attach UE with ID = string To Network
    Attachment Should Be Rejected To Invalid UE ID
    Error Message Should Be Input should be a valid integer, unable to parse string as an integer

5. Failed UE Attachment With Null UE ID
    Attach UE with ID = null To Network
    Attachment Should Be Rejected To Invalid UE ID
    Error Message Should Be Input should be a valid integer, unable to parse string as an integer

6. Failed UE Attachment When UE ID Is Already Attached
    # First attachment
    Attach UE with ID = 1 To Network
    Attachment Status Should Be Successful
    UE with ID = 1 Should Be Attached
    # Second attachment with same UE ID
    Attach UE with ID = 1 To Network
    Attachment Should Be Rejected Due To Already Attached UE With The Same ID
    
7. Attached UE Automatically Receives Default Bearer
    Attach UE with ID = 1 To Network
    Attachment Status Should Be Successful
    UE with ID = 1 Should Be Attached
    UE with ID = 1 Should Have Default Bearer