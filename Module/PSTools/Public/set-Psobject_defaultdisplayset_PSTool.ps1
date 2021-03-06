<# 
 .SYNOPSIS 
 Changes the default displayset of the input object 

.DESCRIPTION 
 Changes the default displayset of the input object 

.PARAMETER DefaultDisplaySet 
 string Parameter_DefaultDisplaySet=an array of property names you would like to be displayed by default 

.PARAMETER InputObject 
 string Parameter_InputObject=A pscustom object that you would like to set the defaultdisplayset for 

.EXAMPLE 
 set-Psobject-defaultdisplayset_PSTool -inputObject $object -defaultDisplaySet 'Port','Name'
 will by default make the object only show 'Port' and 'Name' 

.NOTES 
 Author: Mentaleak 

#> 
function set-Psobject_defaultdisplayset_PSTool () {
 
	param(
		[Parameter(mandatory = $true)] $InputObject,
		[Parameter(mandatory = $true)] $DefaultDisplaySet
	)
	#$defaultDisplaySet = 'Port','Name','Status','Vlan','Duplex','Speed','Type'

	$defaultDisplayPropertySet = New-Object System.Management.Automation.PSPropertySet (‘DefaultDisplayPropertySet’,[string[]]$defaultDisplaySet)
	$PSStandardMembers = [System.Management.Automation.PSMemberInfo[]]@($defaultDisplayPropertySet)
	$InputObject | Add-Member MemberSet PSStandardMembers $PSStandardMembers

}
