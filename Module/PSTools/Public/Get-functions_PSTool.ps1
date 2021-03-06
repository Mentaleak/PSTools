<# 
 .SYNOPSIS 
 Returns an array of functions contained within a script 

.DESCRIPTION 
 This function imports a script and gathers the functions defined within it for return as an array. 

.PARAMETER filePath 
 string Parameter_filePath=string Parameter_filePath=string Parameter_filePath=string Parameter_filePath=string Parameter_filePath=string Parameter_filePath=string Parameter_filePath=string Parameter_filePath=string Parameter_filePath=string Parameter_filePath=string Parameter_filePath=string Parameter_filePath=string Parameter_filePath=string Parameter_filePath=string Parameter_filePath=string Parameter_filePath=string Parameter_filePath=string Parameter_filePath=string Parameter_filePath=string Parameter_filePath=string Parameter_filePath=string Parameter_filePath=string Parameter_filePath=string Parameter_filePath=string Parameter_filePath=filePath is a mandatory parameter of type string; it should be the path to a powershell script you wish to interrogate 

.EXAMPLE 
 Get-PSTool_functions -filepath "C:\test.ps1" Will return an array of functions contained within the script 

.NOTES 
 Author: Mentaleak 

#> 
function Get-functions_PSTool () {
 
	[Alias("Get-PSTool_functions")]
	param(
		[Parameter(mandatory = $true)] [string]$filePath
	)

	$file = Get-ChildItem $filePath
	$oldarray = Get-ChildItem function:\
	$acceptableExtensions = @(".dll",".ps1",".psm1")

	if ($acceptableExtensions.Contains($file[0].Extension)) {
		Import-Module $($file.FullName)
		$newarray = Get-ChildItem function:\
		$functions = ($newarray | Where-Object { $oldarray -notcontains $_ })
		Remove-Module $($file.BaseName)
		return $functions
	}

	else {
		Write-Host "$($file.FullName) is not a Powershell File"
		return @()

	}


}
