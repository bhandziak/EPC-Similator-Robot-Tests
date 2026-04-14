*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    String
Variables         ../../config/env.yaml


*** Variables ***
${LAST_RESPONSE}    ${None}

*** Keywords ***
# API POST /ues
Attach ${UE_ID} To Network
    [Documentation]    Sends POST request to attach UE with given ID. Stores response in ${LAST_RESPONSE}.

    # Request creation
    ${body}=    Create Dictionary    ue_id=${UE_ID}
    ${url}=     Set Variable    ${server}[base_url]${endpoints}[ue_collection]

    # Sending request
    ${response}=    POST    url=${url}    json=${body}    expected_status=any

    # Save response
    Set Test Variable    ${LAST_RESPONSE}    ${response}

# API GET /ues/{id}
Verify If ${UE_ID} Is Attached
    [Documentation]  Sends GET request to check if UE with given ID is attached.

    # Request creation
    ${path}=    Set Variable    ${endpoints}[ue_member]
    ${final_path}=    Replace String    ${path}    {id}    ${UE_ID}
    ${url}=     Set Variable    ${server}[base_url]${final_path}

    # Sending request
    ${response}=    GET    url=${url}
    
    # Check response
    Status Should Be    200    ${response}
    # Check if UE ID is in response
    Should Be Equal As Integers    ${response.json()}[ue_id]    ${UE_ID} 

Attachment Status Should Be Successful
    Status Should Be    200    ${LAST_RESPONSE}

Attachment Should Be Rejected Due To Already Attached UE ID
    Status Should Be    400   ${LAST_RESPONSE}

    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    ${actual_message}=   Set Variable    ${response_json}[detail]

    Should Be Equal As Strings    ${actual_message}    UE already attached

Attachment Status Should Be Rejected
    Status Should Be    422   ${LAST_RESPONSE}

Verify If Error Message Is ${expected_message}
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    ${actual_message}=   Set Variable    ${response_json}[detail][0][msg]

    Should Be Equal As Strings    ${actual_message}    ${expected_message}