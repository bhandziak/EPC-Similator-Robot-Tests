*** Settings ***
Library     RequestsLibrary
Library     Collections
Library     String
Variables   ../../config/env.yaml
Resource    ../features/transfer_stats.resource

*** Variables ***
${LAST_RESPONSE}    ${None}

*** Keywords ***

Stop data transmission for UE with ID = ${UE_ID} and bearer with ID = ${BEARER_ID}

    ${path}=    Set Variable    ${endpoints}[ue_member]
    ${path}=    Replace String    ${path}    {id}    ${UE_ID}
    ${path}=    Set Variable    ${path}/bearers/${BEARER_ID}/traffic

    ${url}=    Set Variable    ${server}[base_url]${path}

    ${response}=    DELETE    url=${url}    expected_status=any

    Set Test Variable    ${LAST_RESPONSE}    ${response}


Transmission for bearer with ID = ${BEARER_ID} of UE with ID = ${UE_ID} should be stopped

    ${result}=    Get Transfer For Bearer with ID = ${BEARER_ID} and UE with ID = ${UE_ID}
    Should Be Equal As Integers    ${result}[tx_bps]    0


Transmission for bearers with ID = ${BEARER_1}, ${BEARER_2} for UE with ID = ${UE_ID} should be stopped

    ${b1}=    Get Transfer For Bearer with ID = ${BEARER_1} and UE with ID = ${UE_ID}
    ${b2}=    Get Transfer For Bearer with ID = ${BEARER_2} and UE with ID = ${UE_ID}

    Should Be Equal As Integers    ${b1}[tx_bps]    0
    Should Be Equal As Integers    ${b2}[tx_bps]    0


Transmission stop should be rejected
    Status Should Be    400    ${LAST_RESPONSE}

Transmission stop should be rejected Due To Invalid UE ID
    Status Should Be    422    ${LAST_RESPONSE}

Error message should contain ${expected_message}

    ${json}=    Set Variable    ${LAST_RESPONSE.json()}
    ${actual}=    Set Variable    ${json}[detail]
    Should Contain    ${actual}    ${expected_message}

Parsing error message should contain ${expected_message}

    ${json}=    Set Variable    ${LAST_RESPONSE.json()}
    ${actual}=    Set Variable    ${json}[detail][0][msg]
    Should Contain    ${actual}    ${expected_message}