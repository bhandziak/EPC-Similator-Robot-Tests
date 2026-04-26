*** Settings ***
Resource          ../resources/features/remove_bearer_from_ue.resource
Resource          ../resources/features/add_bearer_to_ue.resource
Resource          ../resources/features/ue_attachment.resource
Resource          ../resources/common.resource
Variables         ../config/env.yaml


Test Setup      UE with ID = 1 Attaches Successfully
Test Teardown     Reset Simulation

*** Test Cases ***
1. Successful Removal Of Dedicated Bearer From UE
    Add Bearer With ID = 5 To UE With ID = 1
    Bearer Addition Status Should Be Successful
    UE With ID = 1 Should Have Bearer With ID = 5

    Remove Bearer With ID = 5 From UE With ID = 1
    Bearer Removal Should Be Successful
    UE With ID = 1 Should Not Have Bearer With ID = 5

2. Failed Removal Of Bearer With Out Of Range Bearer ID = 0
    Remove Bearer With ID = 0 From UE With ID = 1
    Bearer Removal Should Be Rejected
    Error Detail Message Should Be Bearer not found

3. Failed Removal Of Bearer With Out Of Range Bearer ID = 10
    Remove Bearer With ID = 10 From UE With ID = 1
    Bearer Removal Should Be Rejected
    Error Detail Message Should Be Bearer not found

4. Failed Removal Of Inactive Bearer
    UE With ID = 1 Should Not Have Bearer With ID = 5

    Remove Bearer With ID = 5 From UE With ID = 1
    Bearer Removal Should Be Rejected
    Error Detail Message Should Be Bearer not found

5. Failed Removal Of Default Bearer
    UE With ID = 1 Should Have Default Bearer

    Remove Bearer With ID = 9 From UE With ID = 1
    Bearer Removal Should Be Rejected
    Error Detail Message Should Be Cannot remove default bearer