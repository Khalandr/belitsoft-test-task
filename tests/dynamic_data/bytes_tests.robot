*** Settings ***
Documentation    Tests for bytes endpoint
Resource         ../../resources/api_keywords.robot
Resource         ../../resources/variables.robot



*** Test Cases ***
Verify Bytes Endpoint
    [Documentation]    Verify /bytes/n returns n random bytes
    [Tags]    positive    dynamic-data    bytes
    ${response}=    Send GET Request With Retry    /bytes/100
    Validate Response Status    ${response}    ${EXPECTED_SUCCESS_STATUS}

    # Validate content length is 100 bytes
    Validate Response Length    ${response}    100

    Log    100 bytes received successfully

Verify Bytes Endpoint With Zero Bytes
    [Documentation]    Verify /bytes/0 returns empty response
    [Tags]    edge-case    dynamic-data    bytes
    ${response}=    Send GET Request With Retry    /bytes/0
    Validate Response Status    ${response}    ${EXPECTED_SUCCESS_STATUS}

    Validate Response Length    ${response}    0

    Log    Zero bytes handled correctly

Verify Bytes Endpoint With Large Number
    [Documentation]    Verify /bytes endpoint handles large byte counts
    [Tags]    edge-case    dynamic-data    bytes
    ${response}=    Send GET Request With Retry    /bytes/10000
    Validate Response Status    ${response}    ${EXPECTED_SUCCESS_STATUS}

    Validate Response Length    ${response}    10000

    Log    Large byte count handled successfully

Verify Bytes Endpoint Rejects POST Method
    [Documentation]    Verify /bytes endpoint rejects POST requests
    [Tags]    negative    dynamic-data    bytes
    ${response}=    Send POST Request    /bytes/100
    Validate Response Status    ${response}    405

    Log    POST method correctly rejected

Verify Bytes Endpoint Rejects PUT Method
    [Documentation]    Verify /bytes endpoint rejects PUT requests
    [Tags]    negative    dynamic-data    bytes
    ${response}=    Send PUT Request    /bytes/100
    Validate Response Status    ${response}    405

    Log    PUT method correctly rejected

Verify Bytes Endpoint With Invalid Parameter
    [Documentation]    Verify /bytes with non-numeric parameter returns 404
    [Tags]    negative    dynamic-data    bytes
    ${response}=    Send GET Request    /bytes/abc
    Validate Response Status    ${response}    404

    Log    Invalid parameter correctly returns 404

Verify Bytes Endpoint Without Parameter
    [Documentation]    Verify /bytes without parameter returns 404
    [Tags]    negative    dynamic-data    bytes
    ${response}=    Send GET Request    /bytes
    Validate Response Status    ${response}    404

    Log    Missing parameter correctly returns 404
