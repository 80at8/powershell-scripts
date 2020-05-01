[CmdletBinding()]
param (
    [PARAMETER(Mandatory=$true)]
    [string[]]$ComputerName,
    $bogus

)

Get-WmiObject -computername $ComputerName win32_logicaldisk -filter "DeviceID='c:'" | Select @{n='freegb';e={$_.freespace / 1gb -as [int]}}