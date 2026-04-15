*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    String
Variables         ../../config/env.yaml


*** Variables ***
${LAST_RESPONSE}    ${None}

*** Keywords ***
# API POST /ues
Attach UE with ID = ${UE_ID} To Network
    [Documentation]    Sends POST request to attach UE with given ID. Stores response in ${LAST_RESPONSE}.

    # Request creation
    ${body}=    Create Dictionary    ue_id=${UE_ID}
    ${url}=     Set Variable    ${server}[base_url]${endpoints}[ue_collection]

    # Sending request
    ${response}=    POST    url=${url}    json=${body}    expected_status=any

    # Save response
    Set Test Variable    ${LAST_RESPONSE}    ${response}

# API GET /ues/{id}
Get UE details
    [Arguments]    ${UE_ID}

    # Request creation
    ${path}=    Set Variable    ${endpoints}[ue_member]
    ${final_path}=    Replace String    ${path}    {id}    ${UE_ID}
    ${url}=    Set Variable    ${server}[base_url]${final_path}

    # Sending request
    ${response}=    GET    url=${url}    expected_status=any

    RETURN    ${response}

UE with ID = ${UE_ID} Should Be Attached
    [Documentation]  Sends GET request to check if UE with given ID is attached.

    ${details}=    Get UE details    ${UE_ID}
    Status Should Be    200    ${details}

    # Check if UE ID is in response
    ${details_json}=    Set Variable    ${details.json()}
    Should Be Equal As Integers    ${details_json}[ue_id]    ${UE_ID}     

UE with ID = ${UE_ID} Should Have Default Bearer
    [Documentation]  Sends GET request to check if attached UE has default bearer.

    ${details}=    Get UE details    ${UE_ID}
    Status Should Be    200    ${details}

    # Check if default bearer is present in response
    ${details_json}=    Set Variable    ${details.json()}
    Dictionary Should Contain Key    ${details_json}[bearers]    9


Attachment Status Should Be Successful
    Status Should Be    200    ${LAST_RESPONSE}

Attachment Should Be Rejected Due To Already Attached UE With The Same ID
    Status Should Be    400   ${LAST_RESPONSE}

    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    ${actual_message}=   Set Variable    ${response_json}[detail]

    Should Be Equal As Strings    ${actual_message}    UE already attached

Attachment Should Be Rejected To Invalid UE ID
    Status Should Be    422   ${LAST_RESPONSE}

Error Message Should Be ${expected_message}
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    ${actual_message}=   Set Variable    ${response_json}[detail][0][msg]

    Should Be Equal As Strings    ${actual_message}    ${expected_message}