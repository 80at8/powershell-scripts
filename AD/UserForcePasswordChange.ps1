Disable-ADAccount -Identity "CN=USERNAME,OU=DEPARTMENT,DC=CONTOSO,DC=com"


$OUList = @(
            "OU=SEATTLE,DC=DEPARTMENT,DC=CONTOSO,DC=com"
        )


foreach ($OU in $OUList) {
    $OUUsers = Get-ADUser -Properties whenCreated,whenChanged,LastLogonDate,ObjectSID,PasswordLastSet,SamAccountName,MemberOf,DistinguishedName,Enabled -Filter * -SearchBase $OU
    
    foreach ($user in $OUUsers) {        
        if ($user.Enabled) {
            if ($user.SamAccountName -eq "database") { 
                # don't overwrite users with database access.. do those by hand when side effects are better understood.
                Write-Host -ForegroundColor DarkYellow "database user"                
            } else {
                Write-Host -ForeGroundColor Yellow "Changing Password for " $user.SamAccountName " and Forcing Password Change At Next Logon"
                Write-Host ""
                $Password = ([char[]]([char]65..[char]77) + ([char[]]([char]109..[char]122)) + 0..9 | sort {Get-Random})[0..8] -join ''
                $EmailAddress = $user.SamAccountName + "@jameswesternstar.com"
                Set-ADAccountPassword -Server "PG-DC1.network.jamesws.com" -Identity $user.SamAccountName -Reset -NewPassword (ConvertTo-SecureString -AsPlainText "$Password" -Force)
                Set-ADUser -Identity $user.SamAccountName -CannotChangePassword:$false -PasswordNeverExpires:$false -ChangePasswordAtLogon:$true -EmailAddress $EmailAddress
                Write-Host -ForeGroundColor Green "New Password: " $Password
                $OutPutLine = New-Object psobject
                $OutPutLine | Add-Member -MemberType NoteProperty -name SamAccountName -Value $user.SamAccountName
                $OutPutLine | Add-Member -MemberType NoteProperty -name SamAccountPassword -Value $Password
                $OutPutLine | Add-Member -MemberType NoteProperty -name DistinguishedName -Value $Password
                $OutPutLine | export-csv "NewPasswords.CSV" -NoTypeInformation -Append
            }
        } else {
            Write-Host -ForeGroundColor DarkYellow "User " $user.SamAccountName  " Disabled"
            Write-Host ""
            $OutPutLine = New-Object psobject
            $OutPutLine | Add-Member -MemberType NoteProperty -name SamAccountName -Value $user.SamAccountName
            $OutPutLine | Add-Member -MemberType NoteProperty -name SamAccountPassword -Value "DISABLED"
            $OutPutLine | export-csv "NewPasswords.CSV" -NoTypeInformation -Append
        }

    }
    
    
}