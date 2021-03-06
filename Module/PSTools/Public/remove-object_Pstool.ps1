<# 
 .SYNOPSIS 
 Purges and removes all data from a given object 

.DESCRIPTION 
 Purges and removes all data from a given object, Invokes Garbage cleanup,
 Meant to be in a dispose() method of the object 

.PARAMETER inputObject 
 string Parameter_inputObject=inputObject is a mandatory parameter of type pscustomobject that you would like to dispose of 

.NOTES 
 Author: Mentaleak 
 From reference of LeeHomes Windows Powershell CookBook 3rd Edition 

#> 
function remove-object_Pstool () {
 
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
