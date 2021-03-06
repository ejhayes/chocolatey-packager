function Packager-Help {
@"
$h1
Packager - Build NuGet Packages

Version: `'$packagerVersion'`
Install Directory: `'$packagerPath`'
$h1
Packager is used by the build machines to orchestrate the whole NuGet package creation process easy

$h2
Usage
$h2
packager [build [projectName [-version version] [-sourceRepository git|svn://repo] [-packagingRepository git|svn://repo] [-buildArgs @{"keyA" = "valueA"}] [-includeDirectories @('folderA','folderB')] [-debug] [-debugPackage] | help]

If you want to do a sample test build with packager (and NOT upload it) make sure to pass in -debugPackage flag!

example: packager build atlas_changescripts -version 'X.Y.Z' -sourceRepository 'git@git.psm.local:choc-storm-changescripts.git' -packagingRepository 'git@git.psm.local:choc-storm-changescripts.git' -buildArgs @{'database' = 'ATLAS'}
example: packager help

$h1
"@ | Write-Host
}