*** Settings ***
Documentation    All variables for HTTPBin test automation


*** Variables ***
# HTTPBin Configuration
${HTTPBIN_BASE_URL}           https://httpbin.org
${HTTPBIN_TIMEOUT}            30
${HTTPBIN_VERIFY_SSL}         ${TRUE}

# Retry Configuration
${RETRY_MAX_ATTEMPTS}         3
${RETRY_DELAY}                1
${RETRY_BACKOFF}              2

# Logging Configuration
${LOG_LEVEL}                  INFO

# Sample Test Data
${TEST_USER_NAME}             John Doe
${TEST_EMAIL}                 test@example.com
${TEST_USER_AGENT}            Robot-Framework-Test-Agent/1.0

# HTTP Test Data
${VALID_JSON_ENDPOINT}        /json
${VALID_XML_ENDPOINT}         /xml
${VALID_HTML_ENDPOINT}        /html
${VALID_GET_ENDPOINT}         /get
${VALID_POST_ENDPOINT}        /post
${VALID_PUT_ENDPOINT}         /put
${VALID_DELETE_ENDPOINT}      /delete
${VALID_PATCH_ENDPOINT}       /patch

# Dynamic Data Endpoints
${UUID_ENDPOINT}              /uuid
${DELAY_ENDPOINT}             /delay
${STREAM_ENDPOINT}            /stream
${BYTES_ENDPOINT}             /bytes
${DRIP_ENDPOINT}              /drip
${LINKS_ENDPOINT}             /links

# Compression Endpoints
${GZIP_ENDPOINT}              /gzip
${BROTLI_ENDPOINT}            /brotli
${DEFLATE_ENDPOINT}           /deflate

# Additional Response Format Endpoints
${DENY_ENDPOINT}              /deny
${ROBOTS_ENDPOINT}            /robots.txt

# Request Inspection Endpoints
${HEADERS_ENDPOINT}           /headers
${IP_ENDPOINT}                /ip
${USER_AGENT_ENDPOINT}        /user-agent

# Expected Values
${EXPECTED_SUCCESS_STATUS}    200
${EXPECTED_UUID_PATTERN}      ^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$
