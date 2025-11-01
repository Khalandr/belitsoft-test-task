*** Settings ***
Documentation    Tests for XML response format
Resource         ../../resources/api_keywords.robot
Resource         ../../resources/variables.robot



*** Test Cases ***
Verify XML Endpoint
    [Documentation]    Verify /xml endpoint returns valid XML format
    [Tags]    positive    response-format    xml
    ${response}=    Send GET Request With Retry    ${VALID_XML_ENDPOINT}
    Validate Response Status    ${response}    ${EXPECTED_SUCCESS_STATUS}

    # Validate Content-Type header
    Validate Response Header Value    ${response}    Content-Type    application/xml

    # Validate XML can be parsed
    Validate XML Response    ${response}
