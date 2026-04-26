*** Settings ***
Library    RequestsLibrary
Variables    ../config/env.yaml

*** Variables ***
${LAST_RESPONSE}    ${None}

*** Keywords ***
# API POST /reset
Reset Simulation
    [Documentation]    Resets the whole simulation.
    ${url}=    Set Variable    ${server}[base_url]${endpoints}[reset]
    ${response}=    POST    url=${url}    expected_status=any

Error Message Should Be ${expected_message}
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    ${actual_message}=   Set Variable    ${response_json}[detail][0][msg]
    
    Should Be Equal As Strings    ${actual_message}    ${expected_message}


Error Detail Message Should Be ${expected_message}
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    ${actual_message}=   Set Variable    ${response_json}[detail]
    
    Should Contain    ${actual_message}    ${expected_message}