#########################################################################################
#                        Written by Heiko Horn 2020-09-30                               #
#########################################################################################
### This script will use the Cisco DNA Center API to receive an athentication token and request information from the API Resources

# Create Base64 Authorization header
#$strUser=''
#$strPass=''
#$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $strUser,$strPass)))

$base64AuthInfo = ''
$strApi = 'https://dna.xxx.xxx'

# Function to get an auth token
function getAuthToken ($strEndpoint) {
    $strUri = "$($strApi)$($strEndpoint)"
    $objJson = Invoke-RestMethod -Uri $strUri `
    -SkipCertificateCheck `
    -Headers @{'Content-Type'='application/json'; Authorization=("Basic {0}" -f $base64AuthInfo); 'Accept'='application/json'} `
    -method Post
    Return $objJson
}

# Function to connect to the DNA REST API
function connectToApi ($strToken, $strEndpoint) {
    $strUri = "$($strApi)$($strEndpoint)"
    $objJson = Invoke-RestMethod -Uri $strUri `
    -SkipCertificateCheck `
    -Headers @{'Content-Type'='application/json'; 'X-Auth-Token'="$strToken"; 'Accept'='application/json'}
    Return $objJson
}

# Documentation for REST API Resources
# https://developer.cisco.com/docs/dna-center/api/1-2-5/

# Get an auth token
$strToken = (getAuthToken '/dna/system/api/v1/auth/token').Token

# Get all network devices
$objJson = connectToApi $strToken '/dna/intent/api/v1/network-device'
$objJson.response

# Count all network devices
$objJson = connectToApi $strToken '/dna/intent/api/v1/network-device/count'
$objJson.response

# Get all sites
$objJson = connectToApi $strToken '/dna/intent/api/v1/site'
$objJson.response