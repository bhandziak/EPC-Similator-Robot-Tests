*** Settings ***
Library     RequestsLibrary
Library     Collections
Library     String
Variables   ../../config/env.yaml

*** Keywords ***

Get Transfer For Bearer with ID = ${BEARER_ID} and UE with ID = ${UE_ID}

    ${path}=    Set Variable    ${endpoints}[ue_member]
    ${path}=    Replace String    ${path}    {id}    ${UE_ID}
    ${path}=    Set Variable    ${path}/bearers/${BEARER_ID}/traffic

    ${url}=    Set Variable    ${server}[base_url]${path}

    ${response}=    GET    url=${url}
    ${json}=    Set Variable    ${response.json()}

    RETURN    ${json}


Verify Transfer Value
    [Arguments]    ${actual}    ${expected}
    Should Be Equal As Integers    ${actual}    ${expected}


Verify Transfer Unit Is Kbps
    [Arguments]    ${unit}
    Should Be Equal As Strings    ${unit}    kbps


Sum up Target BPS For UE with ID = ${UE_ID} And Bearers with ID = ${BEARER_1}, ${BEARER_2}

    ${b1}=    Get Transfer For Bearer with ID = ${BEARER_1} and UE with ID = ${UE_ID}
    ${b2}=    Get Transfer For Bearer with ID = ${BEARER_2} and UE with ID = ${UE_ID}

    ${sum}=    Evaluate    ${b1}[target_bps] + ${b2}[target_bps]

    RETURN    ${sum}


Transfer for bearer with ID = ${BEARER_ID} of UE with ID = ${UE_ID} should be equal to ${SPEED} Mbps

    ${result}=    Get Transfer For Bearer with ID = ${BEARER_ID} and UE with ID = ${UE_ID}
    ${expected}=  Evaluate    ${SPEED} * 1000000
    Should Be Equal As Integers    ${result}[target_bps]    ${expected}


Total transfer for UE with ID = ${UE_ID} and bearers with ID = ${BEARER_1}, ${BEARER_2} should be equal to ${SPEED} Mbps

    ${sum}=    Sum up Target BPS For UE with ID = ${UE_ID} And Bearers with ID = ${BEARER_1}, ${BEARER_2}
    ${expected}=  Evaluate    ${SPEED} * 1000000
    Should Be Equal As Integers    ${sum}    ${expected}