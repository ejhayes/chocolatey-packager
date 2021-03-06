function Packager-Build {
param(
    [Parameter(Mandatory=$true)][string]$projectName,
    [Parameter(Mandatory=$true)][string]$version,
    [Parameter(Mandatory=$true)][string]$sourceRepository,
    [Parameter(Mandatory=$true)][string]$packagingRepository,
    [Hashtable]$buildArgs,
    [string[]]$includeDirectories
)
    Write-Debug "Running 'Packager-Build' for $projectName with source: `'$sourceRepository`', packagingRepository: `'$packagingRepository`', buildArgs:`'$buildArgs`', includeDirectories:`'$includeDirectories`'";
  
    $repoRegex = ([regex]"^((http://|git@)((git|svn)[\w\./\-_]+:?[\w/\-_\.]+))?#?([\w/\-_]+)?")
    # named groups would be great here, but the @ symbol causes issues
    # using different approach to make it easy to get at these values
    $path, $protocol, $branch = 1, 4, 5
    
    $source = $repoRegex.match($sourceRepository)
    $package = $repoRegex.match($packagingRepository)
    
    # Checkout the packaging source code
    Add-FromSourceRepository "" $env:ProjectBuildPath $env:PackagingRepository
    
    
#    switch -wildcard ($package.groups[$protocol].value) {
#        "git" { Packager-CheckoutGit $package.groups[$path].value $build_root $package.groups[$branch].value; }
#        "svn" { Packager-CheckoutSvn $packageName $installerArguments; }
#        default { Write-Error 'Invalid source repository type'; }
#    }
    
    # Preprocessing
    Write-Token "__VERSION__" $version
    
    # Call the preprocessing script (along with any arguments we specified earlier)   
    if (Test-Path (Join-Path $env:ProjectBuildPath "build.ps1") ) {
	   Write-Host "Running the projects build script."
       & (Join-Path $env:ProjectBuildPath "build.ps1") @buildArgs
    }
    else {
    	Write-Host "No Project Level Build Script found. Continuing."
    }
    
    # Post preprocessing work
    
    
    Write-Debug "Switching to $($env:ProjectBuildPath)"
    Push-Location $env:ProjectBuildPath
    
    # Run the packaging Tool
    Write-Debug "Packaging"
    
    cpack
    
    
    # Upload to the proget repository
    if( $env:debugPackage -eq $true ) {
        Write-Debug "Debug package mode. NOT UPLOADING TO FEED"    
    } else {
        Write-Debug "Uploading to feed"
        Get-ChildItem *.nupkg | %{
            nuget push $_.name password -source http://rws-win-dev:8080/nuget/default
        }
    }
    
    Pop-Location
    
    # Perform cleanup
    if( $env:DebugPackage -eq $true ) {
        Write-Debug "Not performing any cleanup on the project. OPENING up explorer for inspection"
        start $env:ProjectBuildPath
    } else {
        Write-Debug "Removing $($env:ProjectBuildPath)"
        Remove-Item $env:ProjectBuildPath -recurse
    }
}