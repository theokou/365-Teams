#1 Connect to MS Teams PS with SFBo module
Import-Module MicrosoftTeams
$cred = Get-Credential # feduser@tenant.onmicrosoft.com / pass
Connect-MicrosoftTeams -credential $cred
$session = New-CsOnlineSession -credential $cred
Import-PSSession $session


#move users to SFBO
Move-CsUser -UserList "C:\path location\users.txt" -Target "sipfed.online.lync.com" -HostedMigrationOverrideUrl "https://tenantregistrar.online.lync.com/HostedMigration/hostedmigrationService.svc" -Credential $cred


#move users to SFB Server
Move-CsUser -UserList "C:\Users\user\Desktop\users.txt" -Target "rhea.varioclean.local" -HostedMigrationOverrideUrl "https://admin0e.online.lync.com/HostedMigration/hostedmigrationService.svc" -Credential $cred


#Switch Tenant to Teams Only
Grant-CsTeamsUpgradePolicy -PolicyName UpgradeToTeams -Global



#Disable Skype


#Disable Shared SIP Addres space
Set-CsTenantFederationConfiguration -SharedSipAddressSpace $false

#Disable communication with o365
Get-CsHostingProvider|Set-CsHostingProvider -Enabled $false

#check various attributes

Get-CsOnlineUser user@tenant.com.gr | Format-List UserPrincipalName, DisplayName, SipAddress, Enabled, TeamsUpgradeEffectiveMode, ` EnterpriseVoiceEnabled, HostedVoiceMail, City, UsageLocation, DialPlan, TenantDialPlan, OnlineVoiceRoutingPolicy, ` LineURI, OnPremLineURI, OnlineDialinConferencingPolicy, TeamsVideoInteropServicePolicy, TeamsCallingPolicy, HostingProvider, ` InterpretedUserType, VoicePolicy, CountryOrRegionDisplayName

Get-AzureADDirectorySetting -Id (Get-AzureADDirectorySetting | where -Property DisplayName -Value "Group.Unified" -EQ).id

Install-Module azureadpreview
connect-azuread
