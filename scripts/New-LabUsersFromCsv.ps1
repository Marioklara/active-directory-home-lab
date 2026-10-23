<#
.SYNOPSIS
    Erstellt deaktivierte AD-Testkonten aus einer Semikolon-CSV.
.EXAMPLE
    .\scripts\New-LabUsersFromCsv.ps1 -CsvPath .\examples\users.example.csv -WhatIf
#>
[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]
param(
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]$CsvPath
)
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if (-not (Test-Path -LiteralPath $CsvPath -PathType Leaf)) {
    throw "CSV-Datei nicht vorhanden: $CsvPath"
}
Import-Module ActiveDirectory -ErrorAction Stop
$rows = @(Import-Csv -LiteralPath $CsvPath -Delimiter ';' -Encoding UTF8)
if ($rows.Count -eq 0) { throw 'CSV ohne Datenzeilen.' }
foreach ($field in @('SamAccountName','GivenName','Surname','Department','OU')) {
    if ($field -notin @($rows[0].PSObject.Properties.Name)) { throw "Spalte fehlt: $field" }
}

foreach ($row in $rows) {
    $sam = ([string]$row.SamAccountName).Trim()
    $given = ([string]$row.GivenName).Trim()
    $surname = ([string]$row.Surname).Trim()
    $department = ([string]$row.Department).Trim()
    $ou = ([string]$row.OU).Trim()
    if ($sam -notmatch '^[a-zA-Z][a-zA-Z0-9._-]{0,19}$' -or
        [string]::IsNullOrWhiteSpace($given) -or
        [string]::IsNullOrWhiteSpace($surname) -or
        [string]::IsNullOrWhiteSpace($ou)) {
        Write-Warning "Ungültige Zeile: $sam"
        [pscustomobject]@{Benutzer=$sam;Status='Ungültig'}
        continue
    }

    try {
        $target = Get-ADOrganizationalUnit -Identity $ou -ErrorAction Stop
        $existing = @(Get-ADUser -Filter "SamAccountName -eq '$sam'" -ErrorAction Stop)
        if ($existing.Count -gt 0) {
            [pscustomobject]@{Benutzer=$sam;Status='Bereits vorhanden'}
            continue
        }

        if ($PSCmdlet.ShouldProcess($sam,"Deaktiviertes Konto in $($target.DistinguishedName) anlegen")) {
            $newUser = @{
                Name = "$given $surname"
                DisplayName = "$given $surname"
                GivenName = $given
                Surname = $surname
                Department = $department
                SamAccountName = $sam
                Path = $target.DistinguishedName
                Enabled = $false
                ErrorAction = 'Stop'
            }
            New-ADUser @newUser
            [pscustomobject]@{Benutzer=$sam;Status='Deaktiviert erstellt'}
        } else {
            [pscustomobject]@{Benutzer=$sam;Status='Nicht ausgeführt (WhatIf/abgelehnt)'}
        }
    } catch {
        Write-Warning "Fehler bei $sam : $($_.Exception.Message)"
        [pscustomobject]@{Benutzer=$sam;Status='Fehler'}
    }
}
