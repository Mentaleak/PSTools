param([switch]$NoVersionCheck)

#Is module loaded; if not load
if ((Get-Module PSTools)){return}
    $psv = $PSVersionTable.PSVersion

    #verify PS Version
    if ($psv.Major -lt 5 -and !$NoVersionWarn) {
        Write-Warning ("PSTools is listed as requiring 5; you have version $($psv).`n" +
        "Visit Microsoft to download the latest Windows Management Framework `n" +
        "To suppress this warning, change your include to 'Import-Module PSTools -NoVersionCheck `$true'.")
        return
    }
. $PSScriptRoot\public\compare-object_pstool.ps1
. $PSScriptRoot\public\convertto-clixml_PSTool.ps1
. $PSScriptRoot\public\get-ADGroupMembership_PsTool.ps1
. $PSScriptRoot\public\Get-functions_PSTool.ps1
. $PSScriptRoot\public\get-timestamp_PSTool.ps1
. $PSScriptRoot\public\get-usedCommands_PSTool.ps1
. $PSScriptRoot\public\remove-object_Pstool.ps1
. $PSScriptRoot\public\set-Psobject_defaultdisplayset_PSTool.ps1
. $PSScriptRoot\public\set-Psobject_formatTable_Pstool.ps1
. $PSScriptRoot\public\set-WebSecurity_PSTool.ps1
. $PSScriptRoot\public\Test-ADCredential_PsTool.ps1
. $PSScriptRoot\public\test-ADGroupMembership_PsTool.ps1
Export-ModuleMember compare-object_pstool
Export-ModuleMember convertto-clixml_PSTool
Export-ModuleMember get-ADGroupMembership_PsTool
Export-ModuleMember Get-functions_PSTool
Export-ModuleMember get-timestamp_PSTool
Export-ModuleMember get-usedCommands_PSTool
Export-ModuleMember remove-object_Pstool
Export-ModuleMember set-Psobject_defaultdisplayset_PSTool
Export-ModuleMember set-Psobject_formatTable_Pstool
Export-ModuleMember set-WebSecurity_PSTool
Export-ModuleMember Test-ADCredential_PsTool
Export-ModuleMember test-ADGroupMembership_PsTool
