function Get-JenkinsChanges {
param(
  [string]$buildUrl=""
)
    $DebugPreference = $env:Debug;
    $ErrorActionPreference = "Stop"
    
    # parse from the url
    if( $buildUrl -eq "" ) {
        $message = "NO CHANGES"
    } else {
        $message = "$buildUrl`n"
        $xml = [xml](New-Object System.Net.WebClient).DownloadString("$($buildUrl)api/xml")
        
        $upstreamUrl = $xml.selectnodes("//cause") | % { "$($_.upstreamUrl)$($_.upstreamBuild)" }
        
        if( $upstreamUrl -ne "" ) {
            $message += Get-JenkinsChanges "$($env:JENKINS_URL)$upstreamUrl"
        } else {
            $message += $xml.selectnodes("//changeSet/item") | % { "$($_.msg) [$($_.user)$($_.author.fullName)]" }
        }
        
        if( $message -eq "" ) {
            $message = "NO CHANGES"
        }
    }
    
    return $message
}
