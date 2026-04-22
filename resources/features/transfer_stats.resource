*** Settings ***
Library     RequestsLibrary
Library     Collections
Library     String
Variables   ../../config/env.yaml

*** Keywords ***

# GET TRANSFER FOR BEARER
Get Transfer For Bearer with ID = ${BEARER_ID} and UE with ID = ${UE_ID}

    ${path}=    Set Variable    ${endpoints}[ue_member]
    ${path}=    Replace String    ${path}    {id}    ${UE_ID}
    ${path}=    Set Variable    ${path}/bearers/${BEARER_ID}/traffic

    ${url}=    Set Variable    ${server}[base_url]${path}

    ${response}=    GET    url=${url}
    ${json}=    Set Variable    ${response.json()}

    RETURN    ${json}


# VERIFY TRANSFER
Verify Transfer Value
    [Arguments]    ${actual}    ${expected}
    Should Be Equal As Integers    ${actual}    ${expected}


Verify Transfer Unit Is Kbps
    [Arguments]    ${unit}
    Should Be Equal As Strings    ${unit}    kbps


Sum up Target BPS For UE ${UE_ID} And Bearers ${BEARER_1} ${BEARER_2}

    ${b1}=    Get Transfer For Bearer with ID = ${BEARER_1} and UE with ID = ${UE_ID}
    ${b2}=    Get Transfer For Bearer with ID = ${BEARER_2} and UE with ID = ${UE_ID}

    ${sum}=    Evaluate    ${b1}[target_bps] + ${b2}[target_bps]

    RETURN    ${sum}