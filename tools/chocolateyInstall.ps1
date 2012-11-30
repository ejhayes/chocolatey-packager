# Expects certain install arguments to be passed to the environment
$contentDir = (Split-Path -parent $MyInvocation.MyCommand.Definition | Split-Path | Join-Path -ChildPath "src")

# Add the packager to the system path
Install-ChocolateyPath $contentDir 'machine'
