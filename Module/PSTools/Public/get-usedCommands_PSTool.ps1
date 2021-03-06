<# 
 .SYNOPSIS 
 Returns array of commands called from the script that are from other modules 

.DESCRIPTION 
 This is a string parser that compares lines of a given script against the list of known modules and commands on the given system. 
It will return an object containing a list of commands it believes were used and also a list of commands that it found but believes are false positives. 
It should be used in conjunction with an out-gridview or other GUI so that a user can verify the findings.
It was designed to be find modules used in a script. 

.PARAMETER filePath 
 string Parameter_filePath=string Parameter_filePath=string Parameter_filePath=string Parameter_filePath=string Parameter_filePath=string Parameter_filePath=string Parameter_filePath=string Parameter_filePath=string Parameter_filePath=string Parameter_filePath=string Parameter_filePath=string Parameter_filePath=string Parameter_filePath=string Parameter_filePath=string Parameter_filePath=string Parameter_filePath=string Parameter_filePath=string Parameter_filePath=string Parameter_filePath=string Parameter_filePath=string Parameter_filePath=string Parameter_filePath=string Parameter_filePath=string Parameter_filePath=string Parameter_filePath=filePath is a mandatory parameter of type string; it should be the path to a powershell script you wish to interrogate 

.EXAMPLE 
 get-PSTool_usedCommands -filepath "C:\test.ps1" returns object containing commands it believes were used and also ones that might have been used 

.EXAMPLE 
 $testcommands = ( get-PSTool_usedCommands -filepath "C:\test.ps1") $SelectedCommands  = $testcommands.GoodCommands | Out-GridView -Title "Select Commands: Suspected Good, Press cancel for none" -PassThru $SelectedCommands += $TestCommands.MehCommands | Out-GridView -Title "Select Commands: Suspected False Positives, Press cancel for none" -PassThru Will give you a variable containing user approved commands 

.NOTES 
 Author: Mentaleak 

#> 
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
