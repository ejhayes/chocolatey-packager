function Get-JenkinsChanges {
param(
  [string]$buildUrl=""
)
    $DebugPreference = 'continue'
    $ErrorActionPreference = "Stop"
    
    # parse from the url
    if( $buildUrl -eq "" ) {
        $message = "NO CHANGES"
    } else {
        $xml = [xml](New-Object System.Net.WebClient).DownloadString("$($buildUrl)api/xml")
        $message = $xml.freeStyleBuild.changeSet.Item | %{ "$($_.msg) - $($_.user)" }
    }
    
    return $message
}
