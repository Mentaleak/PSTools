<# 
 .SYNOPSIS 
 Compares two objects and returns a clean view of the compared fields 

.DESCRIPTION 
 Compares two objects and returns a clean view of the compared fields, can do so recursively but depending on child objects it can be difficult to read 

.PARAMETER AObject 
 string Parameter_AObject=string Parameter_AObject=string Parameter_AObject=string Parameter_AObject=string Parameter_AObject=string Parameter_AObject=string Parameter_AObject=string Parameter_AObject=string Parameter_AObject=string Parameter_AObject=string Parameter_AObject=string Parameter_AObject=string Parameter_AObject=string Parameter_AObject=string Parameter_AObject=string Parameter_AObject=string Parameter_AObject=string Parameter_AObject=string Parameter_AObject=AObject is a mandatory parameter of type System.Object, first object to check 

.PARAMETER appendparent 
 string Parameter_appendparent=string Parameter_appendparent=string Parameter_appendparent=string Parameter_appendparent=string Parameter_appendparent=string Parameter_appendparent=string Parameter_appendparent=string Parameter_appendparent=string Parameter_appendparent=string Parameter_appendparent=string Parameter_appendparent=string Parameter_appendparent=string Parameter_appendparent=string Parameter_appendparent=string Parameter_appendparent=string Parameter_appendparent=string Parameter_appendparent=string Parameter_appendparent=string Parameter_appendparent=appendparent is a parameter of type string, used internally during recursive 

.PARAMETER BObject 
 string Parameter_BObject=string Parameter_BObject=string Parameter_BObject=string Parameter_BObject=string Parameter_BObject=string Parameter_BObject=string Parameter_BObject=string Parameter_BObject=string Parameter_BObject=string Parameter_BObject=string Parameter_BObject=string Parameter_BObject=string Parameter_BObject=string Parameter_BObject=string Parameter_BObject=string Parameter_BObject=string Parameter_BObject=string Parameter_BObject=string Parameter_BObject=BObject is a mandatory parameter of type System.Object, second object to check 

.PARAMETER includeEqual 
 string Parameter_includeEqual=string Parameter_includeEqual=string Parameter_includeEqual=string Parameter_includeEqual=string Parameter_includeEqual=string Parameter_includeEqual=string Parameter_includeEqual=string Parameter_includeEqual=string Parameter_includeEqual=string Parameter_includeEqual=string Parameter_includeEqual=string Parameter_includeEqual=string Parameter_includeEqual=string Parameter_includeEqual=string Parameter_includeEqual=string Parameter_includeEqual=string Parameter_includeEqual=string Parameter_includeEqual=string Parameter_includeEqual=includeEqual is a parameter of type switch, will also show values that are equal 

.PARAMETER recursion 
 string Parameter_recursion=string Parameter_recursion=string Parameter_recursion=string Parameter_recursion=string Parameter_recursion=string Parameter_recursion=string Parameter_recursion=string Parameter_recursion=string Parameter_recursion=string Parameter_recursion=string Parameter_recursion=string Parameter_recursion=string Parameter_recursion=string Parameter_recursion=string Parameter_recursion=string Parameter_recursion=string Parameter_recursion=string Parameter_recursion=string Parameter_recursion=recursion is a parameter of type bool, will look at subobjects aswell 

.EXAMPLE 
 compare-object_pstool -AObject $AObject -BObject $BObject returns an array of comparison objects ofr each parameter 

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
