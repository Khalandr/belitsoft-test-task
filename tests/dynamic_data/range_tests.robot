*** Settings ***
Documentation    Tests for range endpoint
Resource         ../../resources/api_keywords.robot
Resource         ../../resources/variables.robot



*** Test Cases ***
Verify Range Endpoint
    [Documentation]    Verify /range/n returns n bytes in chunks
    [Tags]    positive    dynamic-data    range
    ${response}=    Send GET Request With Retry    /range/1024
    Validate Response Status    ${response}    200

    # Validate content is 1024 bytes
    ${length}=    Get Length    ${response.content}
    Should Be Equal As Integers    ${length}    1024
    Log    Range endpoint returned ${length} bytes
