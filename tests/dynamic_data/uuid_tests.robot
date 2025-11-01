*** Settings ***
Documentation    Tests for UUID generation endpoint
Resource         ../../resources/api_keywords.robot
Resource         ../../resources/variables.robot



*** Test Cases ***
Verify UUID Endpoint
    [Documentation]    Verify /uuid endpoint returns a valid UUID4 string
    [Tags]    positive    dynamic-data    uuid
    ${response}=    Send GET Request With Retry    ${UUID_ENDPOINT}
    Validate Response Status    ${response}    ${EXPECTED_SUCCESS_STATUS}

    # Validate Content-Type header
    Validate Response Header Value    ${response}    Content-Type    application/json

    # Validate response JSON structure
    ${json}=    Set Variable    ${response.json()}
    Dictionary Should Contain Key    ${json}    uuid

    # Validate UUID format (8-4-4-4-12 hex digits)
    ${uuid}=    Get From Dictionary    ${json}    uuid
    Should Not Be Empty    ${uuid}
    Should Match Regexp    ${uuid}    ${EXPECTED_UUID_PATTERN}

    Log    Valid UUID4 received: ${uuid}

Verify UUID Endpoint Generates Unique Values
    [Documentation]    Verify /uuid endpoint generates different UUIDs on consecutive calls
    [Tags]    edge-case    dynamic-data    uuid
    ${response1}=    Send GET Request With Retry    ${UUID_ENDPOINT}
    ${json1}=    Set Variable    ${response1.json()}
    ${uuid1}=    Get From Dictionary    ${json1}    uuid

    ${response2}=    Send GET Request With Retry    ${UUID_ENDPOINT}
    ${json2}=    Set Variable    ${response2.json()}
    ${uuid2}=    Get From Dictionary    ${json2}    uuid

    Should Not Be Equal As Strings    ${uuid1}    ${uuid2}

    Log    UUIDs are unique: ${uuid1} != ${uuid2}

Verify UUID Endpoint Returns Only UUID Key
    [Documentation]    Verify response contains only uuid key (no extra fields)
    [Tags]    edge-case    dynamic-data    uuid
    ${response}=    Send GET Request With Retry    ${UUID_ENDPOINT}
    ${json}=    Set Variable    ${response.json()}

    ${keys}=    Get Dictionary Keys    ${json}
    ${key_count}=    Get Length    ${keys}
    Should Be Equal As Numbers    ${key_count}    1
    Dictionary Should Contain Key    ${json}    uuid

    Log    Response structure validated

Verify UUID Endpoint Rejects POST Method
    [Documentation]    Verify /uuid endpoint rejects POST requests
    [Tags]    negative    dynamic-data    uuid
    ${response}=    Send POST Request    ${UUID_ENDPOINT}
    Validate Response Status    ${response}    405

    Log    POST method correctly rejected

Verify UUID Endpoint Rejects PUT Method
    [Documentation]    Verify /uuid endpoint rejects PUT requests
    [Tags]    negative    dynamic-data    uuid
    ${response}=    Send PUT Request    ${UUID_ENDPOINT}
    Validate Response Status    ${response}    405

    Log    PUT method correctly rejected

Verify UUID Endpoint Returns 404 For Invalid Path
    [Documentation]    Verify /uuid with invalid path returns 404
    [Tags]    negative    dynamic-data    uuid
    ${response}=    Send GET Request    ${UUID_ENDPOINT}/invalid
    Validate Response Status    ${response}    404

    Log    Invalid path correctly returns 404
