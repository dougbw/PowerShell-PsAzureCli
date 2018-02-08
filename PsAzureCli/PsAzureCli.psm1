$Files = @()
$Public  = Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 | Where {$_.Name -notlike "*tests*"}
$Private = Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 | Where {$_.Name -notlike "*tests*"}

$Files += $Public
$Files += $Private

foreach($file in $Files){
    try{
        . $file.fullname
    }
    catch{
        throw $_
    }
}

Export-ModuleMember -Function $Public.Basename