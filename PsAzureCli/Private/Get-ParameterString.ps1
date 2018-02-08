Function Get-ParameterString{
Param(
    [Parameter(Mandatory = $True)]
    [AllowNull()]
    [hashtable]
    $Parameters
)


    $ParameterStrings = @()
    foreach ($Parameter in $Parameters.Keys){
        $ParameterValue = $Parameters[$Parameter]


        switch ($Parameters[$Parameter].GetType().Name){

            "Boolean"{
                $ParameterValue = $Parameters[$Parameter].ToString().ToLower()
            }

            default{
                $ParameterValue = $Parameters[$Parameter]
            }

        }

        if ($Parameters[$Parameter] -eq $null){
           throw ("Parameter '{0}' value is null" -f $Parameter)
        }

        if ($Parameter.Length -eq 1){
            $ParameterString = "-{0} `"{1}`"" -f $Parameter, $ParameterValue
        }
        else{
            $ParameterString = "--{0} `"{1}`"" -f $Parameter, $ParameterValue           
        }

        $ParameterStrings += $ParameterString

    }

    Return ($ParameterStrings -join ' ')

}