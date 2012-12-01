function Get-JenkinsChanges {
param(
  [string]$buildUrl=""
)
    $DebugPreference = $env:Debug;
    $ErrorActionPreference = "Stop"
    $noChanges = "NO CHANGES.."

    # parse from the url
    if( $buildUrl -eq "" ) {
        $message = $noChanges
    } else {
        $xml = [xml](New-Object System.Net.WebClient).DownloadString("$($buildUrl)api/xml")
        
        $upstreamUrl = $xml.selectnodes("//cause") | % { "$($_.upstreamUrl)$($_.upstreamBuild)" }
        
        if( $upstreamUrl -ne "" ) {
            $upstreamUrl = "$($env:JENKINS_URL)$upstreamUrl/"
            $message += Get-JenkinsChanges $upstreamUrl
        } 

        $message += "$buildUrl`n"
        $changes = $xml.selectnodes("//changeSet/item") | % { "$($_.msg) [$($_.user)$($_.author.fullName)]" }

        if( $changes -eq "" -or $changes -eq $null ) {
            $message += "$noChanges`n`n"
        } else {
            $message += "$changes`n`n"
        }
    }
    return $message
}
