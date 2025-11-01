*** Settings ***
Documentation    Tests for user-agent endpoint
Resource         ../../resources/api_keywords.robot
Resource         ../../resources/variables.robot



*** Test Cases ***
Verify User-Agent Endpoint
    [Documentation]    Verify /user-agent endpoint returns User-Agent header correctly
    [Tags]    positive    request-inspection    user-agent
    ${custom_headers}=    Create Dictionary    User-Agent=${TEST_USER_AGENT}

    ${response}=    Send GET Request With Retry    ${USER_AGENT_ENDPOINT}    headers=${custom_headers}
    Validate Response Status    ${response}    ${EXPECTED_SUCCESS_STATUS}

    # Validate Content-Type header
    Validate Response Header Value    ${response}    Content-Type    application/json

    # Validate response JSON structure
    ${json}=    Set Variable    ${response.json()}
    Dictionary Should Contain Key    ${json}    user-agent

    # Validate user-agent value matches custom header
    ${user_agent}=    Get From Dictionary    ${json}    user-agent
    Should Be Equal As Strings    ${user_agent}    ${TEST_USER_AGENT}

    Log    User-Agent validated: ${user_agent}

Verify User-Agent Endpoint Returns Only User-Agent Key
    [Documentation]    Verify response contains only user-agent key (no extra fields)
    [Tags]    edge-case    request-inspection    user-agent
    ${response}=    Send GET Request With Retry    ${USER_AGENT_ENDPOINT}
    Validate Response Status    ${response}    ${EXPECTED_SUCCESS_STATUS}

    ${json}=    Set Variable    ${response.json()}
    ${keys}=    Get Dictionary Keys    ${json}
    ${key_count}=    Get Length    ${keys}

    # Response should have exactly 1 key: user-agent
    Should Be Equal As Numbers    ${key_count}    1
    Dictionary Should Contain Key    ${json}    user-agent

    Log    Response structure validated: only user-agent key present

Verify User-Agent Endpoint With Special Characters
    [Documentation]    Verify User-Agent with special characters is reflected correctly
    [Tags]    edge-case    request-inspection    user-agent
    ${special_ua}=    Set Variable    TestBot/1.0 (+http://example.com/bot) Mozilla/5.0 @#$%
    ${custom_headers}=    Create Dictionary    User-Agent=${special_ua}

    ${response}=    Send GET Request With Retry    ${USER_AGENT_ENDPOINT}    headers=${custom_headers}
    Validate Response Status    ${response}    ${EXPECTED_SUCCESS_STATUS}

    ${json}=    Set Variable    ${response.json()}
    ${user_agent}=    Get From Dictionary    ${json}    user-agent

    Should Be Equal As Strings    ${user_agent}    ${special_ua}

    Log    Special characters in User-Agent handled correctly

Verify User-Agent Endpoint With Long User-Agent
    [Documentation]    Verify very long User-Agent strings are handled
    [Tags]    edge-case    request-inspection    user-agent
    ${long_ua}=    Evaluate    "Mozilla/5.0 " + "A" * 500
    ${custom_headers}=    Create Dictionary    User-Agent=${long_ua}

    ${response}=    Send GET Request With Retry    ${USER_AGENT_ENDPOINT}    headers=${custom_headers}
    Validate Response Status    ${response}    ${EXPECTED_SUCCESS_STATUS}

    ${json}=    Set Variable    ${response.json()}
    ${user_agent}=    Get From Dictionary    ${json}    user-agent

    ${length}=    Get Length    ${user_agent}
    Should Be True    ${length} > 500

    Log    Long User-Agent handled correctly: ${length} characters

Verify User-Agent Endpoint Without User-Agent Header
    [Documentation]    Verify endpoint handles missing User-Agent header gracefully
    [Tags]    edge-case    request-inspection    user-agent
    # Don't send User-Agent header - RequestsLibrary will send default
    ${response}=    Send GET Request With Retry    ${USER_AGENT_ENDPOINT}
    Validate Response Status    ${response}    ${EXPECTED_SUCCESS_STATUS}

    ${json}=    Set Variable    ${response.json()}
    Dictionary Should Contain Key    ${json}    user-agent

    # Should have default User-Agent from RequestsLibrary
    ${user_agent}=    Get From Dictionary    ${json}    user-agent
    Should Not Be Empty    ${user_agent}

    Log    Default User-Agent returned: ${user_agent}

Verify User-Agent Endpoint Rejects POST Method
    [Documentation]    Verify /user-agent endpoint rejects POST requests
    [Tags]    negative    request-inspection    user-agent
    ${response}=    Send POST Request    ${USER_AGENT_ENDPOINT}

    Validate Response Status    ${response}    405

    Log    POST method correctly rejected

Verify User-Agent Endpoint Rejects PUT Method
    [Documentation]    Verify /user-agent endpoint rejects PUT requests
    [Tags]    negative    request-inspection    user-agent
    ${response}=    Send PUT Request    ${USER_AGENT_ENDPOINT}

    Validate Response Status    ${response}    405

    Log    PUT method correctly rejected

Verify User-Agent Endpoint Rejects DELETE Method
    [Documentation]    Verify /user-agent endpoint rejects DELETE requests
    [Tags]    negative    request-inspection    user-agent
    ${response}=    Send DELETE Request    ${USER_AGENT_ENDPOINT}

    Validate Response Status    ${response}    405

    Log    DELETE method correctly rejected

Verify User-Agent Endpoint Returns 404 For Invalid Path
    [Documentation]    Verify /user-agent with invalid path returns 404
    [Tags]    negative    request-inspection    user-agent
    ${response}=    Send GET Request    ${USER_AGENT_ENDPOINT}/invalid

    Validate Response Status    ${response}    404

    Log    Invalid path correctly returns 404
