# PowerShell -NoProfile -ExecutionPolicy unrestricted -Command "[System.Threading.Thread]::CurrentThread.CurrentCulture = ''; [System.Threading.Thread]::CurrentThread.CurrentUICulture = '';& './packager.ps1' build atlas_changescripts -version '1.0.0' -sourceRepository 'git@git.psm.local:lightning.git' -packagingRepository 'git@git.psm.local:choc-storm-changescripts.git' -buildArgs @{'database' = 'ATLAS'}"
# Preprocessor Script for this package
# Things that you would classify as needing "preprocessing"
# - Tokenizing: e.g. __DATABASE__ or __VERSION__ gets replaced by actual values
# - Ensuring certain paths are available via HTTP
# - Anything else you would do manually to this package BEFORE running the cpack command
