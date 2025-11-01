*** Settings ***
Documentation    API keywords for HTTP operations and response validation
Library          RequestsLibrary
Library          Collections
Library          String
Library          XML
Resource         variables.robot


*** Keywords ***
Send GET Request With Retry
    [Documentation]    Send GET request to HTTPBin with retry logic
    [Arguments]    ${endpoint}    ${params}=${EMPTY}    ${headers}=${EMPTY}
    ${full_url}=    Set Variable    ${HTTPBIN_BASE_URL}${endpoint}

    # Use Robot Framework's built-in retry mechanism
    ${response}=    Wait Until Keyword Succeeds    ${RETRY_MAX_ATTEMPTS}x    ${RETRY_DELAY}s
    ...    GET    ${full_url}    params=${params}    headers=${headers}    verify=${HTTPBIN_VERIFY_SSL}

    RETURN    ${response}

Send POST Request With Retry
    [Documentation]    Send POST request to HTTPBin with retry logic
    [Arguments]    ${endpoint}    ${data}=${EMPTY}    ${json}=${EMPTY}    ${headers}=${EMPTY}
    ${full_url}=    Set Variable    ${HTTPBIN_BASE_URL}${endpoint}

    # Use Robot Framework's built-in retry mechanism
    ${response}=    Wait Until Keyword Succeeds    ${RETRY_MAX_ATTEMPTS}x    ${RETRY_DELAY}s
    ...    POST    ${full_url}    data=${data}    json=${json}    headers=${headers}    verify=${HTTPBIN_VERIFY_SSL}

    RETURN    ${response}

Send PUT Request With Retry
    [Documentation]    Send PUT request to HTTPBin with retry logic
    [Arguments]    ${endpoint}    ${data}=${EMPTY}    ${json}=${EMPTY}    ${headers}=${EMPTY}
    ${full_url}=    Set Variable    ${HTTPBIN_BASE_URL}${endpoint}

    # Use Robot Framework's built-in retry mechanism
    ${response}=    Wait Until Keyword Succeeds    ${RETRY_MAX_ATTEMPTS}x    ${RETRY_DELAY}s
    ...    PUT    ${full_url}    data=${data}    json=${json}    headers=${headers}    verify=${HTTPBIN_VERIFY_SSL}

    RETURN    ${response}

Send DELETE Request With Retry
    [Documentation]    Send DELETE request to HTTPBin with retry logic
    [Arguments]    ${endpoint}    ${headers}=${EMPTY}
    ${full_url}=    Set Variable    ${HTTPBIN_BASE_URL}${endpoint}

    # Use Robot Framework's built-in retry mechanism
    ${response}=    Wait Until Keyword Succeeds    ${RETRY_MAX_ATTEMPTS}x    ${RETRY_DELAY}s
    ...    DELETE    ${full_url}    headers=${headers}    verify=${HTTPBIN_VERIFY_SSL}

    RETURN    ${response}

Send PATCH Request With Retry
    [Documentation]    Send PATCH request to HTTPBin with retry logic
    [Arguments]    ${endpoint}    ${data}=${EMPTY}    ${json}=${EMPTY}    ${headers}=${EMPTY}
    ${full_url}=    Set Variable    ${HTTPBIN_BASE_URL}${endpoint}

    # Use Robot Framework's built-in retry mechanism
    ${response}=    Wait Until Keyword Succeeds    ${RETRY_MAX_ATTEMPTS}x    ${RETRY_DELAY}s
    ...    PATCH    ${full_url}    data=${data}    json=${json}    headers=${headers}    verify=${HTTPBIN_VERIFY_SSL}

    RETURN    ${response}

Validate Response Status
    [Documentation]    Validate that response has expected status code
    [Arguments]    ${response}    ${expected_status}
    Should Be Equal As Integers    ${response.status_code}    ${expected_status}
    ...    msg=Expected status ${expected_status} but got ${response.status_code}

Validate Response Is Success
    [Documentation]    Validate that response has 2xx status code
    [Arguments]    ${response}
    Validate Status Code In Range    ${response}    200    299

Extract Response Body
    [Documentation]    Extract response body as text
    [Arguments]    ${response}
    RETURN    ${response.text}

Send GET Request
    [Documentation]    Send GET request without retry (for negative tests)
    [Arguments]    ${endpoint}    ${params}=${EMPTY}    ${headers}=${EMPTY}
    ${full_url}=    Set Variable    ${HTTPBIN_BASE_URL}${endpoint}

    ${response}=    GET    ${full_url}    params=${params}    headers=${headers}    verify=${HTTPBIN_VERIFY_SSL}    expected_status=any

    RETURN    ${response}

Send POST Request
    [Documentation]    Send POST request without retry (for negative tests)
    [Arguments]    ${endpoint}    ${data}=${EMPTY}    ${json}=${EMPTY}    ${headers}=${EMPTY}
    ${full_url}=    Set Variable    ${HTTPBIN_BASE_URL}${endpoint}

    ${response}=    POST    ${full_url}    data=${data}    json=${json}    headers=${headers}    verify=${HTTPBIN_VERIFY_SSL}    expected_status=any

    RETURN    ${response}

Send PUT Request
    [Documentation]    Send PUT request without retry (for negative tests)
    [Arguments]    ${endpoint}    ${data}=${EMPTY}    ${json}=${EMPTY}    ${headers}=${EMPTY}
    ${full_url}=    Set Variable    ${HTTPBIN_BASE_URL}${endpoint}

    ${response}=    PUT    ${full_url}    data=${data}    json=${json}    headers=${headers}    verify=${HTTPBIN_VERIFY_SSL}    expected_status=any

    RETURN    ${response}

Send DELETE Request
    [Documentation]    Send DELETE request without retry (for negative tests)
    [Arguments]    ${endpoint}    ${headers}=${EMPTY}
    ${full_url}=    Set Variable    ${HTTPBIN_BASE_URL}${endpoint}

    ${response}=    DELETE    ${full_url}    headers=${headers}    verify=${HTTPBIN_VERIFY_SSL}    expected_status=any

    RETURN    ${response}


Validate JSON Response Schema
    [Documentation]    Validate JSON response has expected fields and types
    [Arguments]    ${response}    @{field_types}
    ${json}=    Set Variable    ${response.json()}

    FOR    ${field_type}    IN    @{field_types}
        @{parts}=    Split String    ${field_type}    :
        ${field}=    Set Variable    ${parts}[0]
        ${type}=    Set Variable    ${parts}[1]

        # Validate field exists
        Dictionary Should Contain Key    ${json}    ${field}
        ...    msg=Field '${field}' not found in response

        # Validate field type
        ${value}=    Get From Dictionary    ${json}    ${field}
        ${actual_type}=    Evaluate    type($value).__name__
        Run Keyword If    '${type}' == 'str'    Should Be Equal    ${actual_type}    str
        Run Keyword If    '${type}' == 'int'    Should Be Equal    ${actual_type}    int
        Run Keyword If    '${type}' == 'dict'    Should Be Equal    ${actual_type}    dict
        Run Keyword If    '${type}' == 'list'    Should Be Equal    ${actual_type}    list
        Run Keyword If    '${type}' == 'bool'    Should Be Equal    ${actual_type}    bool
    END

Validate JSON Response Contains Key
    [Documentation]    Validate that JSON response contains a specific key
    [Arguments]    ${response}    ${key}
    ${json}=    Set Variable    ${response.json()}
    Dictionary Should Contain Key    ${json}    ${key}
    ...    msg=JSON response does not contain key '${key}'

Validate JSON Response Key Value
    [Documentation]    Validate that a JSON key has expected value
    [Arguments]    ${response}    ${key}    ${expected_value}
    ${json}=    Set Variable    ${response.json()}
    ${actual_value}=    Get From Dictionary    ${json}    ${key}
    Should Be Equal    ${actual_value}    ${expected_value}
    ...    msg=Expected '${expected_value}' for key '${key}', got '${actual_value}'

Validate XML Response
    [Documentation]    Validate XML response structure
    [Arguments]    ${response}
    ${xml}=    Parse XML    ${response.text}
    Should Not Be Empty    ${xml}    msg=XML response is empty

Validate XML Contains Element
    [Documentation]    Validate XML contains specific element
    [Arguments]    ${response}    ${xpath}
    ${xml}=    Parse XML    ${response.text}
    ${elements}=    Get Elements    ${xml}    ${xpath}
    Should Not Be Empty    ${elements}    msg=XML does not contain element at '${xpath}'

Validate Response Headers
    [Documentation]    Validate response has expected headers
    [Arguments]    ${response}    @{expected_headers}
    FOR    ${header}    IN    @{expected_headers}
        Should Contain    ${response.headers}    ${header}
        ...    msg=Response does not contain header '${header}'
    END

Validate Response Header Value
    [Documentation]    Validate specific header has expected value
    [Arguments]    ${response}    ${header_name}    ${expected_value}
    Dictionary Should Contain Key    ${response.headers}    ${header_name}
    ...    msg=Header '${header_name}' not found in response
    ${actual_value}=    Get From Dictionary    ${response.headers}    ${header_name}
    Should Contain    ${actual_value}    ${expected_value}
    ...    msg=Header '${header_name}' expected '${expected_value}', got '${actual_value}'

Validate Compression Type
    [Documentation]    Validate response uses expected compression
    [Arguments]    ${response}    ${expected_encoding}
    Dictionary Should Contain Key    ${response.headers}    Content-Encoding
    ${encoding}=    Get From Dictionary    ${response.headers}    Content-Encoding
    Should Be Equal    ${encoding}    ${expected_encoding}
    ...    msg=Expected compression '${expected_encoding}', got '${encoding}'

Validate Response Contains Text
    [Documentation]    Validate response body contains expected text
    [Arguments]    ${response}    ${expected_text}
    Should Contain    ${response.text}    ${expected_text}
    ...    msg=Response does not contain expected text: '${expected_text}'

Validate Response Length
    [Documentation]    Validate response content length
    [Arguments]    ${response}    ${expected_length}
    ${actual_length}=    Get Length    ${response.content}
    Should Be Equal As Integers    ${actual_length}    ${expected_length}
    ...    msg=Expected length ${expected_length}, got ${actual_length}

Validate Response Time
    [Documentation]    Validate response time is within acceptable range
    [Arguments]    ${response}    ${max_time_ms}
    ${response_time_seconds}=    Evaluate    ${response.elapsed.total_seconds()}
    ${response_time}=    Evaluate    ${response_time_seconds} * 1000
    Should Be True    ${response_time} <= ${max_time_ms}
    ...    msg=Response time ${response_time}ms exceeds max ${max_time_ms}ms
