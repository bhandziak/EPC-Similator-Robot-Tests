*** Settings ***
Library     RequestsLibrary
Library     Collections
Library     String
Variables   ../../config/env.yaml

*** Keywords ***

# GET TRANSFER FOR BEARER
Get Transfer For Bearer
    [Arguments]    ${UE_ID}    ${BEARER_ID}

    ${path}=    Set Variable    ${endpoints}[ue_member]
    ${path}=    Replace String    ${path}    {id}    ${UE_ID}
    ${path}=    Set Variable    ${path}/bearers/${BEARER_ID}/traffic

    ${url}=    Set Variable    ${server}[base_url]${path}

    ${response}=    GET    url=${url}
    ${json}=    Set Variable    ${response.json()}

    RETURN    ${json}


# GET TOTAL TRANSFER
Get Total Transfer For UE
    [Arguments]    ${UE_ID}

    ${url}=    Set Variable    ${server}[base_url]${endpoints}[ue_stats]
    ${url}=    Replace String    ${url}    {id}    ${UE_ID}

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