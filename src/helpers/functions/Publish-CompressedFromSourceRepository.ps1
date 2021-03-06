function Publish-CompressedFromSourceRepository {
param(
    [Parameter(Mandatory=$true)][string]$path,
    [Parameter(Mandatory=$true)][string]$compressTo
)
    $DebugPreference = $env:Debug;
    
    # Double check that the file is zipped or fail
    if( ([regex]"\.zip$").match($compressTo).length -eq 0) {
        throw "Unable to publish file that is not compressed"
    }
    
    # Determine compressed location
    $tempCompressedFile = $(Join-Path $env:TEMP $compressTo)
    Add-FromSourceRepository $path $tempCompressedFile
    
    $publishedPath = Publish-File $tempCompressedFile
    
    # Cleanup
    del $tempCompressedFile
    
    return $publishedPath
}
