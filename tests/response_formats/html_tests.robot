*** Settings ***
Documentation    Tests for HTML endpoint
Resource         ../../resources/api_keywords.robot
Resource         ../../resources/variables.robot



*** Test Cases ***
Verify HTML Endpoint
    [Documentation]    Verify /html endpoint returns valid HTML
    [Tags]    positive    response-format    html
    ${response}=    Send GET Request With Retry    ${VALID_HTML_ENDPOINT}
    Validate Response Status    ${response}    200

    # Validate response contains HTML
    Should Contain    ${response.text}    <html
    Should Contain    ${response.text}    </html>
    Log    HTML Response received
