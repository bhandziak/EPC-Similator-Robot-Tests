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
Detach ${UE_ID} From Network
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
Verify If ${UE_ID} Is Not Attached
    [Documentation]  Sends GET request to check if UE with given ID is not attached.

    ${details}=    Get UE details    ${UE_ID}
    
    Status Should Be    400    ${details}


Detachment Status Should Be Successful
    Status Should Be    200    ${LAST_RESPONSE}