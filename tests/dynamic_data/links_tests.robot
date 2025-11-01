*** Settings ***
Documentation    Tests for links endpoint (generates pages with links)
Resource         ../../resources/api_keywords.robot
Resource         ../../resources/variables.robot



*** Test Cases ***
Verify Links Endpoint
    [Documentation]    Verify /links/{n}/{offset} endpoint generates page with links
    [Tags]    positive    dynamic-data    links
    ${response}=    Send GET Request With Retry    ${LINKS_ENDPOINT}/10/2
    Validate Response Status    ${response}    200

    # Validate response is HTML with links
    Should Contain    ${response.text}    <html
    Should Contain    ${response.text}    <a
    Should Contain    ${response.text}    href
    Log    Links page generated successfully
