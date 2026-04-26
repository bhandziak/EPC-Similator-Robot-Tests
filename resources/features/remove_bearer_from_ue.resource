*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    String
Resource    ../common.resource
Resource    ue_attachment.resource
Resource    add_bearer_to_ue.resource
Variables    ../../config/env.yaml

*** Variables ***
${LAST_RESPONSE}    ${None}

*** Keywords ***

UE With ID = ${UE_ID} Should Not Have Bearer With ID = ${BEARER_ID}
    ${response}=         Get UE details with ID = ${UE_ID}
    Status Should Be     200    ${response}

    ${response_json}=    Evaluate    $response.json()
    Dictionary Should Not Contain Key    ${response_json}[bearers]    ${BEARER_ID}

Remove Bearer With ID = ${BEARER_ID} From UE With ID = ${UE_ID}
    [Documentation]    Sends DELETE request to remove bearer with given ID from UE. Stores response in ${LAST_RESPONSE}.

    ${path}=          Set Variable    ${endpoints}[ue_bearer_member]
    ${path}=          Replace String    ${path}    {ue_id}    ${UE_ID}
    ${final_path}=    Replace String    ${path}    {bearer_id}    ${BEARER_ID}
    ${url}=           Set Variable    ${server}[base_url]${final_path}

    ${response}=      DELETE    url=${url}    expected_status=any

    Set Test Variable    ${LAST_RESPONSE}    ${response}

Bearer Removal Should Be Successful
    Status Should Be    200    ${LAST_RESPONSE}

    ${response_json}=    Evaluate    $LAST_RESPONSE.json()
    ${actual_status}=    Set Variable    ${response_json}[status]
    Should Be Equal As Strings    ${actual_status}    bearer_deleted

Bearer Removal Should Be Rejected
    Status Should Be    400    ${LAST_RESPONSE}
