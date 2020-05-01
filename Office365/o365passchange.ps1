$UserCredential = Get-Credential
Connect-MsolService -Credential $UserCredential
#$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection
#Import-PSSession $Session -DisableNameChecking

Import-CSV "passfix.csv" | ForEach {
        #Set-Mailbox $_.Mailbox -EmailAddresses @{add=$_.NewEmailAddress}
        Set-MsolUserPassword -UserPrincipalName $_.UserPrincipalName -NewPassword $_.Password -ForceChangePassword $false
    }


#    Remove-PSSession $Session