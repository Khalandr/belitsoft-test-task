*** Settings ***
Documentation    Tests for drip endpoint (data dripping over time)
Resource         ../../resources/api_keywords.robot
Resource         ../../resources/variables.robot



*** Test Cases ***
Verify Drip Endpoint
    [Documentation]    Verify /drip endpoint drips data over time
    [Tags]    positive    dynamic-data    drip
    ${response}=    Send GET Request With Retry    ${DRIP_ENDPOINT}?duration=1&numbytes=10&code=200
    Validate Response Status    ${response}    200

    # Validate response contains data
    Should Not Be Empty    ${response.content}
    ${content_length}=    Evaluate    len($response.content)
    Should Be True    ${content_length} >= 10
    Log    Drip returned ${content_length} bytes
