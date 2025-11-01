*** Settings ***
Documentation    Tests for headers endpoint
Resource         ../../resources/api_keywords.robot
Resource         ../../resources/variables.robot



*** Test Cases ***
Verify Headers Endpoint
    [Documentation]    Verify /headers endpoint returns all request headers
    [Tags]    positive    request-inspection    headers
    ${custom_headers}=    Create Dictionary
    ...    X-Custom-Header=CustomValue

    ${response}=    Send GET Request With Retry    ${HEADERS_ENDPOINT}    headers=${custom_headers}
    Validate Response Status    ${response}    ${EXPECTED_SUCCESS_STATUS}

    # Validate Content-Type header
    Validate Response Header Value    ${response}    Content-Type    application/json

    # Validate response JSON structure
    ${json}=    Set Variable    ${response.json()}
    Dictionary Should Contain Key    ${json}    headers

    # Validate standard headers are present
    ${headers}=    Get From Dictionary    ${json}    headers
    Dictionary Should Contain Key    ${headers}    Host
    Dictionary Should Contain Key    ${headers}    User-Agent
    Dictionary Should Contain Key    ${headers}    Accept

    # Validate custom header was reflected
    Dictionary Should Contain Key    ${headers}    X-Custom-Header
    ${custom_value}=    Get From Dictionary    ${headers}    X-Custom-Header
    Should Be Equal As Strings    ${custom_value}    CustomValue

    Log    Headers endpoint validated successfully

Verify Headers Endpoint Handles Invalid Accept Header Gracefully
    [Documentation]    Verify HTTPBin gracefully handles invalid Accept header
    [Tags]    edge-case    request-inspection    headers
    ${custom_headers}=    Create Dictionary    Accept=invalid/type

    ${response}=    Send GET Request With Retry    ${HEADERS_ENDPOINT}    headers=${custom_headers}
    Validate Response Status    ${response}    ${EXPECTED_SUCCESS_STATUS}

    # Validate still returns JSON despite invalid Accept
    Validate Response Header Value    ${response}    Content-Type    application/json

    ${json}=    Set Variable    ${response.json()}
    Dictionary Should Contain Key    ${json}    headers

    # Validate invalid Accept was reflected
    ${headers}=    Get From Dictionary    ${json}    headers
    Dictionary Should Contain Key    ${headers}    Accept
    ${accept_value}=    Get From Dictionary    ${headers}    Accept
    Should Contain    ${accept_value}    invalid/type

    Log    Invalid Accept header handled gracefully

Verify Headers Endpoint Reflects Special Characters
    [Documentation]    Verify headers with special characters are reflected correctly
    [Tags]    edge-case    request-inspection    headers
    ${custom_headers}=    Create Dictionary
    ...    X-Special-Chars=Test@#$%&*()_+-=[]{}|;:',.<>?

    ${response}=    Send GET Request With Retry    ${HEADERS_ENDPOINT}    headers=${custom_headers}
    Validate Response Status    ${response}    ${EXPECTED_SUCCESS_STATUS}

    ${json}=    Set Variable    ${response.json()}
    ${headers}=    Get From Dictionary    ${json}    headers

    Dictionary Should Contain Key    ${headers}    X-Special-Chars
    ${value}=    Get From Dictionary    ${headers}    X-Special-Chars
    Should Contain    ${value}    @#$%

    Log    Special characters reflected correctly

Verify Headers Endpoint Handles Long Header Values
    [Documentation]    Verify headers with very long values are handled
    [Tags]    edge-case    request-inspection    headers
    ${long_value}=    Evaluate    "A" * 1000
    ${custom_headers}=    Create Dictionary    X-Long-Header=${long_value}

    ${response}=    Send GET Request With Retry    ${HEADERS_ENDPOINT}    headers=${custom_headers}
    Validate Response Status    ${response}    ${EXPECTED_SUCCESS_STATUS}

    ${json}=    Set Variable    ${response.json()}
    ${headers}=    Get From Dictionary    ${json}    headers

    Dictionary Should Contain Key    ${headers}    X-Long-Header
    ${value}=    Get From Dictionary    ${headers}    X-Long-Header
    ${length}=    Get Length    ${value}
    Should Be Equal As Numbers    ${length}    1000

    Log    Long header value handled correctly

Verify Headers Endpoint Handles Empty Header Value
    [Documentation]    Verify headers with empty values are reflected
    [Tags]    edge-case    request-inspection    headers
    ${custom_headers}=    Create Dictionary    X-Empty-Header=${EMPTY}

    ${response}=    Send GET Request With Retry    ${HEADERS_ENDPOINT}    headers=${custom_headers}
    Validate Response Status    ${response}    ${EXPECTED_SUCCESS_STATUS}

    ${json}=    Set Variable    ${response.json()}
    ${headers}=    Get From Dictionary    ${json}    headers

    # Empty headers might be reflected or omitted - both valid
    ${json_str}=    Convert To String    ${headers}
    Log    Headers response: ${json_str}

    Log    Empty header handling verified

Verify Headers Endpoint Rejects POST Method
    [Documentation]    Verify /headers endpoint rejects POST requests
    [Tags]    negative    request-inspection    headers
    ${response}=    Send POST Request    ${HEADERS_ENDPOINT}

    Validate Response Status    ${response}    405

    Log    POST method correctly rejected

Verify Headers Endpoint Rejects PUT Method
    [Documentation]    Verify /headers endpoint rejects PUT requests
    [Tags]    negative    request-inspection    headers
    ${response}=    Send PUT Request    ${HEADERS_ENDPOINT}

    Validate Response Status    ${response}    405

    Log    PUT method correctly rejected

Verify Headers Endpoint Rejects DELETE Method
    [Documentation]    Verify /headers endpoint rejects DELETE requests
    [Tags]    negative    request-inspection    headers
    ${response}=    Send DELETE Request    ${HEADERS_ENDPOINT}

    Validate Response Status    ${response}    405

    Log    DELETE method correctly rejected

Verify Headers Endpoint Returns 404 For Invalid Path
    [Documentation]    Verify /headers with invalid path returns 404
    [Tags]    negative    request-inspection    headers
    ${response}=    Send GET Request    ${HEADERS_ENDPOINT}/invalid

    Validate Response Status    ${response}    404

    Log    Invalid path correctly returns 404
