function Packager-CheckoutGit {
param(
    [Parameter(Mandatory=$true)][string]$repositoryPath,
    [Parameter(Mandatory=$true)][string]$checkoutPath,
    [string]$branch="master"
)
    Write-Debug "Running 'Packager-CheckoutGit' repositoryPath: `'$repositoryPath`'";
  
    if( $branch -eq "" ){
        $branch = "master"
    }
  
    # checkout repository to specified path
    Write-Debug "git clone $repositoryPath $checkoutPath -b $branch"
    git clone $repositoryPath $checkoutPath -b $branch
}