*** Settings ***
Library    RequestsLibrary
Variables    ../config/env.yaml

*** Keywords ***
# API POST /reset
Reset Simulation
    [Documentation]    Resets the whole simulation.
    ${url}=    Set Variable    ${server}[base_url]${endpoints}[reset]
    ${response}=    POST    url=${url}    expected_status=any

Compare Error Message ${expected_message} With Response ${response}
    ${response_json}=    Set Variable    ${response.json()}
    ${actual_message}=   Set Variable    ${response_json}[detail][0][msg]
    
    Should Be Equal As Strings    ${actual_message}    ${expected_message}

Compare Error Detail Message ${expected_message} With Response ${response}
    ${response_json}=    Set Variable    ${response.json()}
    ${actual_message}=   Set Variable    ${response_json}[detail]
    
    Should Contain    ${actual_message}    ${expected_message}