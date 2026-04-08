*** Settings ***
Library           RequestsLibrary
Library           Collections

*** Variables ***
${BASE_URL}       http://localhost:8000
${ENDPOINT}       /ues
${INVALID_ID}     ${101}

*** Test Cases ***
Scenario: Podłączenie UE o ID spoza zakresu powinno zwrócić błąd
    [Documentation]    Sprawdzenie czy API poprawnie odrzuca ID > 100
    [Setup]           Create Session    api_session    ${BASE_URL}

    ${payload}=       Create Dictionary    ue_id=${INVALID_ID}
    ${response}=      POST On Session    api_session    ${ENDPOINT}    json=${payload}    expected_status=any

    Status Should Be    422    ${response}

    ${body}=          Set Variable    ${response.json()}
    
    ${error_msg}=     Set Variable    ${body['detail'][0]['msg']}
    
    Should Be Equal As Strings    ${error_msg}    Input should be less than or equal to 100

    ${field}=         Set Variable    ${body['detail'][0]['loc'][1]}
    Should Be Equal As Strings    ${field}    ue_id

    [Teardown]        Delete All Sessions