*** Settings ***
Documentation    Tests for JSON endpoint
Resource         ../../resources/api_keywords.robot
Resource         ../../resources/variables.robot



*** Test Cases ***
Verify JSON Endpoint
    [Documentation]    Verify /json endpoint returns valid JSON format
    [Tags]    positive    response-format    json
    ${response}=    Send GET Request With Retry    ${VALID_JSON_ENDPOINT}
    Validate Response Status    ${response}    ${EXPECTED_SUCCESS_STATUS}

    # Validate Content-Type header
    Validate Response Header Value    ${response}    Content-Type    application/json

    # Validate JSON structure
    ${json}=    Set Variable    ${response.json()}
    Should Not Be Empty    ${json}
    Log    JSON Response received
