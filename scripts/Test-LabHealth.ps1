<#
.SYNOPSIS
    Read-only AD/DNS-Check, optional SMB-Port und Freigabe.
.EXAMPLE
    .\scripts\Test-LabHealth.ps1 -DomainFqdn firma.local
#>
[CmdletBinding()]
param(
    [ValidateNotNullOrEmpty()]
    [string]$DomainFqdn = 'firma.local',
    [string]$FileServer,
    [string]$ShareName
)
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$results = New-Object 'System.Collections.Generic.List[object]'

function Add-Result {
    param([string]$Test,[bool]$OK,[string]$Info)
    $script:results.Add([pscustomobject]@{Test=$Test;OK=$OK;Info=$Info})
}

try {
    Import-Module ActiveDirectory -ErrorAction Stop
    $domain = Get-ADDomain -Identity $DomainFqdn -ErrorAction Stop
    Add-Result -Test 'AD-Domäne' -OK ($domain.DNSRoot -ieq $DomainFqdn) -Info $domain.DNSRoot
} catch {
    Add-Result -Test 'AD-Domäne' -OK $false -Info $_.Exception.Message
}

try {
    $records = @(Resolve-DnsName -Name "_ldap._tcp.dc._msdcs.$DomainFqdn" -Type SRV -ErrorAction Stop | Where-Object { $_.Type -eq 'SRV' })
    Add-Result -Test 'DNS-LDAP-SRV' -OK ($records.Count -gt 0) -Info "$($records.Count) SRV-Einträge"
} catch {
    Add-Result -Test 'DNS-LDAP-SRV' -OK $false -Info $_.Exception.Message
}

if (-not [string]::IsNullOrWhiteSpace($FileServer)) {
    try {
        $port = Test-NetConnection -ComputerName $FileServer -Port 445 -InformationLevel Quiet -WarningAction SilentlyContinue -ErrorAction Stop
        Add-Result -Test 'SMB-TCP-445' -OK ([bool]$port) -Info $FileServer
    } catch {
        Add-Result -Test 'SMB-TCP-445' -OK $false -Info $_.Exception.Message
    }
    if (-not [string]::IsNullOrWhiteSpace($ShareName)) {
        $unc = "\\$FileServer\$ShareName"
        try {
            Add-Result -Test 'SMB-Freigabe' -OK ([bool](Test-Path -LiteralPath $unc -ErrorAction Stop)) -Info $unc
        } catch {
            Add-Result -Test 'SMB-Freigabe' -OK $false -Info $_.Exception.Message
        }
    }
} elseif (-not [string]::IsNullOrWhiteSpace($ShareName)) {
    throw 'Bei -ShareName muss auch -FileServer angegeben werden.'
}
$results
if (@($results | Where-Object { -not $_.OK }).Count -gt 0) { exit 1 }
