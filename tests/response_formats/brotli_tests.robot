*** Settings ***
Documentation    Tests for brotli endpoint
Resource         ../../resources/api_keywords.robot
Resource         ../../resources/variables.robot



*** Test Cases ***
Verify Brotli Endpoint
    [Documentation]    Verify /brotli endpoint returns brotli compressed content
    [Tags]    positive    response-format    compression    brotli
    ${response}=    Send GET Request With Retry    ${BROTLI_ENDPOINT}
    Validate Response Status    ${response}    ${EXPECTED_SUCCESS_STATUS}

    # Validate compression header
    Validate Compression Type    ${response}    br

    # Validate content was decompressed
    Should Not Be Empty    ${response.text}
    Log    Brotli compression verified
