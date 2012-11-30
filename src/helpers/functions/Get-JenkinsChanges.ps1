function Get-JenkinsChanges {
param(
  [Parameter(Mandatory=$true)][string]$buildUrl
)
    $DebugPreference = 'continue'
    $ErrorActionPreference = "Stop"
    
    # parse from the url
    $xml = [xml](New-Object System.Net.WebClient).DownloadString"$($buildUrl)/api/xml")
    $message = $xml.freeStyleBuild.changeSet.Item | %{ "$($_.msg) - $($_.user)" }
    
    return $message
}
