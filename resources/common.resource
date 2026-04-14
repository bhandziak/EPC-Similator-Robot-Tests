*** Settings ***
Library    RequestsLibrary
Variables    ../config/env.yaml

*** Keywords ***
# API POST /reset
Reset Simulation
    [Documentation]    Resets the whole simulation.
    ${url}=    Set Variable    ${server}[base_url]${endpoints}[reset]
    ${response}=    POST    url=${url}    expected_status=any