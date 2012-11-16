function Write-Token {
param(
  [Parameter(Mandatory=$true)][string]$token,
  [Parameter(Mandatory=$true)][string]$value
)
    $DebugPreference = 'continue'
    
    Write-Debug "I am about to replace $token with $value"
    Get-ChildItem (Join-Path (Join-Path $env:ProjectBuildPath tools) $_) | % {
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
    "Processed: $($fileInfo.Name): '$old' => '$new'"
}