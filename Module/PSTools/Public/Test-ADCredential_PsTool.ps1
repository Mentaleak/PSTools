<# 
 .SYNOPSIS 
 AD login with powershell 

.DESCRIPTION 
 Checks the pscred against AD to see if username and password valid pair 

.PARAMETER Cred 
 string Parameter_Cred=Cred is a mandatory parameter of type PScredential 

.NOTES 
 Author: mentaleak 

#> 
function Test-ADCredential_PsTool () {
 
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
