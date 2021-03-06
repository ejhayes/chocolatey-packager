function Publish-File {
param(
  [Parameter(Mandatory=$true)][string]$file
)
    $DebugPreference = $env:Debug;
    $ErrorActionPreference = "Stop"
    
    $fileRegex = ([regex]"^([\w\-_]+)(\.\w+)?")
    # using constants since named groups don't work as expected
    $name, $extension = 1, 2
    
    $shortFilename = Split-Path $file -leaf
    
    $f = $fileRegex.match($shortFilename)
    
    $uploadFilename = "$($f.groups[$name].value)-$($env:Version)$($f.groups[$extension])"
    
    if($file -eq $shortFilename){
        $file = Join-Path $env:ProjectBuildPath $file
    }
    
    $ProjectPublishedFilesPath = Join-Path $env:FileServerBase $env:ProjectName
    
    Write-Debug "Uploading $file to $uploadFilename"
    
    New-Item -itemtype "Directory" $ProjectPublishedFilesPath -force | out-null    
    Move-Item $file (Join-Path $ProjectPublishedFilesPath $uploadFilename) -force

    Write-Host "Uploaded: $uploadFilename		[OK]"
    
    return (Join-Path $env:ProjectName $uploadFilename)
}
