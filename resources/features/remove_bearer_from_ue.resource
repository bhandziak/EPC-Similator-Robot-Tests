*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    String
Variables    ../../config/env.yaml

*** Variables ***
${LAST_RESPONSE}    ${None}

*** Keywords ***
Attach UE with ID = ${UE_ID} To Network
    [Documentation]    Sends POST request to attach UE with given ID. Stores response in ${LAST_RESPONSE}.

    ${body}=    Create Dictionary    ue_id=${UE_ID}
    ${url}=     Set Variable    ${server}[base_url]${endpoints}[ue_collection]

    ${response}=    POST    url=${url}    json=${body}    expected_status=any

    Set Test Variable    ${LAST_RESPONSE}    ${response}

Attachment Status Should Be Successful
    Status Should Be    200    ${LAST_RESPONSE}

Add Bearer With ID = ${BEARER_ID} To UE With ID = ${UE_ID}
    [Documentation]    Sends POST request to add bearer with given ID to UE. Stores response in ${LAST_RESPONSE}.

    ${path}=          Set Variable    ${endpoints}[ue_bearers]
    ${final_path}=    Replace String    ${path}    {ue_id}    ${UE_ID}
    ${url}=           Set Variable    ${server}[base_url]${final_path}
    ${body}=          Create Dictionary    bearer_id=${BEARER_ID}

    ${response}=      POST    url=${url}    json=${body}    expected_status=any

    Set Test Variable    ${LAST_RESPONSE}    ${response}

Bearer Addition Status Should Be Successful
    Status Should Be    200    ${LAST_RESPONSE}

Get UE Details For UE With ID = ${UE_ID}
    [Documentation]    Sends GET request to retrieve UE details.

    ${path}=          Set Variable    ${endpoints}[ue_member]
    ${final_path}=    Replace String    ${path}    {id}    ${UE_ID}
    ${url}=           Set Variable    ${server}[base_url]${final_path}

    ${response}=      GET    url=${url}    expected_status=any

    RETURN    ${response}

UE With ID = ${UE_ID} Should Have Bearer With ID = ${BEARER_ID}
    ${response}=         Get UE Details For UE With ID = ${UE_ID}
    Status Should Be     200    ${response}

    ${response_json}=    Evaluate    $response.json()
    Dictionary Should Contain Key    ${response_json}[bearers]    ${BEARER_ID}

UE With ID = ${UE_ID} Should Not Have Bearer With ID = ${BEARER_ID}
    ${response}=         Get UE Details For UE With ID = ${UE_ID}
    Status Should Be     200    ${response}

    ${response_json}=    Evaluate    $response.json()
    Dictionary Should Not Contain Key    ${response_json}[bearers]    ${BEARER_ID}

UE With ID = ${UE_ID} Should Have Default Bearer
    ${response}=         Get UE Details For UE With ID = ${UE_ID}
    Status Should Be     200    ${response}

    ${response_json}=    Evaluate    $response.json()
    Dictionary Should Contain Key    ${response_json}[bearers]    9

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

Remove Bearer Error Message Should Be ${expected_message}
    ${response_json}=    Evaluate    $LAST_RESPONSE.json()
    ${actual_message}=   Set Variable    ${response_json}[detail]
    Should Be Equal As Strings    ${actual_message}    ${expected_message}