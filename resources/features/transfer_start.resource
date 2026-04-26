*** Settings ***
Library     RequestsLibrary
Library     Collections
Library     String
Variables   ../../config/env.yaml

*** Variables ***
${LAST_RESPONSE}    ${None}

*** Keywords ***

Start Data Transmission for UE with ID = ${UE_ID}, BEARER with ID = ${BEARER_ID} and SPEED = ${SPEED} Mbps

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


Transmission Should Be Successful
    Status Should Be    200    ${LAST_RESPONSE}


Transmission Should Be Rejected
    Should Not Be Equal    ${LAST_RESPONSE.status_code}    200
