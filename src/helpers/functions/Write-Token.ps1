function Write-Token {
param(
  [Parameter(Mandatory=$true)][string]$token,
  [string]$value=''
)
    $DebugPreference = $env:Debug;
    
    # Tools area
    Get-ChildItem (Join-Path (Join-Path $env:ProjectBuildPath tools) $_) | % {
        ReplaceText $_ $token $value
    }
    
    # Src area (may not exist)
    if( $(test-path $(Join-Path $env:ProjectBuildPath src) -pathtype container ) ) {
        Get-ChildItem (Join-Path (Join-Path $env:ProjectBuildPath src) $_) | % {
            ReplaceText $_ $token $value
        }
    }
    
    # NuSpec files
    Get-ChildItem (Join-Path (Join-Path $env:ProjectBuildPath *.nuspec) $_) | % {
        ReplaceText $_ $token $value
    }    
}

function ReplaceText {
    param ($fileInfo, $old, $new)
    if( $_.GetType().Name -ne 'FileInfo')
    {
        # i.e. reject DirectoryInfo and other types
         return
    }
    (Get-Content $fileInfo.FullName) | % {$_ -replace $old, $new} | Set-Content -path $fileInfo.FullName
    Write-Debug "Processed: $($fileInfo.Name): '$old' => '$new'"
}