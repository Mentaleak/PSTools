#
# Module manifest for module 'PSTools'
#
# Generated by: https://github.com/Mentaleak/PSModuleCreator






#
# Generated on: 11/29/2018
#

@{

# Script module or binary module file associated with this manifest.
RootModule = 'PSTools.psm1'

# Version number of this module.
ModuleVersion = '201811.29.1404.26'

# Supported PSEditions
# CompatiblePSEditions = @()

# ID used to uniquely identify this module
GUID = '6acf01e5-3a34-4ff8-8527-3555842aa435'

# Author of this module
Author = '
AuthorType Author    Changes Adds Deletes Commits
---------- ------    ------- ---- ------- -------
Owner      Mentaleak     251  177      74      60


'

# Company or vendor of this module
CompanyName = 'Mentaleak'

# Copyright statement for this module
Copyright = '(c) 2018 Mentaleak. All rights reserved.'

# Description of the functionality provided by this module
Description = 'Various Powershell Functions For use in other Utilities'

# Minimum version of the Windows PowerShell engine required by this module
PowerShellVersion = '5.1'

# Name of the Windows PowerShell host required by this module
# PowerShellHostName = ''

# Minimum version of the Windows PowerShell host required by this module
# PowerShellHostVersion = ''

# Minimum version of Microsoft .NET Framework required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
# DotNetFrameworkVersion = ''

# Minimum version of the common language runtime (CLR) required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
# CLRVersion = ''

# Processor architecture (None, X86, Amd64) required by this module
# ProcessorArchitecture = ''

# Modules that must be imported into the global environment prior to importing this module
# RequiredModules = @()

# Assemblies that must be loaded prior to importing this module
# RequiredAssemblies = @()

# Script files (.ps1) that are run in the caller's environment prior to importing this module.
# ScriptsToProcess = @()

# Type files (.ps1xml) to be loaded when importing this module
# TypesToProcess = @()

# Format files (.ps1xml) to be loaded when importing this module
# FormatsToProcess = @()

# Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
# NestedModules = @()

# Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
FunctionsToExport = 'compare-object_pstool', 'convertto-clixml_PSTool', 
               'Get-functions_PSTool', 'get-timestamp_PSTool', 
               'get-usedCommands_PSTool', 'set-WebSecurity_PSTool'

# Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
CmdletsToExport = '*'

# Variables to export from this module
VariablesToExport = '*'

# Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
AliasesToExport = '*'

# DSC resources to export from this module
# DscResourcesToExport = @()

# List of all modules packaged with this module
# ModuleList = @()

# List of all files packaged with this module
FileList = 'PSTools.psd1', 'PSTools.psm1', 'compare-object_pstool.ps1', 
               'convertto-clixml_PSTool.ps1', 'Get-functions_PSTool.ps1', 
               'get-timestamp_PSTool.ps1', 'get-usedCommands_PSTool.ps1', 
               'set-WebSecurity_PSTool.ps1'

# Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
PrivateData = @{

    PSData = @{

        # Tags applied to this module. These help with module discovery in online galleries.
        # Tags = @()

        # A URL to the license for this module.
        # LicenseUri = ''

        # A URL to the main website for this project.
        # ProjectUri = ''

        # A URL to an icon representing this module.
        # IconUri = ''

        # ReleaseNotes of this module
        # ReleaseNotes = ''

    } # End of PSData hashtable

} # End of PrivateData hashtable

# HelpInfo URI of this module
HelpInfoURI = 'https://github.com/Mentaleak/PSTools'

# Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
# DefaultCommandPrefix = ''

}

