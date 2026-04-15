*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    String
Variables         ../../config/env.yaml
Resource          eu_attachment.resource

*** Variables ***
${LAST_RESPONSE}    ${None}

*** Keywords ***
# API DELETE /ues/{id}
Detach UE with ID = ${UE_ID} From Network
    [Documentation]    Sends DELETE request to detach UE with given ID.

    # Request creation
    ${path}=    Set Variable    ${endpoints}[ue_member]
    ${final_path}=    Replace String    ${path}    {id}    ${UE_ID}
    ${url}=     Set Variable    ${server}[base_url]${final_path}

    # Sending request
    ${response}=    DELETE    url=${url}    expected_status=any

    # Save response
    Set Test Variable    ${LAST_RESPONSE}    ${response}

# API GET /ues/{id}
UE with ID = ${UE_ID} Should Not Be Attached
    [Documentation]  Sends GET request to check if UE with given ID is not attached.

    ${details}=    Get UE details    ${UE_ID}
    
    Status Should Be    400    ${details}


Detachment Status Should Be Successful
    Status Should Be    200    ${LAST_RESPONSE}

Detachment Should Be Rejected Due To Already Attached UE ID
    Status Should Be    400    ${LAST_RESPONSE}

Detachment Should Be Rejected Due To Invalid UE ID
    Status Should Be    422    ${LAST_RESPONSE}