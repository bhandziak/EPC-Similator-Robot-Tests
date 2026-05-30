Resource    add_bearer_to_ue.resource
Resource    ue_attachment.resource

*** Settings ***

*** Keywords ***
Bearer Addition Should Be Rejected Due To Non-Attached UE
    Status Should Be    400    ${LAST_RESPONSE}

Successful Bearer With ID = ${BEARER_ID} Addition To Attached UE With ID = ${UE_ID}
    UE with ID = ${UE_ID} Attaches Successfully
    Add Bearer With ID = ${BEARER_ID} To UE With ID = ${UE_ID}
    UE With ID = ${UE_ID} Should Have Bearer With ID = ${BEARER_ID}