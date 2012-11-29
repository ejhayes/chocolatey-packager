# PowerShell -NoProfile -ExecutionPolicy unrestricted -Command "[System.Threading.Thread]::CurrentThread.CurrentCulture = ''; [System.Threading.Thread]::CurrentThread.CurrentUICulture = '';& './packager.ps1' build atlas_changescripts -version '1.0.0' -sourceRepository 'git@git.psm.local:lightning.git' -packagingRepository 'git@git.psm.local:choc-storm-changescripts.git' -buildArgs @{'database' = 'ATLAS'}"
# Preprocessor Script for this package
# Things that you would classify as needing "preprocessing"
# - Tokenizing: e.g. __DATABASE__ or __VERSION__ gets replaced by actual values
# - Ensuring certain paths are available via HTTP
# - Anything else you would do manually to this package BEFORE running the cpack command

# Preprocessor Script for this package
# Things that you would classify as needing "preprocessing"
# - Tokenizing: e.g. __DATABASE__ or __VERSION__ gets replaced by actual values
# - Ensuring certain paths are available via HTTP
# - Anything else you would do manually to this package BEFORE running the cpack command
# PowerShell -NoProfile -ExecutionPolicy unrestricted -Command "[System.Threading.Thread]::CurrentThread.CurrentCulture = ''; [System.Threading.Thread]::CurrentThread.CurrentUICulture = '';& './packager.ps1' build atlas_changescripts -version '1.0.0' -sourceRepository 'git@git.psm.local:lightning.git' -packagingRepository 'git@git.psm.local:choc-storm-changescripts.git' -buildArgs @{'database' = 'ATLAS'}"
# PowerShell -NoProfile -ExecutionPolicy unrestricted -Command "[System.Threading.Thread]::CurrentThread.CurrentCulture = ''; [System.Threading.Thread]::CurrentThread.CurrentUICulture = '';& './packager.ps1' build atlas_changescripts -version '1.0.0' -sourceRepository 'http://svn/svn/storm/trunk' -packagingRepository 'git@git.psm.local:choc-storm-changescripts.git' -buildArgs @{'database' = 'ATLAS'}"

# BELOW IS AN EXAMPLE SCRIPT
#param(
#    [Parameter(Mandatory=$true)][string]$database
#)

#$baseDir = (Split-Path -parent $MyInvocation.MyCommand.Definition)

#Write-Token "__DATABASE__" $database
#Publish-File "test.zip"
#Add-FromSourceRepository "puppet/manifests" "content/bob.zip"
#Add-FromSourceRepository @("puppet/manifests", "utils") "content/bob"
#Add-FromSourceRepository @("puppet/manifests", "utils") "content/bob.zip"
#Add-FromSourceRepository "puppet/manifests" "content/bob.zip"
#Add-FromSourceRepository @{"puppet/manifests" = ""; "utils" = ""} "content/bob.zip"
#Add-FromSourceRepository @{"puppet/manifests" = ""; "utils" = ""} "content/me/bob"

#Add-FromSourceRepository "Admin/log" "content/log1.zip"
#Add-FromSourceRepository @("Admin/log", "Admin/xml") "content/snappy.zip"
#Add-FromSourceRepository @{"Admin/log" = "log";"Admin/xml" = "xml1"} "content/stormADMIN.zip"
#Add-FromSourceRepository @{"Admin/log" = "bob1";"Admin/xml" = ""} "content/stormADMIN.zip"
#Add-FromSourceRepository @("Admin/log", "STORM.Common", "STORM.Platform") "content/storm.zip"
#Add-FromSourceRepository @{"data/ATLAS/change scripts" = "ChangeScripts"} "content"


#Add-FromSourceRepository "Admin/log" "content/log1"
#Add-FromSourceRepository @("Admin/log", "Admin/xml") "content/snappy"
#Add-FromSourceRepository @{"Admin/log" = "log";"Admin/xml" = "xml1"} "content/stormADMIN"
#Publish-CompressedFromSourceRepository "Admin/log" "content/log1.zip"



