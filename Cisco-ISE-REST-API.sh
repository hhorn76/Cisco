#!/bin/bash

#########################################################################################
#                       Written by Heiko Horn 2020.10.01                                #
#########################################################################################
### This script will use the Cisco ISE API and request information from the API Resources

### Cisco ISE REST API Service Credentials ###
# decode base64 API token - use strEncrypted=$(echo <username>:<password> | base64) to encrypt the token
ENCRYPTED=''
URL='https://ise.xxx.xxx'

# Function to connect to Cisco ISE REST API 
function connectToApi {
	URI="${2}${3}"
	XML=$(/usr/bin/curl -sk -H "authorization: Basic ${1}" -H 'Accept: application/xml' "${URI}")
}

# Documentation for REST API Resources
# https://www.cisco.com/c/en/us/td/docs/security/ise/2-4/api_ref_guide/api_ref_book/ise_api_ref_ch1.html
# https://developer.cisco.com/docs/identity-services-engine/

# Function to lists the number of active sessions.
function activeCount {
	RECOURCE='/admin/API/mnt/Session/ActiveCount'
	connectToApi ${ENCRYPTED} ${URL} ${RECOURCE}
	echo ${XML} | xmllint -xpath "/sessionCount/count" - | sed -e 's/<[^>]*>//g'
}

# Function to lists all active sessions user names.
function activeList {
	RECOURCE='/admin/API/mnt/Session/ActiveList'
	connectToApi ${ENCRYPTED} ${URL} ${RECOURCE}
	ARR_USERS=$(echo ${XML} | xmllint -xpath "/activeList/activeSession/user_name" - | sed -e 's/<[^>]*>/ /g')
	for USER in ${ARR_USERS[@]}; do
		echo ${USER}
	done
}

# Function to searches the database for the latest session that contains the specified NAS IP address (IPv4 or IPv6 address).
function sesssionByIP {
	RECOURCE="/admin/API/mnt/Session/IPAddress/${1}"
	connectToApi ${ENCRYPTED} ${URL} ${RECOURCE}	
	echo ${XML} #| xmllint -xpath "/sessionParameters" - | sed -e 's/<[^>]*>//g'
}

# ERS is designed to allow external clients to perform CRUD (Create, Read, Update, Delete)
# https://www.cisco.com/c/en/us/td/docs/security/ise/1-3/api_ref_guide/api_ref_book/ise_api_ref_ers2.html
# https://developer.cisco.com/docs/identity-services-engine/#!cisco-ise-api-documentation

# Function to get advanced customization global setting version info
function globalVersionInfo {
	RECOURCE=":9060/ers/config/portalglobalsetting/versioninfo"
	connectToApi ${ENCRYPTED} ${URL} ${RECOURCE}
	echo ${XML} | sed -e 's/<[^>]*>//g'
}

# Function to get all advanced customization global settings
function globalSettings {
	RECOURCE=":9060/ers/config/portalglobalsetting"
	connectToApi ${ENCRYPTED} ${URL} ${RECOURCE}
	echo ${XML}
}

### This is where the magi happens ###
# To execute the functions remove the hash tag.
#activeCount
#activeList
#sesssionByIP 'XXX.XXX.XXX.XXX' #IP Address from the node
#globalVersionInfo
#globalSettings