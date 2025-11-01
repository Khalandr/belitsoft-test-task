*** Settings ***
Documentation    Tests for stream-bytes endpoint
Resource         ../../resources/api_keywords.robot
Resource         ../../resources/variables.robot



*** Test Cases ***
Verify Stream Bytes Endpoint
    [Documentation]    Verify /stream-bytes/n streams n random bytes
    [Tags]    positive    dynamic-data    stream-bytes
    ${response}=    Send GET Request With Retry    /stream-bytes/500
    Validate Response Status    ${response}    200

    # Validate content length is 500 bytes
    Validate Response Length    ${response}    500
