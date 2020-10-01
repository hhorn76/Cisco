#!/usr/bin/python

#########################################################################################
#                       Written by Heiko Horn 2020.10.01                                #
#########################################################################################
### This script will use the Cisco ISE API and request information from the API Resources
### Documentation for REST API Resources
### https://www.cisco.com/c/en/us/td/docs/security/ise/2-4/api_ref_guide/api_ref_book/ise_api_ref_ch1.html
### https://developer.cisco.com/docs/identity-services-engine/

import urllib2 
import base64
import xml.etree.ElementTree as xml

################################################################################
## Function to encrypt password
def encryptPw (strPassword):
	return base64.b64encode(strPassword)

# Function connect to the api using urllib2 module
def connectToApilib2 (strResource):
	strAPI = strURL + strResource
	request = urllib2.Request(strAPI)
	request.add_header('Authorization', 'Basic ' + strEncrypted)
	request.add_header('Accept', 'application/xml')
	strXml = urllib2.urlopen(request).read()
	root = xml.fromstring(strXml)
	return root

# Create Base64 Authorization header
strEncrypted = encryptPw ('<username>:<password>')
print ('Base64 encrypted password: ' + strEncrypted)

# Set varibales for the connetion and request info from the API
strURL = 'https://xxx.xxx.xxx'
strResource = '/admin/API/mnt/Session/ActiveCount'
xmlRoot = connectToApilib2 (strResource)
for child in xmlRoot:
	print(child.tag, child.text)