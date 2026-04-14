*** Settings ***
Resource          ../resources/features/eu_attachment.resource
Resource          ../resources/common.resource
Variables         ../config/env.yaml

*** Keywords ***
UE attaches successfully
    [Arguments]    ${UE_ID}
    
    Attach ${UE_ID} To Network
    Attachment Status Should Be Successful
    Verify If ${UE_ID} Is Attached

    [Teardown]    Reset Simulation

*** Test Cases ***
Successful UE Attachment
    [Template]         UE attaches successfully
    # [UE IDS]
    1
    2
    99
    100




