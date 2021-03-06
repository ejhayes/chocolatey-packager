param (
    [string]$command,
    [string]$projectName,
    [string]$version,
    [string]$sourceRepository,
    [string]$packagingRepository,
    $buildArgs,
    [string[]]$includeDirectories,
    [string]$debug='Continue',
    [switch]$debugPackage
)

# In the event of getting an error--DO NOT CONTINUE PACKAGING
$ErrorActionPreference = "Stop"

## Set the culture to invariant
$currentThread = [System.Threading.Thread]::CurrentThread;
$culture = [System.Globalization.CultureInfo]::InvariantCulture;
$currentThread.CurrentCulture = $culture;
$currentThread.CurrentUICulture = $culture;

$packagerVersion = '__VERSION__'
$packagerPath = (Split-Path -parent $MyInvocation.MyCommand.Definition)

# Packaging Directories
$build_root = (Join-Path $env:SystemDrive "builds")
$proget_root = (Join-Path (Join-Path (Join-Path $env:ProgramData "Proget") "Packages") "Default")
$iis_root = (Join-Path (Join-Path $env:SystemDrive "inetpub") "wwwroot")

# Project constants
$h1 = '====================================================='
$h2 = '-------------------------'
$RunNote = "DarkCyan"
$Warning = "Magenta"
$Error = "Red"
$Note = "Green"

$installModule = Join-Path $packagerPath (Join-Path 'helpers' 'packagerModules.psm1')
Write-Debug $installModule
Import-Module $installModule

# Values used by helper functions (using environment values for these)
$env:ProjectBuildPath = (Join-Path $build_root $projectName)
$env:FileServerBase = $iis_root
$env:ProjectName = $projectName
$env:SourceRepository = $sourceRepository
$env:PackagingRepository = $packagingRepository
$env:Version = $version
$env:Debug = $debug
$env:DebugPackage = $debugPackage

# Debugging preference
$DebugPreference = $env:Debug;

# grab functions from files
Resolve-Path $packagerPath\functions\*.ps1 | 
    ? { -not ($_.ProviderPath.Contains(".Tests.")) } |
    % { . $_.ProviderPath }

switch -wildcard ($command) 
{
  "build" { Packager-Build $projectName $version $sourceRepository $packagingRepository $buildArgs $includeDirectories; }
  "help" { Packager-Help; }
  default { Write-Host 'Please run packager /? or packager help'; }
}
