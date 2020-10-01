#########################################################################################
#                        Written by Heiko Horn 2020-09-30                               #
#########################################################################################
### This script will use the Cisco PRIME API and request information from the API Resources

# Create Base64 Authorization header
#$strUser=''
#$strPass=''
#$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $strUser,$strPass)))

$base64AuthInfo = ''
$strApi = 'https://prime.xxx.xxx'

# Function to connect to the DNA REST API
function connectToApi ($strToken, $strEndpoint) {
    $strUri = "$($strApi)$($strEndpoint)"
    $objJson = Invoke-RestMethod -Uri $strUri `
    -SkipCertificateCheck `
    -Headers @{'Content-Type'='application/json'; Authorization=("Basic {0}" -f $base64AuthInfo); 'Accept'='application/json'}
    Return $objJson
}

# Documentation for REST API Resources
# https://solutionpartner.cisco.com/media/prime-infrastructure/api-reference/szier-m8-106.cisco.com/webacs/api/v1/indexcc3b.html?_docs

# GET API Health Record
$objJson = connectToApi $strToken '/webacs/api/v1/data/ApiHealthRecords'
$objJson.queryResponse

# GET Client Counts
$objJson = connectToApi $strToken '/webacs/api/v1/data/ClientCounts'
$objJson.queryResponse.'@count'

# GET Client Details
$objJson = connectToApi $strToken '/webacs/api/v1/data/ClientDetails'
$objJson.queryResponse

# GET Clients
$objJson = connectToApi $strToken '/webacs/api/v1/data/Clients'
$objJson.queryResponse