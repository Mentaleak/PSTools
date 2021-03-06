<# 
 .SYNOPSIS 
 Gets group membership for given identity 

.DESCRIPTION 
 recursively gets group membership for given identity 

.PARAMETER identity 
 string Parameter_identity=identity is a mandatory parameter of type String. Samaccountname 

.NOTES 
 Author: Mentaleak 

#> 
function get-ADGroupMembership_PsTool () {
 
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
