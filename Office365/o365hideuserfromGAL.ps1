$UserCredential = Get-Credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection
Import-PSSession $Session -DisableNameChecking
$EmailAddress = Read-Host -Prompt 'Enter the email address of the user to hide from the GAL:'
Set-Mailbox -Identity $EmailAddress -HiddenFromAddressListsEnabled $true

    Remove-PSSession $Session