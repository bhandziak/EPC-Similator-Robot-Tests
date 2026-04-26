*** Settings ***
Resource          ../resources/features/ue_attachment.resource
Resource          ../resources/features/add_bearer_to_ue.resource
Resource          ../resources/common.resource

Variables         ../config/env.yaml

Test Setup     UE with ID = 1 Attaches Successfully
Test Teardown     Reset Simulation

*** Test Cases ***
1. Successful Addition of Bearer to UE
    Add Bearer With ID = 5 To UE With ID = 1
    Bearer Addition Status Should Be Successful
    UE With ID = 1 Should Have Bearer With ID = 5

2. Failed Addition of Bearer with Out of Range Bearer (ID = 0)
    Add Bearer With ID = 0 To UE With ID = 1
    Bearer Addition Should Be Rejected Due To Out Of Range Bearer ID
    Error Message Should Be Input should be greater than or equal to 1

3. Failed Addition of Bearer with Out of Range Bearer (ID = 10)
    Add Bearer With ID = 10 To UE With ID = 1
    Bearer Addition Should Be Rejected Due To Out Of Range Bearer ID
    Error Message Should Be Input should be less than or equal to 9

4. Failed Addition of Bearer which is Already Added
    Add Bearer With ID = 5 To UE With ID = 1
    Bearer Addition Status Should Be Successful
    UE With ID = 1 Should Have Bearer With ID = 5

    Add Bearer With ID = 5 To UE With ID = 1
    Bearer Addition Should Be Rejected Due To Already Existing Bearer
    Error Detail Message Should Be Bearer already exists

5. Failed Addition of Bearer With Invalid Bearer ID
    Add Bearer With ID = abc To UE With ID = 1
    Bearer Addition Should Be Rejected Due To Invalid Bearer ID
    Error Message Should Be Input should be a valid integer, unable to parse string as an integer