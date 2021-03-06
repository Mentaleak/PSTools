function set-WebSecurity_PSTool () {
	[Alias("set-PSTool_WebSecurity")]
	param()
	[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
}

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


function get-usedCommands_PSTool () {
	[Alias("get-PSTool_usedCommands")]
	param(
		[Parameter(mandatory = $true)] [string]$filePath
	)
	$file = Get-Item -Path $filePath
	$fileData = Get-Content $filePath
	Write-Progress -Status "Getting commands" -Activity "This will take a while" -PercentComplete (50)
	$commandList = Get-Command | Where-Object { $_.Name -notmatch ":" -and $_.Source -notlike "Microsoft.Powershell.*" -and $_.Source -ne "" }
	$mehCommandList = Get-Command | Where-Object { $_.Name -notmatch "-" }
	$FoundCommands = @()
	$mehFoundCommands = @()
	$activeline = 0
	foreach ($line in $fileData)
	{
		$activeline++
		Write-Progress -Status "Reading $($file.name)" -Activity "Line $activeline / $($fileData.count)" -PercentComplete (100 * ($activeline / $fileData.count))
		#write-host $line
		$upline = $line.ToUpper()
		#write-host $upline
		foreach ($command in $commandList) {
			$commandName = "$($command.name.ToUpper())"
			#write-host $upline
			if ($upline -match [regex]::Escape($commandName))
			{

				if (("$($upline)"[(("$($upline)".IndexOf("$commandName")) + "$commandName".Length)] -notmatch '^[a-zA-Z0-9]+$') -and ("$($upline)"[("$($upline)".IndexOf("$commandName")) - 1] -notmatch '^[a-zA-Z0-9]+$'))
				{
					if ($mehCommandList | Where-Object { $_.Name -eq $command.Name }) {
						#write-host "$($command.Name): $line" -ForegroundColor "White"

						if ($mehFoundCommands | Where-Object { $_.CommandName -eq "$($command.Name)" })
						{
							($mehFoundCommands | Where-Object { $_.CommandName -eq "$($command.Name)" }).lines += "`n$($line.trim())"
						}
						else {
							$CommandObject = [pscustomobject]@{
								CommandName = $command.Name
								Module = $command.Source
								Version = $command.Version
								lines = "$($line.trim())"
							}
							$mehFoundCommands += $CommandObject
						}

					} else {
						#write-host "$($command.Name): $line" -ForegroundColor "Green"
						if ($FoundCommands | Where-Object { $_.CommandName -eq "$($command.Name)" })
						{
							($FoundCommands | Where-Object { $_.CommandName -eq "$($command.Name)" }).lines += "`n$($line.trim())"
						}
						else {
							$CommandObject = [pscustomobject]@{
								CommandName = $command.Name
								Module = $command.Source
								Version = $command.Version
								lines = "$($line.trim())"
							}
							$FoundCommands += $CommandObject
						}
					}

				}

			}
		}
	}
	Write-Progress -Activity "Complete" -Completed
	return [pscustomobject]@{
		GoodCommands = $FoundCommands
		MehCommands = $mehFoundCommands
	}

}


<# 
 .SYNOPSIS 
Compares two objects and returns a clean view of the compared fields

.DESCRIPTION 
Compares two objects and returns a clean view of the compared fields, can do so recursively but depending on child objects it can be difficult to read

.EXAMPLE 
 compare-object_pstool -AObject $AObject -BObject $BObject
 returns an array of comparison objects ofr each parameter

.NOTES 
 Author: Mentaleak 

#>
function compare-object_pstool () {
	param(
		[Parameter(mandatory = $true)] $AObject,
		[Parameter(mandatory = $true)] $BObject,
		[string]$appendparent = $null,
		[bool]$recursion,
		[switch]$includeEqual
	)
	$nonobject = $false
	Write-Verbose "Getting Property list for AObject_$($appendparent)"
	try { $AProperties = $Aobject | Get-Member -MemberType Property }
	catch { $nonobject = $true
		Write-Verbose "$Aobject is not a valid Object" }
	Write-Verbose "Getting Property list for BObject_$($appendparent)"
	try { $BProperties = $Bobject | Get-Member -MemberType Property -ErrorAction SilentlyContinue }
	catch { $nonobject = $true
		Write-Verbose "$Bobject is not a valid Object" }
	$Comparison = @()

	Write-Verbose "Compare if both are valid $nonobject"
	if (!($nonobject)) {
		if ((Compare-Object $AProperties $BProperties) -eq $null) {
			Write-Verbose "Property list for AObject_$($appendparent) and BObject_$($appendparent) are the same"
			foreach ($prop in $AProperties)
			{
				Write-Verbose "$($prop.name) : $($Aobject."$($prop.name)") - $($Bobject."$($prop.name)")"
				#prim datatypes
				if ((($Aobject."$($prop.name)".GetType()).IsPrimitive) -or ($Aobject."$($prop.name)".GetType().Name) -eq "string") {
					Write-Verbose "Inspecting Primitive Property: $($prop.name)"
					if ($Aobject."$($prop.name)" -ne $Bobject."$($prop.name)") { $diffState = "!=" } else { $diffState = "==" }
					$cleanerCompareObject = New-Object -TypeName PSObject
					if ($appendparent) {
						Add-Member -InputObject $cleanerCompareObject -MemberType NoteProperty -Name "Property" -Value "$($appendparent)_$($prop.name)"
					} else
					{
						Add-Member -InputObject $cleanerCompareObject -MemberType NoteProperty -Name "Property" -Value "$($prop.name)"
					}
					Add-Member -InputObject $cleanerCompareObject -MemberType NoteProperty -Name "A_Object_value" -Value "$($AObject."$($prop.name)")"
					Add-Member -InputObject $cleanerCompareObject -MemberType NoteProperty -Name "B_Object_value" -Value "$($BObject."$($prop.name)")"
					Add-Member -InputObject $cleanerCompareObject -MemberType NoteProperty -Name "Diff" -Value "$diffState"
					$Comparison += $cleanerCompareObject
				}
				#need to figure out how to detect object loops
				elseif ($recursion -and $($prop.Name) -notmatch "parent" -and $($prop.Name) -notmatch "tag" -and $($prop.Name) -notmatch "assembly" -and $($prop.Name) -notmatch "basetype" -and $($prop.Name) -notmatch "declaringtype") {
					Write-Verbose "Inspecting Object Property: $($prop.name)"
					if ($appendparent) { $appendparent = "$($appendparent)_" }
					if ((($appendparent.ToCharArray()) | Where-Object { $_ -eq '_' } | Measure-Object).count -lt 15)
					{ $Comparison += compare-object_pstool-Format -AObject $Aobject."$($prop.name)" -BObject $Bobject."$($prop.name)" -appendparent "$($appendparent)$($prop.name)" -recursion $recursion -IncludeEqual }
					else {
						Write-Verbose "Loop Detected $appendparent"
					}

				}
				$Global:cmpr = $Comparison
			}

		}
		else {
			#enhancement handle disimilar objects
			Write-Error "Objects are disimilar"
		}
	}

	#Write-Verbose ($Comparison | Format-Table -AutoSize | Out-String)

	if ($includeEqual) { return $Comparison }
	else { return $Comparison | Where-Object { $_.Diff -ne "==" } }
}

<# 
 .SYNOPSIS 
 Returns a string of the CLixml view of an object

.DESCRIPTION 
exports a clixml to tmp file, reads the clixml, deletes the temp file

.EXAMPLE 
 convertto-clixml_PSTool -InputObject $object
 returns string containing an xml view of $object

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

<# 
 .SYNOPSIS 
 returns a timestamp in format yyyy-MM-DD_HH-mm-ss EG: 2018-11-29_10-41-17

.DESCRIPTION 
 returns a timestamp in format yyyy-MM-DD_HH-mm-ss EG: 2018-11-29_10-41-17

.EXAMPLE 
 get-PSTool_timestamp
 returns a timestamp in format yyyy-MM-DD_HH-mm-ss EG: 2018-11-29_10-41-17

.NOTES 
 Author: Mentaleak 

#>
function get-timestamp_PSTool () {
	$date = (Get-Date)

	return "$($date.year.toString("0000"))-$($date.Month.toString("00"))-$($date.Day.toString("00"))_$($date.Hour.toString("00"))-$($date.Minute.toString("00"))-$($date.Second.toString("00"))"
}

<# 
.SYNOPSIS 
 Changes the default displayset of the input object

.DESCRIPTION 
 Changes the default displayset of the input object

.PARAMETER InputObject
A pscustom object that you would like to set the defaultdisplayset for

.PARAMETER DefaultDisplaySet
an array of property names you would like to be displayed by default

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

<# 
.SYNOPSIS 
 Changes the default display to Table instead of list

.DESCRIPTION 
 Changes the default display to Table instead of list

.PARAMETER InputObject
A pscustom object that you would like to set the defaultdisplayset for

.PARAMETER columns
an array of property names you would like to be displayed by default

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

<# 
.SYNOPSIS 
 Purges and removes all data from a given object

.DESCRIPTION 
 Purges and removes all data from a given object, Invokes Garbage cleanup,
 Meant to be in a dispose() method of the object

.PARAMETER InputObject
A pscustom object that you would like to dispose of

.NOTES 
 Author: Mentaleak


#>
function remove-object_Pstool(){
    param(
    [Parameter(mandatory = $true)]$inputObject
    )
        [System.GC]::SuppressFinalize($inputObject)
        foreach($objMember in $inputObject.psobject.Members.Where({$_."MemberType" -eq "ScriptMethod" -or $_."MemberType" -eq "NoteProperty" })){
            $inputObject.psobject.Members.remove($objMember.name)
        }
        if($this.myCOMObject){[System.Runtime.InteropServices.Marshal]::ReleaseComObject($this.myCOMObject)}
        [System.GC]::SuppressFinalize($inputObject)
        $inputObject = New-Object PSObject 
        [System.GC]::SuppressFinalize($inputObject)
}

function Test-ADCredential_PsTool(){
Param (
            [Parameter(Mandatory = $true)] $Cred
      )
            $Domain = $Cred.GetNetworkCredential().Domain
            [System.Reflection.Assembly]::LoadWithPartialName("System.DirectoryServices.AccountManagement") | Out-Null
            $Context = New-Object System.DirectoryServices.AccountManagement.PrincipalContext([System.DirectoryServices.AccountManagement.ContextType]::Domain, $Domain)
            $ADCred = $Cred.GetNetworkCredential()
            $validcred = $Context.ValidateCredentials($ADCred.UserName, $ADCred.Password)
            $Context.dispose()
            return $validcred
            
}


function get-ADGroupMembership_PsTool() {
Param (
            [Parameter(Mandatory = $true)] $identity
      )
      $groupmembers=@()
      $principalGroups= (Get-ADPrincipalGroupMembership -Identity $identity).samaccountname
      foreach( $group in $principalGroups)
      {
      $groupmembers += $group
      $groupmembers += get-ADGroupMembership_PsTool $group
      }
      return $groupmembers

}

function test-ADGroupMembership_PsTool() {
Param (
            [Parameter(Mandatory = $true)] $identity,
            [Parameter(Mandatory = $true)] [string[]]$groups
      )
      $MemberOfGroups=@()
    foreach($group in $groups){
    $members = Get-ADGroupMember -Identity $group -Recursive | Select -ExpandProperty samaccountname
        If ($members -contains $identity) {
             $MemberOfGroups+=$group
        }
    }
    return [string[]]$MemberOfGroups

}

