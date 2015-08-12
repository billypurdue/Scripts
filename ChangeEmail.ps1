<#
My employer went through a rebranding and as part of that changed the
domain name used for our primary email accounts.  We have a lot of scripts
(password expiration for example) that rely on the email address specified
in Active Directory to be correct, so I needed to change them all.  Just change
the "old-domain" and "new-domain' and you're good to go.
#>

Import-Module ActiveDirectory
$users = Get-ADUser -Filter 'EmailAddress -like "*@old-domain.com"'
foreach ($user in $users)
{
    $email = $user.samaccountname + '@new-domain.com'
    Set-ADUser -Identity $user.samaccountname -EmailAddress $email
}
