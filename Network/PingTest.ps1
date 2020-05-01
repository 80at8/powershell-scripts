param (
    [string]$TargetName
)

[bool]$StateSwitch
$StateSwitch = $true

# Include some code in here to work across powershell versions.

while ($true) {
    $PingStatus = Test-Connection -ComputerName $TargetName -Count 3 -Quiet
    $TimeStamp = Get-Date
    if ($PingStatus -eq $false -And $StateSwitch -eq $true) {
        Write-Host "State Changed from Online to Offline at: "  $TimeStamp
        $StateSwitch = $false
    }
    if ($PingStatus -eq $true -And $StateSwitch -eq $false) {
        Write-Host "State Changed from Offline to Online at: "  $TimeStamp
        $StateSwitch = $true
    }

}
