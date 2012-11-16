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
    #switch -wildcard ($source.groups[$protocol].value) {
    #    "git" { Packager-CheckoutGit $package.groups[$path].value $build_root $package.groups[$branch].value; }
    #    "svn" { Chocolatey-Cygwin $packageName $installerArguments; }
    #    default { Write-Error 'Invalid source repository type'; }
    #}
    
    # Call the preprocessing script (along with any arguments we specified earlier)
    if (Test-Path (Join-Path $env:ProjectBuildPath "build.ps1") ) {
	   Write-Host "Running the projects build script."
       & (Join-Path $env:ProjectBuildPath "build.ps1") @buildArgs
    }
    else {
    	Write-Host "No Project Level Build Script found. Continuing."
    }
    
    # Post preprocessing (i.e. add a version number to this package)
    Write-Token "__VERSION__" $version
    
    # Run the packaging Tool
    
    
    # Upload to the proget repository
    
}