Function Invoke-AzureCli{
[cmdletbinding()]
Param(
    [Parameter(Mandatory = $False)]
    [string]
    $Path = "C:\Program Files (x86)\Microsoft SDKs\Azure\CLI2\wbin\az.cmd",

    [Parameter(Mandatory = $True)]
    [string]
    $ResourceType,

    [Parameter(Mandatory = $False)]
    [string]
    $Operation,

    [Parameter(Mandatory = $False)]
    [string]
    $ChildOperation,

    [Parameter(Mandatory = $False)]
    [hashtable]
    $Parameters,

    [Parameter(Mandatory = $False)]
    [array]
    $Switches,

    [Parameter(Mandatory = $False)]
    [switch]
    $PassThru,

    # Allow a proxy for debugging requests sent from the az cli by disabling ssl proxying
    [Parameter(Mandatory = $False)]
    [switch]
    $DisableSslVerification
)

    if ( (Test-Path -Path $Path) -eq $False){
        throw ("az cli not found at '{0}'" -f $Path)
    }

    if ($DisableSslVerification){
        $env:ADAL_PYTHON_SSL_NO_VERIFY = "true"
        $env:AZURE_CLI_DISABLE_CONNECTION_VERIFICATION = "true"
    }
    else{
        Remove-Item env:\ADAL_PYTHON_SSL_NO_VERIFY -ErrorAction SilentlyContinue
        Remove-Item env:\AZURE_CLI_DISABLE_CONNECTION_VERIFICATION -ErrorAction SilentlyContinue
    }

    $ParametersString = Get-ParameterString -Parameters $Parameters
    $SwitchesString = Get-SwitchesString -Switches $Switches
    $Arguments = "{0} {1} {2} {3} {4}" -f $ResourceType, $Operation, $ChildOperation, $ParametersString, $SwitchesString
    $Arguments = $Arguments.Trim()

    # Execute command
    if ( ($Parameters.Keys -contains 'p') -or ($Parameters.Keys -contains 'password') ){
        Write-Verbose -Verbose ("Executing command: az {0}" -f $ResourceType)
    }
    else{
        Write-Verbose -Verbose ("Executing command: az {0}" -f $Arguments)    
    }
    & $Path ($Arguments -split ' ') | Tee-Object -Variable Output | Write-Verbose -Verbose

    if ($Output -eq $null){
        Return
    }

    # Parse and return response
    if ($PassThru){
        try{
            $Json = $Output | ConvertFrom-Json -ErrorAction Stop
            Return $Json
        }
        catch{
            Write-Debug "az output is not valid json"     
        }
    }

}