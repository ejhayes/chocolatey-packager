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
packager [build [projectName [-branch branch] [-sourceRepository git|svn://repo] [-packagingRepository git|svn://repo] [-buildArgs @{"keyA" = "valueA"}] [-includeDirectories @('folderA','folderB')] | help]

example: packager build atlas_changescripts -sourceRepository "svn://svn/storm/trunk" -packagingRepository "git://git/choc-database_changescripts:master" -buildArgs @{"database" = "ATLAS"}
example: packager help

$h1
"@ | Write-Host
}