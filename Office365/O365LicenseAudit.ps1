#Requires -Version 5.0
#Requires -Modules MSOnline

param (
[string]$OutputCSV = "O365LicenseAudit.CSV",
[string]$OutputBlockedCSV = "O365LicenseAudit_Blocked.CSV"
)


If (-not (Get-Module -Name "MSOnline")) {
    Import-Module MSOnline
}




$Sku = @{
	"O365_BUSINESS_ESSENTIALS"		     = "Office 365 Business Essentials"
	"O365_BUSINESS_PREMIUM"			     = "Office 365 Business Premium"
    "SMB_BUSINESS_PREMIUM"               = "Office 365 Business Premium (SMB)"
    "SMB_BUSINESS"                       = "Office 365 Business"
    "DESKLESSPACK"					     = "Office 365 (Plan K1)"
	"DESKLESSWOFFPACK"				     = "Office 365 (Plan K2)"
	"LITEPACK"						     = "Office 365 (Plan P1)"
	"EXCHANGESTANDARD"				     = "Exchange Online (Plan 1)"
	"STANDARDPACK"					     = "Enterprise Plan E1"
	"STANDARDWOFFPACK"				     = "Office 365 (Plan E2)"
	"ENTERPRISEPACK"					 = "Enterprise Plan E3"
	"ENTERPRISEPACKLRG"				     = "Enterprise Plan E3"
	"ENTERPRISEWITHSCAL"				 = "Enterprise Plan E4"
	"STANDARDPACK_STUDENT"			     = "Office 365 (Plan A1) for Students"
	"STANDARDWOFFPACKPACK_STUDENT"	     = "Office 365 (Plan A2) for Students"
	"ENTERPRISEPACK_STUDENT"			 = "Office 365 (Plan A3) for Students"
	"ENTERPRISEWITHSCAL_STUDENT"		 = "Office 365 (Plan A4) for Students"
	"STANDARDPACK_FACULTY"			     = "Office 365 (Plan A1) for Faculty"
	"STANDARDWOFFPACKPACK_FACULTY"	     = "Office 365 (Plan A2) for Faculty"
	"ENTERPRISEPACK_FACULTY"			 = "Office 365 (Plan A3) for Faculty"
	"ENTERPRISEWITHSCAL_FACULTY"		 = "Office 365 (Plan A4) for Faculty"
	"ENTERPRISEPACK_B_PILOT"			 = "Office 365 (Enterprise Preview)"
	"STANDARD_B_PILOT"				     = "Office 365 (Small Business Preview)"
	"VISIOCLIENT"					     = "Visio Pro Online"
	"POWER_BI_ADDON"					 = "Office 365 Power BI Addon"
	"POWER_BI_INDIVIDUAL_USE"		     = "Power BI Individual User"
	"POWER_BI_STANDALONE"			     = "Power BI Stand Alone"
	"POWER_BI_STANDARD"				     = "Power-BI Standard"
	"PROJECTESSENTIALS"				     = "Project Lite"
	"PROJECTCLIENT"					     = "Project Professional"
	"PROJECTONLINE_PLAN_1"			     = "Project Online"
	"PROJECTONLINE_PLAN_2"			     = "Project Online and PRO"
	"ProjectPremium"					 = "Project Online Premium"
	"ECAL_SERVICES"					     = "ECAL"
	"EMS"							     = "Enterprise Mobility Suite"
	"RIGHTSMANAGEMENT_ADHOC"			 = "Windows Azure Rights Management"
	"MCOMEETADV"						 = "PSTN conferencing"
	"SHAREPOINTSTORAGE"				     = "SharePoint storage"
	"PLANNERSTANDALONE"				     = "Planner Standalone"
	"CRMIUR"							 = "CMRIUR"
	"BI_AZURE_P1"					     = "Power BI Reporting and Analytics"
	"INTUNE_A"						     = "Windows Intune Plan A"
	"PROJECTWORKMANAGEMENT"			     = "Office 365 Planner Preview"
	"ATP_ENTERPRISE"					 = "Exchange Online Advanced Threat Protection"
	"EQUIVIO_ANALYTICS"				     = "Office 365 Advanced eDiscovery"
	"AAD_BASIC"						     = "Azure Active Directory Basic"
	"RMS_S_ENTERPRISE"				     = "Azure Active Directory Rights Management"
	"AAD_PREMIUM"					     = "Azure Active Directory Premium"
	"MFA_PREMIUM"					     = "Azure Multi-Factor Authentication"
	"STANDARDPACK_GOV"				     = "Microsoft Office 365 (Plan G1) for Government"
	"STANDARDWOFFPACK_GOV"			     = "Microsoft Office 365 (Plan G2) for Government"
	"ENTERPRISEPACK_GOV"				 = "Microsoft Office 365 (Plan G3) for Government"
	"ENTERPRISEWITHSCAL_GOV"			 = "Microsoft Office 365 (Plan G4) for Government"
	"DESKLESSPACK_GOV"				     = "Microsoft Office 365 (Plan K1) for Government"
	"ESKLESSWOFFPACK_GOV"			     = "Microsoft Office 365 (Plan K2) for Government"
	"EXCHANGESTANDARD_GOV"			     = "Microsoft Office 365 Exchange Online (Plan 1) only for Government"
	"EXCHANGEENTERPRISE_GOV"			 = "Microsoft Office 365 Exchange Online (Plan 2) only for Government"
	"SHAREPOINTDESKLESS_GOV"			 = "SharePoint Online Kiosk"
	"EXCHANGE_S_DESKLESS_GOV"		     = "Exchange Kiosk"
	"RMS_S_ENTERPRISE_GOV"			     = "Windows Azure Active Directory Rights Management"
	"OFFICESUBSCRIPTION_GOV"			 = "Office ProPlus"
	"MCOSTANDARD_GOV"				     = "Lync Plan 2G"
	"SHAREPOINTWAC_GOV"				     = "Office Online for Government"
	"SHAREPOINTENTERPRISE_GOV"		     = "SharePoint Plan 2G"
	"EXCHANGE_S_ENTERPRISE_GOV"		     = "Exchange Plan 2G"
	"EXCHANGE_S_ARCHIVE_ADDON_GOV"	     = "Exchange Online Archiving"
	"EXCHANGE_S_DESKLESS"			     = "Exchange Online Kiosk"
	"SHAREPOINTDESKLESS"				 = "SharePoint Online Kiosk"
	"SHAREPOINTWAC"					     = "Office Online"
	"YAMMER_ENTERPRISE"				     = "Yammer for the Starship Enterprise"
	"EXCHANGE_L_STANDARD"			     = "Exchange Online (Plan 1)"
	"MCOLITE"						     = "Lync Online (Plan 1)"
	"SHAREPOINTLITE"					 = "SharePoint Online (Plan 1)"
	"OFFICE_PRO_PLUS_SUBSCRIPTION_SMBIZ" = "Office ProPlus"
	"EXCHANGE_S_STANDARD_MIDMARKET"	     = "Exchange Online (Plan 1)"
	"MCOSTANDARD_MIDMARKET"			     = "Lync Online (Plan 1)"
	"SHAREPOINTENTERPRISE_MIDMARKET"	 = "SharePoint Online (Plan 1)"
	"OFFICESUBSCRIPTION"				 = "Office ProPlus"
	"YAMMER_MIDSIZE"					 = "Yammer"
	"DYN365_ENTERPRISE_PLAN1"		     = "Dynamics 365 Customer Engagement Plan Enterprise Edition"
	"ENTERPRISEPREMIUM_NOPSTNCONF"	     = "Enterprise E5 (without Audio Conferencing)"
	"ENTERPRISEPREMIUM"				     = "Enterprise E5 (with Audio Conferencing)"
	"MCOSTANDARD"					     = "Skype for Business Online Standalone Plan 2"
	"PROJECT_MADEIRA_PREVIEW_IW_SKU"	 = "Dynamics 365 for Financials for IWs"
	"STANDARDWOFFPACK_IW_STUDENT"	     = "Office 365 Education for Students"
	"STANDARDWOFFPACK_IW_FACULTY"	     = "Office 365 Education for Faculty"
	"EOP_ENTERPRISE_FACULTY"			 = "Exchange Online Protection for Faculty"
	"EXCHANGESTANDARD_STUDENT"		     = "Exchange Online (Plan 1) for Students"
	"OFFICESUBSCRIPTION_STUDENT"		 = "Office ProPlus Student Benefit"
	"STANDARDWOFFPACK_FACULTY"		     = "Office 365 Education E1 for Faculty"
	"STANDARDWOFFPACK_STUDENT"		     = "Microsoft Office 365 (Plan A2) for Students"
	"DYN365_FINANCIALS_BUSINESS_SKU"	 = "Dynamics 365 for Financials Business Edition"
	"DYN365_FINANCIALS_TEAM_MEMBERS_SKU" = "Dynamics 365 for Team Members Business Edition"
	"FLOW_FREE"						     = "Microsoft Flow Free"
	"POWER_BI_PRO"					     = "Power BI Pro"
	"O365_BUSINESS"					     = "Office 365 Business"
	"DYN365_ENTERPRISE_SALES"		     = "Dynamics Office 365 Enterprise Sales"
	"RIGHTSMANAGEMENT"				     = "Rights Management"
	"PROJECTPROFESSIONAL"			     = "Project Professional"
	"VISIOONLINE_PLAN1"				     = "Visio Online Plan 1"
	"EXCHANGEENTERPRISE"				 = "Exchange Online Plan 2"
	"DYN365_ENTERPRISE_P1_IW"		     = "Dynamics 365 P1 Trial for Information Workers"
	"DYN365_ENTERPRISE_TEAM_MEMBERS"	 = "Dynamics 365 For Team Members Enterprise Edition"
	"CRMSTANDARD"					     = "Microsoft Dynamics CRM Online Professional"
	"EXCHANGEARCHIVE_ADDON"			     = "Exchange Online Archiving For Exchange Online"
	"EXCHANGEDESKLESS"				     = "Exchange Online Kiosk"
	"SPZA_IW"						     = "App Connect"
	"WINDOWS_STORE"					     = "Windows Store for Business"
	"MCOEV"							     = "Microsoft Phone System"
	"VIDEO_INTEROP"					     = "Polycom Skype Meeting Video Interop for Skype for Business"
	"SPE_E5"							 = "Microsoft 365 E5"
	"SPE_E3"							 = "Microsoft 365 E3"
	"ATA"							     = "Advanced Threat Analytics"
	"MCOPSTN2"						     = "Domestic and International Calling Plan"
	"FLOW_P1"						     = "Microsoft Flow Plan 1"
	"FLOW_P2"						     = "Microsoft Flow Plan 2"
	"CRMSTORAGE"						 = "Microsoft Dynamics CRM Online Additional Storage"
	"SMB_APPS"						     = "Microsoft Business Apps"
	"MICROSOFT_BUSINESS_CENTER"		     = "Microsoft Business Center"
	"DYN365_TEAM_MEMBERS"			     = "Dynamics 365 Team Members"
	"STREAM"							 = "Microsoft Stream Trial"
	"EMSPREMIUM"                         = "ENTERPRISE MOBILITY + SECURITY E5"
	
}




$msolcred = Get-Credential
Connect-MsolService -Credential $msolcred

$ExchangeOnlineSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri 'https://ps.outlook.com/PowerShell-LiveID?PSVersion=5.1.17134.590' -Credential $msolcred -Authentication Basic -AllowRedirection
Import-PSSession $ExchangeOnlineSession -Prefix "O365"


$userList = Get-MsolUser | Sort-Object -Property UserPrincipalName
$numUsers = $userList | Measure-Object | Select-Object -Property Count
$currentUserNumber = 0
ForEach ($user in $userList) { 
    $currentUserNumber += 1
    $currentUserPercentage = [math]::Round((([int]$currentUserNumber / [int]$numUsers.Count) * 100),2)
    Write-Progress -Activity "Examining User Account" -Status $user.UserPrincipalName -PercentComplete $currentUserPercentage;

    if ($user.BlockCredential -eq $True) {
        Write-Host "   Blocked User: " $user.UserPrincipalName

        $Licenses = ((Get-MsolUser -UserPrincipalName $user.UserPrincipalName).Licenses).AccountSkuID

        $MailboxExists = [bool](Get-O365Mailbox $user.UserPrincipalName -erroraction SilentlyContinue)
        
        if ($MailboxExists) {
            $UserStatistics = Get-O365MailboxStatistics -Identity $user.UserPrincipalName | Select LastLogonTime, LastLogoffTime
        } 

        
        if (!($Licenses)) {
            $NewObject01 = New-Object PSObject
            $NewObject01 | Add-Member -MemberType NoteProperty -name UserName -Value $user.DisplayName
            $NewObject01 | Add-Member -MemberType NoteProperty -name UserPrincipalName -Value $user.UserPrincipalName
            $NewObject01 | Add-Member -MemberType NoteProperty -name UserLastLogonTime -Value $UserStatistics.LastLogonTime           
            $NewObject01 | Add-Member -MemberType NoteProperty -name UserLastLogoffTime -Value $UserStatistics.LastLogoffTime           
            $NewObject01 | Add-Member -MemberType NoteProperty -name InternalLicenseSku -Value "NO LICENSE ASSIGNED"
            $NewObject01 | Export-Csv $OutputBlockedCSV -NoTypeInformation -Append
        } else {
            $currentLicenseNumber = 0
            $numLicenses = $Licenses | Measure-Object | Select-Object -Property Count
            ForEach ($License in $Licenses) {
                $currentLicenseNumber += 1
                $currentLicensePercentage = [math]::Round((([int]$currentLicenseNumber / [int]$numLicenses.Count) * 100),2)
                Write-Progress -Id 1 -Activity "Examining Licenses" -Status $License.AccountSkuID -PercentComplete $currentLicensePercentage;

                $LicenseItem = $License -split ":" | Select-Object -Last 1
	            $TextLic = $Sku.Item("$LicenseItem")
                if (!($TextLic)) { 
                   $NewObject02 = $null
		           $NewObject02 = @()
		           $NewObject01 = New-Object PSObject
                   $NewObject01 | Add-Member -MemberType NoteProperty -name UserName -Value $user.DisplayName
                   $NewObject01 | Add-Member -MemberType NoteProperty -name UserPrincipalName -Value $user.UserPrincipalName
                   $NewObject01 | Add-Member -MemberType NoteProperty -name UserLastLogonTime -Value $UserStatistics.LastLogonTime           
                   $NewObject01 | Add-Member -MemberType NoteProperty -name UserLastLogoffTime -Value $UserStatistics.LastLogoffTime           
                   $NewObject01 | Add-Member -MemberType NoteProperty -name InternalLicenseSku -Value $License.AccountSkuID
                   $NewObject02 += $NewObject01
                   $NewObject02 | Export-Csv $OutputBlockedCSV -NoTypeInformation -Append
                } else {
                   $NewObject02 = $null
		           $NewObject02 = @()
		           $NewObject01 = New-Object PSObject
                   $NewObject01 | Add-Member -MemberType NoteProperty -name UserName -Value $user.DisplayName
                   $NewObject01 | Add-Member -MemberType NoteProperty -name UserPrincipalName -Value $user.UserPrincipalName
                   $NewObject01 | Add-Member -MemberType NoteProperty -name UserLastLogonTime -Value $UserStatistics.LastLogonTime           
                   $NewObject01 | Add-Member -MemberType NoteProperty -name UserLastLogoffTime -Value $UserStatistics.LastLogoffTime           
                   $NewObject01 | Add-Member -MemberType NoteProperty -name InternalLicenseSku -Value $TextLic
                   $NewObject02 += $NewObject01
                   $NewObject02 | Export-Csv $OutputBlockedCSV -NoTypeInformation -Append
                }
 
            }
        }
    
    } else {
    
        Write-Host "Authorized User: " $user.UserPrincipalName
        
        $Licenses = ((Get-MsolUser -UserPrincipalName $user.UserPrincipalName).Licenses).AccountSkuID
        
       
        $MailboxExists = [bool](Get-O365Mailbox $user.UserPrincipalName -erroraction SilentlyContinue)
        
        if ($MailboxExists) {
            $UserStatistics = Get-O365MailboxStatistics -Identity $user.UserPrincipalName | Select LastLogonTime, LastLogoffTime
        } 
        
    
        $currentLicenseNumber = 0
        $numLicenses = $Licenses | Measure-Object | Select-Object -Property Count
        ForEach ($License in $Licenses) {
            $currentLicenseNumber += 1
            $currentLicensePercentage = [math]::Round((([int]$currentLicenseNumber / [int]$numLicenses.Count) * 100),2)
            Write-Progress -Id 1 -Activity "Examining Licenses" -Status $currentLicensePercentage -PercentComplete $currentLicensePercentage

            $LicenseItem = $License -split ":" | Select-Object -Last 1
	        $TextLic = $Sku.Item("$LicenseItem")
                
            if (!($TextLic)) { 
               $NewObject02 = $null
		       $NewObject02 = @()
		       $NewObject01 = New-Object PSObject
               $NewObject01 | Add-Member -MemberType NoteProperty -name UserName -Value $user.DisplayName
               $NewObject01 | Add-Member -MemberType NoteProperty -name UserPrincipalName -Value $user.UserPrincipalName
               $NewObject01 | Add-Member -MemberType NoteProperty -name UserLastLogonTime -Value $UserStatistics.LastLogonTime           
               $NewObject01 | Add-Member -MemberType NoteProperty -name UserLastLogoffTime -Value $UserStatistics.LastLogoffTime           
               $NewObject01 | Add-Member -MemberType NoteProperty -name InternalLicenseSku -Value $License.AccountSkuID
               $NewObject02 += $NewObject01
               $NewObject02 | Export-Csv $OutputCSV -NoTypeInformation -Append
            } else {
               $NewObject02 = $null
		       $NewObject02 = @()
		       $NewObject01 = New-Object PSObject
               $NewObject01 | Add-Member -MemberType NoteProperty -name UserName -Value $user.DisplayName
               $NewObject01 | Add-Member -MemberType NoteProperty -name UserPrincipalName -Value $user.UserPrincipalName
               $NewObject01 | Add-Member -MemberType NoteProperty -name UserLastLogonTime -Value $UserStatistics.LastLogonTime           
               $NewObject01 | Add-Member -MemberType NoteProperty -name UserLastLogoffTime -Value $UserStatistics.LastLogoffTime           
               $NewObject01 | Add-Member -MemberType NoteProperty -name InternalLicenseSku -Value $TextLic
               $NewObject02 += $NewObject01
               $NewObject02 | Export-Csv $OutputCSV -NoTypeInformation -Append
            }


        }    
    
   }
              
}

Get-PSSession | Remove-PSSession

