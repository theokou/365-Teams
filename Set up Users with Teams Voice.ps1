
                                                        #*** Για το powershell, χρειάζεται powershell version 5.1 και πάνω,
                                                        #    και το module MicrosoftTeams εγκατεστημένο


############# 1 Connect to MS Teams PS with SFBo module ##################

Import-Module MicrosoftTeams
$cred = Get-Credential # globaladmin@tenant.onmicrosoft.com / pass
Connect-MicrosoftTeams -credential $cred
$session = New-CsOnlineSession -credential $cred
Import-PSSession $session


#### 2 New User - Teams Voice ############################################

#a. Δημιουργούμε τον χρήστη κανονικά στο Active Directory, τον τοποθετούμε στα σωστά groups και κάνουμε sync με AD Connect
#b. Φροντίζουμε ώστε εκτός απο την κανονική άδεια 365, να έχει και το πρόσθετο addon Phone System
#c. Δίνουμε με powershell το εξής

Get-CsOnlineUser user@tenant.com.gr | Format-List UserPrincipalName, DisplayName, SipAddress, Enabled, TeamsUpgradeEffectiveMode, ` EnterpriseVoiceEnabled, HostedVoiceMail, City, UsageLocation, OnlineVoiceRoutingPolicy, OnPremLineURI, OnlineDialinConferencingPolicy, TeamsVideoInteropServicePolicy, TeamsCallingPolicy, HostingProvider, VoicePolicy, CountryOrRegionDisplayName, RegistrarPool, OnPremLineUriManuallySet, mcovalidationerror

#Αν ο χρήστης δεν έχει onpremlineuri τότε βάζουμε το attribute στον Attribute Editor , στη γραμμή msRTCSIP-Line με τη μορφή "tel:+302164005xxx;ext=xxx"
#Αν ο χρήστης δεν έχει EnterpriseVoiceEnabled #True & HostedVoiceMail #True, τότε δίνουμε το παρακάτω:

Set-CsUser -Identity user@tenant.com.gr -EnterpriseVoiceEnabled $true -HostedVoiceMail $true

#Με τα παραπάνω, ο χρήστης θα πρέπει να έχει δικαιώματα να κάνει login στο Teams και να πραγματοποιεί pstn κλήσεις. 


#### 3 Modify Existing User ###############################################

#a. Αν θέλουμε να αλλάξουμε τηλεφωνικό αριθμό σε υπάρχοντα χρήστη, τότε στον Attribute Editor, στο πεδίο msRTCSIP-Line αλλάζουμε τον αριθμό και το 
#   extension. Αν θέλουμε να εισάγουμε τον αριθμό υπάρχοντα χρήστη, τότε πρέπει να κάνουμε clear το πεδίο πρώτα και να κάνουμε συγχρονισμό με AD Connect. 

#### 4 Σωστή εικόνα χρήστη για MS Teams ###################################

# UserPrincipalName              : user@tenant.com.gr
#DisplayName                    : Display Name
#SipAddress                     : sip:user@tenant.com.gr
#Enabled                        : True
#TeamsUpgradeEffectiveMode      : TeamsOnly
#EnterpriseVoiceEnabled         : True
#HostedVoiceMail                : True
#City                           : Location
#UsageLocation                  : GR
#OnlineVoiceRoutingPolicy       : Δεν είναι απαραίτητο, παίρνει τιμή απο το Organization 
#OnPremLineURI                  : tel:+302164005xxx;ext=xxx
#OnlineDialinConferencingPolicy : Δεν είναι απαραίτητο, παίρνει τιμή απο το Organization
#TeamsVideoInteropServicePolicy : Δεν είναι απαραίτητο, παίρνει τιμή απο το Organization 
#TeamsCallingPolicy             : Δεν είναι απαραίτητο, παίρνει τιμή απο το Organization
#HostingProvider                : sipfed.online.lync.com
#VoicePolicy                    : HybridVoice
#CountryOrRegionDisplayName     : Greece
#RegistrarPool                  : tenantregistar.infra.lync.com
#OnPremLineURIManuallySet       : False
#MCOValidationError             : {}