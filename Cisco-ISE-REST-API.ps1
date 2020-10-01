#########################################################################################
#                        Written by Heiko Horn 2020-09-30                               #
#########################################################################################
### This script will use the Cisco ISE API and request information from the API Resources

# Create Base64 Authorization header
#$iseUser=''
#$isePass=''
#$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $iseUser,$isePass)))

$base64AuthInfo =''
$iseApi = 'https://ise.xxx.xxx'

# Function to connect to the ISE REST API
function connectToApi ($iseEndpoint) {
    $iseUri = "$($iseApi)$($iseEndpoint)"
    $objIse = Invoke-RestMethod -Uri $iseUri -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo); "Accept"="application/xml"}
    Return $objIse
}

# Documentation for REST API Resources
# https://www.cisco.com/c/en/us/td/docs/security/ise/2-4/api_ref_guide/api_ref_book/ise_api_ref_ch1.html
# https://developer.cisco.com/docs/identity-services-engine/


### Monitoring REST APIs ###

# Lists the number of active sessions.
$objIse = connectToApi '/admin/API/mnt/Session/ActiveCount'
$objIse.sessionCount.count

# Lists the number of Postured endpoints.
$objIse = connectToApi '/admin/API/mnt/Session/PostureCount'
$objIse.sessionCount.count

#Lists the number of active Profiler service sessions.
$objIse = connectToApi '/admin/API/mnt/Session/ProfilerCount'
$objIse.sessionCount.count

# Lists all active sessions.
$objIse = connectToApi '/admin/API/mnt/Session/ActiveList'
$objIse.activeList.noOfActiveSession

# Lists all currently active authenticated sessions.
#starttime/endtime
$strfrom = 'null'
$strTo = 'null'
$objIse = connectToApi "/admin/API/mnt/Session/AuthList/$strfrom/$strto"
$objIse.activeList

#starttime/endtime
$strfrom = 
$strTo = 'null'
$objIse = connectToApi "/admin/API/mnt/Session/AuthList/$strfrom/$strto"
$objIse.activeList.activeSession

#starttime/endtime
$strfrom = ((Get-Date).AddMinutes(-5)).ToString('yyyy-MM-dd HH:mm:ss')
$strTo = (Get-Date).ToString('yyyy-MM-dd HH:mm:ss')
$objIse = connectToApi "/admin/API/mnt/Session/AuthList/$strfrom/$strto"
$objIse.activeList.activeSession

# Searches the database for the latest session that contains the specified MAC address.
$strMac = '30:35:AD:A6:10:D4'
$objIse = connectToApi "/admin/API/mnt/Session/MACAddress/$strMac"
$objIse.sessionParameters

# Searches the database for the latest session that contains the specified username.
$strUser = 'ise.mis-munich.de'
$objIse = connectToApi "/admin/API/mnt/Session/UserName/$strUser"
$objIse.sessionParameters

# Searches the database for the latest session that contains the specified NAS IP address (IPv4 or IPv6 address).
$strIp = '172.16.50.4'
$objIse = connectToApi "/admin/API/mnt/Session/IPAddress/$strIp"
$objIse.sessionParameters

# Searches the database for the latest session that contains the specified audit session ID.
$strId = 'ac10320400029c2c5f74bf25'
$objIse = connectToApi "/admin/API/mnt/Session/Active/SessionID/$strId/0"
$objIse.activeSessionList.activeSession

# Lists the node version and type.
$objIse = connectToApi "/admin/API/mnt/Version"
$objIse.product.version


### External RESTful Services API ###
# ERS is designed to allow external clients to perform CRUD (Create, Read, Update, Delete)
# https://www.cisco.com/c/en/us/td/docs/security/ise/1-3/api_ref_guide/api_ref_book/ise_api_ref_ers2.html
# https://developer.cisco.com/docs/identity-services-engine/#!cisco-ise-api-documentation

# Get advanced customization global setting version info
$objIse = connectToApi ":9060/ers/config/portalglobalsetting/versioninfo"
$objIse.versionInfo

# Get all advanced customization global settings
$objIse = connectToApi ":9060/ers/config/portalglobalsetting"
$objIse.searchResult

# Get all join active directory points
$objIse = connectToApi ":9060/ers/config/activedirectory"
$objIse.searchResult

# Get joined active directory point by name
$strName = ''
$objIse = connectToApi ":9060/ers/config/activedirectory/name/$strName"
$objIse.ersActiveDirectory

# Get all network devices
$objIse = connectToApi ":9060/ers/config/networkdevice"
$objIse.searchResult.resources.resource

# Get all node infromation
$objIse = connectToApi ":9060/ers/config/node"
$objIse.searchResult.resources.resource

# get all portal themes
$objIse = connectToApi ":9060/ers/config/portaltheme"
$objIse.searchResult.resources.resource