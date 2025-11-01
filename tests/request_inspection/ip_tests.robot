*** Settings ***
Documentation    Tests for ip endpoint
Resource         ../../resources/api_keywords.robot
Resource         ../../resources/variables.robot



*** Test Cases ***
Verify IP Endpoint
    [Documentation]    Verify /ip endpoint returns client IP address
    [Tags]    positive    request-inspection    ip
    ${response}=    Send GET Request With Retry    ${IP_ENDPOINT}
    Validate Response Status    ${response}    ${EXPECTED_SUCCESS_STATUS}

    # Validate Content-Type header
    Validate Response Header Value    ${response}    Content-Type    application/json

    # Validate response JSON structure
    ${json}=    Set Variable    ${response.json()}
    Dictionary Should Contain Key    ${json}    origin

    # Validate origin (IP address) is present and non-empty
    ${ip}=    Get From Dictionary    ${json}    origin
    Should Not Be Empty    ${ip}

    # Validate IP format (IPv4 or IPv6)
    ${is_valid_ip}=    Run Keyword And Return Status    Should Match Regexp    ${ip}    ^\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}
    Run Keyword If    not ${is_valid_ip}    Should Match Regexp    ${ip}    ^[0-9a-fA-F:]+$

    Log    Client IP validated: ${ip}

Verify IP Endpoint Returns Only Origin Key
    [Documentation]    Verify response contains only origin key (no extra fields)
    [Tags]    edge-case    request-inspection    ip
    ${response}=    Send GET Request With Retry    ${IP_ENDPOINT}
    Validate Response Status    ${response}    ${EXPECTED_SUCCESS_STATUS}

    ${json}=    Set Variable    ${response.json()}
    ${keys}=    Get Dictionary Keys    ${json}
    ${key_count}=    Get Length    ${keys}

    # Response should have exactly 1 key: origin
    Should Be Equal As Numbers    ${key_count}    1
    Dictionary Should Contain Key    ${json}    origin

    Log    Response structure validated: only origin key present

Verify IP Endpoint With Custom Headers
    [Documentation]    Verify /ip endpoint ignores custom headers for IP detection
    [Tags]    edge-case    request-inspection    ip
    ${custom_headers}=    Create Dictionary
    ...    X-Forwarded-For=192.168.1.1
    ...    X-Real-IP=10.0.0.1

    ${response}=    Send GET Request With Retry    ${IP_ENDPOINT}    headers=${custom_headers}
    Validate Response Status    ${response}    ${EXPECTED_SUCCESS_STATUS}

    ${json}=    Set Variable    ${response.json()}
    ${ip}=    Get From Dictionary    ${json}    origin

    # IP should be actual client IP, not from X-Forwarded-For
    Should Not Be Equal As Strings    ${ip}    192.168.1.1
    Should Not Be Equal As Strings    ${ip}    10.0.0.1

    Log    Custom headers handled correctly, actual IP returned: ${ip}

Verify IP Endpoint Rejects POST Method
    [Documentation]    Verify /ip endpoint rejects POST requests
    [Tags]    negative    request-inspection    ip
    ${response}=    Send POST Request    ${IP_ENDPOINT}

    Validate Response Status    ${response}    405

    Log    POST method correctly rejected

Verify IP Endpoint Rejects PUT Method
    [Documentation]    Verify /ip endpoint rejects PUT requests
    [Tags]    negative    request-inspection    ip
    ${response}=    Send PUT Request    ${IP_ENDPOINT}

    Validate Response Status    ${response}    405

    Log    PUT method correctly rejected

Verify IP Endpoint Rejects DELETE Method
    [Documentation]    Verify /ip endpoint rejects DELETE requests
    [Tags]    negative    request-inspection    ip
    ${response}=    Send DELETE Request    ${IP_ENDPOINT}

    Validate Response Status    ${response}    405

    Log    DELETE method correctly rejected

Verify IP Endpoint Returns 404 For Invalid Path
    [Documentation]    Verify /ip with invalid path returns 404
    [Tags]    negative    request-inspection    ip
    ${response}=    Send GET Request    ${IP_ENDPOINT}/invalid

    Validate Response Status    ${response}    404

    Log    Invalid path correctly returns 404
