<# 
 .SYNOPSIS 
 Checks to see if Identity is a member of groups in array 

.DESCRIPTION 
 returns array of groups identity is in form the array provided 

.PARAMETER groups 
 string Parameter_groups=groups is a mandatory parameter of type string[], list of ad groups 

.PARAMETER identity 
 string Parameter_identity=identity is a mandatory parameter of type String . Samaccountname 

.NOTES 
 Author: Mentaleak 

#> 
function test-ADGroupMembership_PsTool () {
 
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
