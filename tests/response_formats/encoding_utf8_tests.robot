*** Settings ***
Documentation    Tests for encoding/utf8 endpoint
Resource         ../../resources/api_keywords.robot
Resource         ../../resources/variables.robot



*** Test Cases ***
Verify UTF8 Encoding Endpoint
    [Documentation]    Verify /encoding/utf8 endpoint returns UTF-8 content
    [Tags]    positive    response-format    encoding
    ${response}=    Send GET Request With Retry    /encoding/utf8
    Validate Response Status    ${response}    200

    # Validate Content-Type includes charset
    Validate Response Header Value    ${response}    Content-Type    charset=utf-8

    # Validate UTF-8 content
    Should Not Be Empty    ${response.text}
    Should Contain    ${response.text}    UTF-8
    Log    UTF-8 encoding verified
