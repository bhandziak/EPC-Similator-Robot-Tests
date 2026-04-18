*** Settings ***
Library     RequestsLibrary
Library     Collections
Library     String
Variables   ../../config/env.yaml

*** Variables ***
${LAST_RESPONSE}    ${None}

*** Keywords ***

# START DATA TRANSMISSION
Start Data Transmission
    [Arguments]    ${UE_ID}    ${BEARER_ID}    ${SPEED}

    ${path}=    Set Variable    ${endpoints}[ue_member]
    ${path}=    Replace String    ${path}    {id}    ${UE_ID}
    ${path}=    Set Variable    ${path}/bearers/${BEARER_ID}/traffic

    ${url}=    Set Variable    ${server}[base_url]${path}

    ${speed_int}=    Convert To Integer    ${SPEED}
    ${body}=    Create Dictionary
    ...    Mbps=${speed_int}
    ...    protocol=tcp

    ${response}=    POST    url=${url}    json=${body}    expected_status=any
    Set Test Variable    ${LAST_RESPONSE}    ${response}

    Log To Console    START RESPONSE: ${response.json()}


# STATUS CHECKS
Transmission Should Be Successful
    Status Should Be    200    ${LAST_RESPONSE}


Transmission Should Be Rejected
    Should Not Be Equal    ${LAST_RESPONSE.status_code}    200


Verify Transmission Error Message
    [Arguments]    ${expected_message}

    ${json}=    Set Variable    ${LAST_RESPONSE.json()}
    Log To Console    ERROR RESPONSE: ${json}

    ${actual}=    Set Variable    ${json}[detail]
    Should Contain    ${actual}    ${expected_message}


# ADD BEARER
Add Bearer
    [Arguments]    ${UE_ID}    ${BEARER_ID}

    ${path}=    Set Variable    ${endpoints}[ue_member]
    ${path}=    Replace String    ${path}    {id}    ${UE_ID}
    ${path}=    Set Variable    ${path}/bearers

    ${url}=    Set Variable    ${server}[base_url]${path}

    ${body}=    Create Dictionary    bearer_id=${BEARER_ID}

    ${response}=    POST    url=${url}    json=${body}    expected_status=any
    Set Test Variable    ${LAST_RESPONSE}    ${response}
