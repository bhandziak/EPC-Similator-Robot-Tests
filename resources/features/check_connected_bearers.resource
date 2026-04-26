*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    String
Resource    ../common.resource
Variables    ../../config/env.yaml

*** Variables ***
${LAST_RESPONSE}    ${None}

*** Keywords ***
Get Connected Bearers For UE With ID = ${UE_ID}
    [Documentation]    Sends GET request to retrieve connected bearers for given UE ID. Stores response in ${LAST_RESPONSE}.

    ${path}=          Set Variable    ${endpoints}[ue_member]
    ${final_path}=    Replace String    ${path}    {id}    ${UE_ID}
    ${url}=           Set Variable    ${server}[base_url]${final_path}

    ${response}=      GET    url=${url}    expected_status=any

    Set Test Variable    ${LAST_RESPONSE}    ${response}

Connected Bearers Retrieval Should Be Successful
    Status Should Be    200    ${LAST_RESPONSE}

Connected Bearers List Should Contain Bearer ${expected_bearer_id}
    ${response_json}=    Evaluate    $LAST_RESPONSE.json()
    Dictionary Should Contain Key    ${response_json}[bearers]    ${expected_bearer_id}

Connected Bearers Retrieval Should Be Rejected
    Status Should Be    400    ${LAST_RESPONSE}

UE With ID = ${UE_ID} Should Not Be Attached
    ${path}=          Set Variable    ${endpoints}[ue_member]
    ${final_path}=    Replace String    ${path}    {id}    ${UE_ID}
    ${url}=           Set Variable    ${server}[base_url]${final_path}

    ${response}=      GET    url=${url}    expected_status=any
    Status Should Be    400    ${response}
