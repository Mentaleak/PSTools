function Get-PSTool_functions () {
 <# 
 .PARAMETER filePath 
 string Parameter_filePath=filePath is a mandatory parameter of type string 

#>    

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
