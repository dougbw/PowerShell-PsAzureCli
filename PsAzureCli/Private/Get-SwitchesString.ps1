Function Get-SwitchesString{
Param(
    [Parameter(Mandatory = $True)]
    [AllowNull()]
    [array]
    $Switches
)

    $SwitchStrings = @()
    foreach ($Switch in $Switches){

        $SwitchString = "--{0}" -f $Switch
        $SwitchStrings += $SwitchString

    }

    Return ($SwitchStrings -join ' ')

}