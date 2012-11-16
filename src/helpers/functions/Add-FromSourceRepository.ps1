function Add-FromSourceRepository {
param(
  [Parameter(Mandatory=$true)][string]$path,
  [Parameter(Mandatory=$true)][string]$outputTo
)
    $DebugPreference = 'continue'
    
    svn export "$($env:SourceRepository)/$path" (Join-Path $env:ProjectBuildPath $outputTo)
}
