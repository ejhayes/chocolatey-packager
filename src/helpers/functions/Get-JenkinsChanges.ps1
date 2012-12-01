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
        $message = $xml.selectnodes("//changeSet/item") | % { "$($_.msg) [$($_.user)$($_.author.fullName)]" }
        
        if( $message -eq "" ) {
            $message = "NO CHANGES"
        }
    }
    
    return $message
}
