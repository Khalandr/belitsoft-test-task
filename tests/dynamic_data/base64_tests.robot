*** Settings ***
Documentation    Tests for base64 endpoint
Resource         ../../resources/api_keywords.robot
Resource         ../../resources/variables.robot



*** Test Cases ***
Verify Base64 Endpoint
    [Documentation]    Verify /base64 endpoint decodes base64url encoded string
    [Tags]    positive    dynamic-data    base64
    # Base64 encoded "HTTPBIN is awesome"
    ${encoded}=    Set Variable    SFRUUEJJTiBpcyBhd2Vzb21l

    ${response}=    Send GET Request With Retry    /base64/${encoded}
    Validate Response Status    ${response}    ${EXPECTED_SUCCESS_STATUS}

    # Validate response contains decoded text
    Should Contain    ${response.text}    HTTPBIN is awesome

    Log    Base64 decoded successfully

Verify Base64 Endpoint With Different Encoded Values
    [Documentation]    Verify /base64 endpoint handles various base64 encoded strings
    [Tags]    edge-case    dynamic-data    base64
    # Base64 encoded "Test123"
    ${encoded}=    Set Variable    VGVzdDEyMw==

    ${response}=    Send GET Request With Retry    /base64/${encoded}
    Validate Response Status    ${response}    ${EXPECTED_SUCCESS_STATUS}

    Should Contain    ${response.text}    Test123

    Log    Different base64 value decoded successfully

Verify Base64 Endpoint With Invalid Base64
    [Documentation]    Verify /base64 endpoint handles invalid base64 gracefully
    [Tags]    edge-case    dynamic-data    base64
    ${invalid}=    Set Variable    invalid@@@

    ${response}=    Send GET Request    /base64/${invalid}
    Validate Response Status    ${response}    ${EXPECTED_SUCCESS_STATUS}

    # HTTPBin shows error page for invalid base64
    Should Contain    ${response.text}    Incorrect Base64 data

    Log    Invalid base64 handled gracefully

Verify Base64 Endpoint Rejects POST Method
    [Documentation]    Verify /base64 endpoint rejects POST requests
    [Tags]    negative    dynamic-data    base64
    ${response}=    Send POST Request    /base64/test
    Validate Response Status    ${response}    405

    Log    POST method correctly rejected

Verify Base64 Endpoint Rejects PUT Method
    [Documentation]    Verify /base64 endpoint rejects PUT requests
    [Tags]    negative    dynamic-data    base64
    ${response}=    Send PUT Request    /base64/test
    Validate Response Status    ${response}    405

    Log    PUT method correctly rejected

Verify Base64 Endpoint Without Parameter
    [Documentation]    Verify /base64 without parameter returns 404
    [Tags]    negative    dynamic-data    base64
    ${response}=    Send GET Request    /base64
    Validate Response Status    ${response}    404

    Log    Missing parameter correctly returns 404
