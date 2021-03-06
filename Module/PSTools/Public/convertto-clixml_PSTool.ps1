<# 
 .SYNOPSIS 
 Returns a string of the CLixml view of an object 

.DESCRIPTION 
 exports a clixml to tmp file, reads the clixml, deletes the temp file 

.PARAMETER InputObject 
 string Parameter_InputObject=string Parameter_InputObject=string Parameter_InputObject=string Parameter_InputObject=string Parameter_InputObject=string Parameter_InputObject=string Parameter_InputObject=string Parameter_InputObject=string Parameter_InputObject=string Parameter_InputObject=string Parameter_InputObject=string Parameter_InputObject=string Parameter_InputObject=string Parameter_InputObject=string Parameter_InputObject=string Parameter_InputObject=string Parameter_InputObject=string Parameter_InputObject=string Parameter_InputObject=InputObject is a mandatory parameter of type System.Object, Object to get clixml for 

.EXAMPLE 
 convertto-clixml_PSTool -InputObject $object returns string containing an xml view of $object 

.NOTES 
 Author: Mentaleak 

#> 
function convertto-clixml_PSTool () {
 
	param(
		[Parameter(mandatory = $true)] $InputObject
	)
	$tmpfilepath = "$($env:APPDATA)\tmp_$(get-timestamp_PSTool).xml"
	$InputObject | Export-Clixml -Path $tmpfilepath
	$xmlcontent = Import-Clixml -Path $tmpfilepath
	Remove-Item -Path $tmpfilepath -Force
	return $xmlcontent
}
