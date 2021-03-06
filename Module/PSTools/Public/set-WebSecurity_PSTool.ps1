<# 
 .SYNOPSIS 
 Set security protocol to Tls12 

.DESCRIPTION 
 Sometimes needed to be able to attach to a web API, changes the security to Tls12 

.EXAMPLE 
 set-PSTool_WebSecurity Sets SecurityProtocol to Tls12 

.NOTES 
 Author: Mentaleak 

#> 
function set-WebSecurity_PSTool () {
 
	[Alias("set-PSTool_WebSecurity")]
	param()
	[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
}
