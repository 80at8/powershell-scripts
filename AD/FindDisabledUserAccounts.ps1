    # Will find disabled user accounts (and if accounts home directories are network mapped will find total storage used by disabled accounts)
    # Put server FQDN in #SERVERFQDN#, put network share where user folders are located in #STORAGEPATH#



    $OUUsers = Get-ADUser -Server "#SERVERFQDN#" -Properties whenCreated,whenChanged,LastLogonDate,ObjectSID,PasswordLastSet,SamAccountName,MemberOf,DistinguishedName,Enabled -Filter * | Sort-Object -Property Enabled
    
    $usersEnabled = 0
    $userDisabled = 0
    $totalEnabledAccountFolderSize = 0
    $totalDisabledAccountFolderSize = 0

    foreach ($user in $OUUsers) {        
            $OutPutLine = New-Object psobject
            $OutPutLine | Add-Member -MemberType NoteProperty -name SamAccountName -Value $user.SamAccountName
            $OutPutLine | Add-Member -MemberType NoteProperty -name whenCreated -Value $user.whenCreated
            $OutPutLine | Add-Member -MemberType NoteProperty -name whenChanged -Value $user.whenChanged
            $OutPutLine | Add-Member -MemberType NoteProperty -name LastLogonDate -Value $user.LastLogonDate
            $OutPutLine | Add-Member -MemberType NoteProperty -name PasswordLastSet -Value $user.PasswordLastSet

            if ($user.Enabled -eq $True) {
                $usersEnabled = $usersEnabled + 1
                $userPath = "\\#STORAGEPATH#\" + $user.SamAccountName
                if (Test-Path -Path $userPath) {   
                    $userFolderSize = Invoke-Command -ComputerName STORAGE -ScriptBlock { (Get-Childitem $using:userPath -Recurse -File | Select Length | Measure-Object -Property Length -Sum)}
                    $userFolderSizeMB = [math]::round($userFolderSize.Sum/1MB, 2)
                    $totalEnabledAccountFolderSize = $totalEnabledAccountFolderSize + $userFolderSizeMB
                    Write-Host -ForeGroundColor White "User profile exists for enabled account: " $user.SamAccountName " Size: " $userFolderSizeMB "MB"

                    $OutPutLine | Add-Member -MemberType NoteProperty -name UsreProfileUNCPath -Value $userPath
                    $OutPutLine | Add-Member -MemberType NoteProperty -name UserProfileFolderSizeInMB -Value $userFolderSizeMB
                    $OutPutLine | export-csv "EnabledAccounts.CSV" -NoTypeInformation -Append
                    
                }                
            } else {
                $usersDisabled = $usersDisabled + 1
                $userPath = "\\#STORAGEPATH#\" + $user.SamAccountName
                if (Test-Path -Path $userPath) {   
                    $userFolderSize = Invoke-Command -ComputerName STORAGE -ScriptBlock { (Get-Childitem $using:userPath -Recurse -File | Select Length | Measure-Object -Property Length -Sum)}
                    $userFolderSizeMB = [math]::round($userFolderSize.Sum/1MB, 2)
                    $totalDisabledAccountFolderSize = $totalDisabledAccountFolderSize + $userFolderSizeMB
                    Write-Host -ForeGroundColor DarkGray "User profile exists for disabled account: " $user.SamAccountName " Size: " $userFolderSizeMB "MB"

                    $OutPutLine | Add-Member -MemberType NoteProperty -name UserProfileUNCPath -Value $userPath
                    $OutPutLine | Add-Member -MemberType NoteProperty -name UserProfileFolderSizeInMB -Value $userFolderSizeMB
                    $OutPutLine | export-csv "DisabledAccounts.CSV" -NoTypeInformation -Append
                    
                }
            }
            

            
            
            
    
}

Write-Host $usersEnabled " Accounts Enabled [" $totalEnabledAccountFolderSize "MB]"
Write-Host $usersDisabled  " Accounts Disabled [" $totalDisabledAccountFolderSize "MB]"