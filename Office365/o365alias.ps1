$UserCredential = Get-Credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection
Import-PSSession $Session -DisableNameChecking

Import-CSV "aliases.csv" | ForEach {
        Set-Mailbox $_.Mailbox -EmailAddresses @{add=$_.NewEmailAddress}
    }

    Remove-PSSession $Session