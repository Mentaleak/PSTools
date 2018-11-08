function set-PSTool_WebSecurity () {
	[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
}

function Get-PSTool_functions () {
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


function get-PSTool_usedCommands(){
    param(
		    [Parameter(mandatory = $true)] [string]$filePath
	    )
    $file=get-item -Path $filePath
    $fileData = get-content $filePath
    $commandList= Get-Command | where{$_.Name -notmatch ":" -and $_.Source -notlike "Microsoft.Powershell.*" -and $_.Source -ne ""}
    $mehCommandList = get-command | where {$_.Name -notmatch "-"}
    $FoundCommands=@()
    $mehFoundCommands=@()
    $activeline=0
    foreach($line in $fileData)
    {
    $activeline++
    Write-Progress -Status "Reading $($file.name)" -activity "Line $activeline" -PercentComplete (100*($activeline/$fileData.count))
        #write-host $line
        $upline=$line.ToUpper()
        #write-host $upline
        foreach($command in $commandList){
            $commandName="$($command.name.ToUpper())"
            #write-host $upline
            if($upline -match [regex]::Escape($commandName))
            {
                
                if(("$($upline)"[(("$($upline)".IndexOf("$commandName"))+"$commandName".Length)] -notmatch '^[a-zA-Z0-9]+$') -and ("$($upline)"[("$($upline)".IndexOf("$commandName"))-1] -notmatch '^[a-zA-Z0-9]+$'))
                {
                if ($mehCommandList| where{$_.name -eq $command.name} ){
                write-host "$($command.Name): $line" -ForegroundColor "White"

                    if($mehFoundCommands | where{$_.CommandName -eq "$($command.Name)"})
                    {
                      ($mehFoundCommands | where{$_.CommandName -eq "$($command.Name)"}).lines+="`n$($line.trim())"
                    }
                    else{
                        $CommandObject = [PSCustomObject]@{
                        CommandName= $command.Name
                        Module = $command.source 
                        Version = $command.version
                        Lines = "$($line.trim())"
                        }
                        $mehFoundCommands+=$CommandObject
                    }
                
                }else{
                write-host "$($command.Name): $line" -ForegroundColor "Green"
                 if($FoundCommands | where{$_.CommandName -eq "$($command.Name)"})
                    {
                      ($FoundCommands | where{$_.CommandName -eq "$($command.Name)"}).lines+="`n$($line.trim())"
                    }
                    else{
                        $CommandObject = [PSCustomObject]@{
                        CommandName= $command.Name
                        Module = $command.source 
                        Version = $command.version
                        Lines = "$($line.trim())"
                        }
                        $FoundCommands+=$CommandObject
                    }
                }

                }
               
            }
        }
    }
    Write-Progress -Activity "Complete" -Completed
    return [PSCustomObject]@{
                        GoodCommands = $FoundCommands
                        MehCommands = $mehFoundCommands
                        }

}
