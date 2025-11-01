*** Settings ***
Documentation    Tests for deflate endpoint
Resource         ../../resources/api_keywords.robot
Resource         ../../resources/variables.robot



*** Test Cases ***
Verify Deflate Endpoint
    [Documentation]    Verify /deflate endpoint returns deflate compressed content
    [Tags]    positive    response-format    compression    deflate
    ${response}=    Send GET Request With Retry    ${DEFLATE_ENDPOINT}
    Validate Response Status    ${response}    ${EXPECTED_SUCCESS_STATUS}

    # Validate compression header
    Validate Compression Type    ${response}    deflate

    # Validate content was decompressed and is readable JSON
    ${json}=    Set Variable    ${response.json()}
    Should Not Be Empty    ${json}
    Log    Deflate compression verified
