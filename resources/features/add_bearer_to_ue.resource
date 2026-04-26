*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    String
Resource    ue_attachment.resource
Variables    ../../config/env.yaml

*** Variables ***
${LAST_RESPONSE}    ${None}

*** Keywords ***

# API DELETE /ues/{ue_id}/bearers
Request Bearer Creation With ID = ${BEARER_ID} To UE With ID = ${UE_ID}
    ${path}=          Set Variable    ${endpoints}[ue_bearers]
    ${final_path}=    Replace String    ${path}    {ue_id}    ${UE_ID}
    ${url}=           Set Variable    ${server}[base_url]${final_path}
    ${body}=          Create Dictionary    bearer_id=${BEARER_ID}

    ${response}=      POST    url=${url}    json=${body}    expected_status=any
    RETURN    ${response}

Add Bearer With ID = ${BEARER_ID} To UE With ID = ${UE_ID}
    [Documentation]    Sends POST request to add bearer with given ID to UE. Stores response in ${LAST_RESPONSE}.

    ${response}=      Request Bearer Creation With ID = ${BEARER_ID} To UE With ID = ${UE_ID}

    Set Test Variable    ${LAST_RESPONSE}    ${response}

Bearer Addition Status Should Be Successful
    Status Should Be    200    ${LAST_RESPONSE}

Bearer Addition Should Be Rejected Due To Out Of Range Bearer ID
    Status Should Be    422    ${LAST_RESPONSE}

Bearer Addition Should Be Rejected Due To Invalid Bearer ID
    Status Should Be    422    ${LAST_RESPONSE}

Bearer Addition Should Be Rejected Due To Already Existing Bearer
    Status Should Be    400    ${LAST_RESPONSE}

UE With ID = ${UE_ID} Should Have Bearer With ID = ${BEARER_ID}
    ${response}=        Get UE details with ID = ${UE_ID}
    Status Should Be     200    ${response}

    ${response_json}=    Evaluate    $response.json()
    Dictionary Should Contain Key    ${response_json}[bearers]    ${BEARER_ID}