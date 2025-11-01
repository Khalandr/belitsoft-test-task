*** Settings ***
Documentation    Tests for delayed response endpoint
Resource         ../../resources/api_keywords.robot
Resource         ../../resources/variables.robot



*** Test Cases ***
Verify Delay Endpoint With GET
    [Documentation]    Verify /delay endpoint works with GET method (delay up to 10 seconds)
    [Tags]    positive    dynamic-data    delay
    ${response}=    Send GET Request With Retry    /delay/2
    Validate Response Status    ${response}    200

    # Validate response time is at least 2 seconds
    ${response_time}=    Evaluate    ${response.elapsed.total_seconds()} * 1000
    Should Be True    ${response_time} >= 2000
    Should Be True    ${response_time} < 10000    # Allow for retries
    Log    GET delay response time: ${response_time}ms

Verify Delay Endpoint With POST
    [Documentation]    Verify /delay endpoint works with POST method
    [Tags]    positive    dynamic-data    delay
    ${test_data}=    Create Dictionary    test=data
    ${response}=    Send POST Request With Retry    /delay/2    json=${test_data}
    Validate Response Status    ${response}    200

    ${response_time}=    Evaluate    ${response.elapsed.total_seconds()} * 1000
    Should Be True    ${response_time} >= 2000
    Log    POST delay response time: ${response_time}ms

Verify Delay Endpoint With PUT
    [Documentation]    Verify /delay endpoint works with PUT method
    [Tags]    positive    dynamic-data    delay
    ${test_data}=    Create Dictionary    test=data
    ${response}=    Send PUT Request With Retry    /delay/2    json=${test_data}
    Validate Response Status    ${response}    200

    ${response_time}=    Evaluate    ${response.elapsed.total_seconds()} * 1000
    Should Be True    ${response_time} >= 2000
    Log    PUT delay response time: ${response_time}ms

Verify Delay Endpoint With PATCH
    [Documentation]    Verify /delay endpoint works with PATCH method
    [Tags]    positive    dynamic-data    delay
    ${test_data}=    Create Dictionary    test=data
    ${response}=    Send PATCH Request With Retry    /delay/2    json=${test_data}
    Validate Response Status    ${response}    200

    ${response_time}=    Evaluate    ${response.elapsed.total_seconds()} * 1000
    Should Be True    ${response_time} >= 2000
    Log    PATCH delay response time: ${response_time}ms

Verify Delay Endpoint With DELETE
    [Documentation]    Verify /delay endpoint works with DELETE method
    [Tags]    positive    dynamic-data    delay
    ${response}=    Send DELETE Request With Retry    /delay/2
    Validate Response Status    ${response}    200

    ${response_time}=    Evaluate    ${response.elapsed.total_seconds()} * 1000
    Should Be True    ${response_time} >= 2000
    Log    DELETE delay response time: ${response_time}ms
