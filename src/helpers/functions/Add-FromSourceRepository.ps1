function Add-FromSourceRepository {
param(
  [Parameter(Mandatory=$true)][string]$path,
  [Parameter(Mandatory=$true)][string]$outputTo
)
    $DebugPreference = 'continue'
    
    $repoRegex = ([regex]"^((http://|git@)((git|svn)[\w\./\-_]+:?[\w/\-_\.]+))?#?([\w/\-_]+)?")
    # named groups would be great here, but the @ symbol causes issues
    # using different approach to make it easy to get at these values
    $i_path, $i_protocol, $i_branch = 1, 4, 5
    
    $source = $repoRegex.match($env:SourceRepository)
    
    switch -wildcard ($source.groups[$i_protocol].value) {
        "git" {
            if( $($source.groups[$i_branch].value) -eq "" ) {
                $branch = "master"
            } else {
                $branch = $($source.groups[$i_branch].value)
            }
            Write-Debug "branch is $branch"
            
            # Create the new directory if it doesn't exist
            New-Item -itemtype "Directory" (Join-Path $env:ProjectBuildPath $outputTo) -force | out-null    
            Push-Location (Join-Path $env:ProjectBuildPath $outputTo)
            $tempZipFile = Join-Path "$($env:TEMP)" "$(Split-Path $path -leaf)$(get-date -f 'yyyyMMddss').zip"
            Write-Debug "git archive --format=zip --remote=$($source.groups[$i_path].value) $($branch):$($path) -o $tempZipFile"
            git archive --format=zip --remote=$($source.groups[$i_path].value) "$($branch):$($path)" -o $tempZipFile
            & 7za x -tzip -y $tempZipFile
            del $tempZipFile
            Pop-Location
        }
        "svn" {
            svn export --force "$($env:SourceRepository)/$path" (Join-Path $env:ProjectBuildPath $outputTo)
        }
        default { Write-Error 'Invalid source repository type'; }
    }
    
    # Determine more info about our source
    
}
