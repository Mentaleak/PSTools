<# 
 .SYNOPSIS 
 Changes the default display to Table instead of list 

.DESCRIPTION 
 Changes the default display to Table instead of list 

.PARAMETER Columns 
 string Parameter_Columns=an array of property names you would like to be displayed by default 

.PARAMETER inputObject 
 string Parameter_inputObject=A pscustom object that you would like to set the defaultdisplayset for 

.EXAMPLE 
 set-Psobject-formatTable_Pstool -inputObject $object -columns 'Port','Name'
 will by default make the object show as a table with columns 'Port','Name' 

.NOTES 
 Author: Mentaleak 
 From reference of LeeHomes Windows Powershell CookBook 3rd Edition 

#> 
function set-Psobject_formatTable_Pstool () {
 
	param(
		[Parameter(mandatory = $true)]$inputObject,
		[Parameter(mandatory = $true)][string[]]$Columns
	)

	if ($inputObject.PSObject.TypeNames[0] -notmatch "System.") {
		$typename = $inputObject.PSObject.TypeNames[0]
		$rowDefinition = New-Object Management.Automation.TableControlRow

		foreach ($column in $Columns) {
			$rowDefinition.Columns.Add(
				(New-Object System.Management.Automation.TableControlColumn "Left",
					(New-Object System.Management.Automation.DisplayEntry $column,"Property")))
		}
		$tableControl = New-Object System.Management.Automation.TableControl
		$tableControl.Rows.Add($rowDefinition)

		$formatViewDefinition = New-Object System.Management.Automation.FormatViewDefinition "TableView",$tableControl
		$extendedTypeDefinition = New-Object System.Management.Automation.ExtendedTypeDefinition $TypeName
		$extendedTypeDefinition.FormatViewDefinition.Add($formatViewDefinition)

		[runspace]::DefaultRunspace.InitialSessionState.Formats.Add($extendedTypeDefinition)
		Update-FormatData
	}
	else {
		throw [System.Exception]"This object does not have a valid custom type in position 0"
	}
}
