*** Settings ***
Documentation    Tests for gzip endpoint
Resource         ../../resources/api_keywords.robot
Resource         ../../resources/variables.robot



*** Test Cases ***
Verify Gzip Endpoint
    [Documentation]    Verify /gzip endpoint returns gzip compressed content
    [Tags]    positive    response-format    compression    gzip
    ${response}=    Send GET Request With Retry    ${GZIP_ENDPOINT}
    Validate Response Status    ${response}    ${EXPECTED_SUCCESS_STATUS}

    # Validate compression header
    Validate Compression Type    ${response}    gzip

    # Validate content was decompressed and is readable JSON
    ${json}=    Set Variable    ${response.json()}
    Should Not Be Empty    ${json}
    Log    Gzip compression verified
