*** Settings ***
Documentation    Tests for stream endpoint
Resource         ../../resources/api_keywords.robot
Resource         ../../resources/variables.robot



*** Test Cases ***
Verify Stream Endpoint
    [Documentation]    Verify /stream/n returns n JSON objects
    [Tags]    positive    dynamic-data    stream
    ${response}=    Send GET Request With Retry    /stream/5
    Validate Response Status    ${response}    200

    # Response should contain multiple JSON lines
    Should Not Be Empty    ${response.text}
    Should Contain    ${response.text}    "id"
    Should Contain    ${response.text}    "url"
    Log    Stream endpoint working
