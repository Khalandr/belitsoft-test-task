*** Settings ***
Documentation    Tests for robots.txt endpoint
Resource         ../../resources/api_keywords.robot
Resource         ../../resources/variables.robot



*** Test Cases ***
Verify Robots.txt Endpoint
    [Documentation]    Verify /robots.txt endpoint returns robots.txt content
    [Tags]    positive    response-format    robots
    ${response}=    Send GET Request With Retry    ${ROBOTS_ENDPOINT}
    Validate Response Status    ${response}    ${EXPECTED_SUCCESS_STATUS}

    # Validate Content-Type header
    ${content_type}=    Get From Dictionary    ${response.headers}    Content-Type
    Should Contain    ${content_type}    text/plain

    # Validate contains robots.txt directives
    Should Not Be Empty    ${response.text}
    Should Contain    ${response.text}    User-agent
    Log    Robots.txt content received
