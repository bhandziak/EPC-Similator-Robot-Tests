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
Get UE details
    [Arguments]    ${UE_ID}

    # Request creation
    ${path}=    Set Variable    ${endpoints}[ue_member]
    ${final_path}=    Replace String    ${path}    {id}    ${UE_ID}
    ${url}=    Set Variable    ${server}[base_url]${final_path}

    # Sending request
    ${response}=    GET    url=${url}
    Status Should Be    200    ${response}

    RETURN    ${response.json()}

Verify If ${UE_ID} Is Attached
    [Documentation]  Sends GET request to check if UE with given ID is attached.

    ${details}=    Get UE details    ${UE_ID}

    # Check if UE ID is in response
    Should Be Equal As Integers    ${details}[ue_id]    ${UE_ID}     

# API GET /ues/{id} - check for Default Bearer
Verify If ${UE ID} Has Default Bearer
    [Documentation]  Sends GET request to check if attached UE has default bearer.

    ${details}=    Get UE details    ${UE_ID}
    # Check if default bearer is present in response
    Dictionary Should Contain Key    ${details}[bearers]    9



Attachment Status Should Be Successful
    Status Should Be    200    ${LAST_RESPONSE}

Attachment Should Be Rejected Due To Already Attached UE ID
    Should Not Be Equal    ${LAST_RESPONSE.status_code}    200

    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    ${actual_message}=   Set Variable    ${response_json}[detail]

    Should Be Equal As Strings    ${actual_message}    UE already attached

Attachment Status Should Be Rejected
    Status Should Be    422   ${LAST_RESPONSE}

Verify If Error Message Is ${expected_message}
    ${response_json}=    Set Variable    ${LAST_RESPONSE.json()}
    ${actual_message}=   Set Variable    ${response_json}[detail][0][msg]

    Should Be Equal As Strings    ${actual_message}    ${expected_message}


# Musiałem dodać te keywordy do tego pliku, bo inaczej nie mogę korzystać z nich jak są w pliku .robot (nie mogę ich dodać do resources).
UE Attaches Successfully
    [Arguments]    ${UE_ID}

    Attach ${UE_ID} To Network
    Log To Console    ATTACH RESPONSE: ${LAST_RESPONSE.json()}

    Attachment Status Should Be Successful
    Verify If ${UE_ID} Is Attached


UE Attachment is Rejected
    [Arguments]    ${UE_ID}    ${expected_message}
    
    Attach ${UE_ID} To Network
    Attachment Status Should Be Rejected
    Verify If Error Message Is ${expected_message}