*** Settings ***
Documentation    Tests for deny endpoint
Resource         ../../resources/api_keywords.robot
Resource         ../../resources/variables.robot



*** Test Cases ***
Verify Deny Endpoint
    [Documentation]    Verify /deny endpoint returns 200 status
    [Tags]    positive    response-format    deny
    ${response}=    Send GET Request With Retry    ${DENY_ENDPOINT}
    Validate Response Status    ${response}    ${EXPECTED_SUCCESS_STATUS}

    # Validate response has content
    Should Not Be Empty    ${response.text}
    Log    Deny page returned successfully
