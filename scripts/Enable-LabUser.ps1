<#
.SYNOPSIS
    Aktiviert deaktiviertes Testkonto nach interaktiver Passwortvergabe.
.EXAMPLE
    .\scripts\Enable-LabUser.ps1 -SamAccountName lab.max -WhatIf
#>
[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
param(
    [Parameter(Mandatory = $true)]
    [ValidatePattern('^[a-zA-Z][a-zA-Z0-9._-]{0,19}$')]
    [string]$SamAccountName
)
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
Import-Module ActiveDirectory -ErrorAction Stop
$user = Get-ADUser -Identity $SamAccountName -ErrorAction Stop
if ($user.Enabled) { throw "Konto $SamAccountName bereits aktiv. Abbruch." }

if ($PSCmdlet.ShouldProcess($SamAccountName,'Individuelles Passwort setzen und Konto aktivieren')) {
    $secret = Read-Host -AsSecureString -Prompt "Individuelles Passwort für $SamAccountName"
    if ($secret.Length -eq 0) { throw 'Leeres Passwort nicht erlaubt.' }
    Set-ADAccountPassword -Identity $SamAccountName -Reset -NewPassword $secret -ErrorAction Stop
    Set-ADUser -Identity $SamAccountName -ChangePasswordAtLogon $true -ErrorAction Stop
    Enable-ADAccount -Identity $SamAccountName -ErrorAction Stop
    Write-Output "Konto $SamAccountName aktiviert; Kennwortwechsel bei Anmeldung erforderlich."
}
