function Add-FromSourceRepository {
param(
  [Parameter(Mandatory=$true)]$paths,
  [Parameter(Mandatory=$true)][string]$outputTo,
  [string]$repository=$env:SourceRepository
)
    $DebugPreference = $env:Debug;
    
    # In the event of getting an error--DO NOT CONTINUE PACKAGING
    $ErrorActionPreference = "Stop"
    
    # Determine if compression will be used
    if( ([regex]"\.zip$").match($outputTo).length -gt 0) {
        $compressed = $true
    } else {
        $compressed = $false
    }
    
    # The paths variable can either be a string, array, or hashtable
    # and we deal with it accordingly
    if( $paths.GetType().IsArray ) {
        # iterate and grab the leaf of each item
        $tmp = @{}
        foreach( $path in $paths) {
            $tmp[$path] = $(Split-Path $path -leaf)
        }
        
        $paths = $tmp
    } else {
        switch -wildcard ($paths.GetType().Name) {
            "String" {
                $paths = @{ $paths = ""; }
            }
            "Hashtable" {
                # do nothing
            }
            default { Write-Error 'Invalid source repository type'; }
        }
    }
    
    # Base zip path
    $baseZipPath = (Join-Path "$($env:TEMP)" "packager$(get-date -f 'yyyyMMddss')$(Get-Random)")
    
    $repoRegex = ([regex]"^((http://|git@)((git|svn)[\w\./\-_]+:?[\w/\-_\.]+))?#?([\w/\-_]+)?")
    # named groups would be great here, but the @ symbol causes issues
    # using different approach to make it easy to get at these values
    $i_path, $i_protocol, $i_branch = 1, 4, 5
    
    $source = $repoRegex.match($repository)
    
    # If this is a git repo, archive everything
    switch -wildcard ($source.groups[$i_protocol].value) {
        "git" {
            if( $($source.groups[$i_branch].value) -eq "" ) {
                $branch = "master"
            } else {
                $branch = $($source.groups[$i_branch].value)
            }
            
            $tempZipFile = Join-Path $baseZipPath $(Split-Path $outputTo -leaf)
            New-Item -itemtype "Directory" $baseZipPath -force | out-null
            
            
            Write-Debug "git archive --format=zip --remote=$($source.groups[$i_path].value) $($branch) $([system.String]::Join(' ', $paths.keys)) -o $tempZipFile"
            git archive --format=zip --remote=$($source.groups[$i_path].value) $branch $("""" + [system.String]::Join('" "', $paths.keys) + """") -o "$tempZipFile"
            
            Push-Location $(Split-Path $tempZipFile -parent)
            
            # Unzip the repo
            New-Item -itemtype "Directory" "tmp" | out-null
            New-Item -itemtype "Directory" "final" | out-null
            
            # Unzip the repo
            Push-Location "tmp"
            & 7za x $(Join-Path ".." $(Split-Path $tempZipFile -leaf))
            Pop-Location
            
            # Remove the zip file
            Remove-Item -force $tempZipFile
        }
    }
    
    
    foreach($path in $($paths.keys)) {
        switch -wildcard ($source.groups[$i_protocol].value) {
            "git" {
                # In the event that we are creating a nested structure, the move command will fail
                # so we have to create the parent of the path first
                if( $paths[$path] -ne "" ) {
                    New-Item -itemtype "Directory" -force $(Join-Path "final" $(Split-Path $paths[$path] -parent)) | out-null
                }
                
                # Then we perform the move operation
                if( $path -eq "" ) {
                    Write-Debug "mv $(Join-Path tmp '*') 'final'"
                    mv $(Join-Path tmp "*") "final"
                }
                elseif( $paths[$path] -eq "" ) {
                    Write-Debug "mv $(Join-Path 'tmp' $(Join-Path $path '*')) 'final'"
                    mv $(Join-Path "tmp" $(Join-Path $path "*")) "final"
                } else {
                    mv $(Join-Path "tmp" $path) $(Join-Path "final" $paths[$path])
                }
                
                
            }
            "svn" {
                if( $compressed ) {
                    $tempZipPath = (Join-Path $baseZipPath $paths[$path])                    
                    svn export --force "$repository)/$path" $tempZipPath
                } else {
                    # Do the export
                    svn export --force "$($env:SourceRepository)/$path" (Join-Path (Join-Path $env:ProjectBuildPath $outputTo) $paths[$path])
                } 
            }
            default { Write-Error 'Invalid source repository type'; }
        }
    } # foreach
    
    # Post loop compression, if necessary
    switch -wildcard ($source.groups[$i_protocol].value) {
        "git" {    
            # in the event that we are checking something out into the project build location
            if( $env:ProjectBuildPath -eq $outputTo ) {
                # Create the build directory if it doesn't exist
                $outputLocation = $env:ProjectBuildPath
                
                New-Item -itemtype "Directory" (Split-Path $outputLocation) -force | out-null
            } else {
                # Create the build directory if it doesn't exist
                $outputLocation = $(Join-Path $env:ProjectBuildPath $outputTo)
                
                New-Item -itemtype "Directory" (Split-Path $outputLocation -parent) -force | out-null
            }
        
			Write-Debug "Outputting to: $outputLocation"
		
            # Recompress the archive and put it with the project
            Push-Location "final"
            if( $compressed ) {
                Write-Debug "& 7za a -tzip '$outputLocation' *"
                & 7za a -tzip "$outputLocation" *
            } else {
                # copy-item is quirky with the destination folder not existing
				# the below item makes it behave as expected
				if( $(Test-Path $outputLocation) -eq $true ) {
					$copyWhat = '*'
				} else {
					$copyWhat = '.'
				}

				Write-Debug "Copy-Item -path $copyWhat '$outputLocation' -container -recurse"
                Copy-Item -path $copyWhat "$outputLocation" -container -recurse
            }
            
            # Yes, doing this twice
            Pop-Location
            Pop-Location
        }
        "svn" {
            if( $compressed ) {
                Push-Location $env:ProjectBuildPath
                & 7za a -tzip $outputTo $baseZipPath/*   
            }
        }
    }
}
