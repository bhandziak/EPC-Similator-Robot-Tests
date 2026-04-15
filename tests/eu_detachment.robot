*** Settings ***
Resource          ../resources/features/eu_attachment.resource
Resource          ../resources/features/eu_detachment.resource
Resource          ../resources/common.resource
Variables         ../config/env.yaml

*** Test Cases ***
Successful EU Detachment
    [Setup]    UE Attaches Successfully    ${1}

    Detach ${1} From Network
    Detachment Status Should Be Successful

    Verify If ${1} Is Not Attached

    [Teardown]    Reset Simulation
