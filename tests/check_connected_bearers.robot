*** Settings ***
Resource          ../resources/features/check_connected_bearers.resource
Resource          ../resources/features/ue_attachment.resource
Resource          ../resources/common.resource
Variables         ../config/env.yaml

Test Teardown     Reset Simulation

*** Test Cases ***
1. Failed Connected Bearers Retrieval For Not Attached UE
    UE With ID = 1 Should Not Be Attached

    Get Connected Bearers For UE With ID = 1
    Connected Bearers Retrieval Should Be Rejected
    Error Detail Message Should Be UE not found