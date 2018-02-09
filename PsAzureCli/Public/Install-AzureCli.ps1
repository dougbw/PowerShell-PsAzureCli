Function Install-AzureCli{
Param(

    [parameter(Mandatory = $False)]
    [uri]
    $Uri = "https://azurecliprod.blob.core.windows.net/msi/azure-cli-latest.msi",

    [parameter(Mandatory = $False)]
    [string]
    $PackageName = "Microsoft CLI 2.0 for Azure"
)

    $IsInstalled = Get-Package -Name $PackageName -ErrorAction SilentlyContinue

    if ($IsInstalled){
        Write-Verbose ("Package '{0}' version '{1}' is already installed" -f $PackageName , $IsInstalled.Version)
        Return
    }

    Write-Verbose ("Downloading '{0}'" -f $Uri)
    $FileBaseName = Split-Path -Path $Uri -Leaf
    $FilePath = Join-Path -Path $env:TEMP -ChildPath $FileBaseName
    Invoke-WebRequest -UseBasicParsing -Uri "https://azurecliprod.blob.core.windows.net/msi/azure-cli-latest.msi" -OutFile $FilePath

    Write-Verbose ("Installing '{0}'" -f $FilePath)
    $LogPath = Join-Path -Path $env:TEMP -ChildPath "az-cli.log"
    $ArgumentList = '/i "{0}" /qn /l*v "{1}"' -f $FilePath, $LogPath
    Start-Process -FilePath 'msiexec' -Wait -ArgumentList $ArgumentList

}