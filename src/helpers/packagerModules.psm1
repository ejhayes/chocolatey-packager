$helpersPath = (Split-Path -parent $MyInvocation.MyCommand.Definition);

# grab functions from files
Resolve-Path $helpersPath\functions\*.ps1 | 
    ? { -not ($_.ProviderPath.Contains(".Tests.")) } |
    % { . $_.ProviderPath }

Export-ModuleMember -Function Write-Host, Write-Error, Write-Token, Publish-File, Add-FromSourceRepository