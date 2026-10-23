<#
.SYNOPSIS
    Ordnet vorhandene AD-Konten vorhandenen Gruppen zu.
.EXAMPLE
    .\scripts\Add-LabGroupMembers.ps1 -CsvPath .\examples\group-members.example.csv -WhatIf
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
foreach ($field in @('SamAccountName','GroupName')) {
    if ($field -notin @($rows[0].PSObject.Properties.Name)) { throw "Spalte fehlt: $field" }
}

foreach ($row in $rows) {
    $sam = ([string]$row.SamAccountName).Trim()
    $groupName = ([string]$row.GroupName).Trim()
    if ($sam -notmatch '^[a-zA-Z][a-zA-Z0-9._-]{0,19}$' -or
        [string]::IsNullOrWhiteSpace($groupName)) {
        Write-Warning "Ungültige Gruppenzuordnung: $sam / $groupName"
        continue
    }
    try {
        $user = Get-ADUser -Identity $sam -Properties MemberOf -ErrorAction Stop
        $group = Get-ADGroup -Identity $groupName -ErrorAction Stop
        if (@($user.MemberOf) -contains $group.DistinguishedName) {
            [pscustomobject]@{Benutzer=$sam;Gruppe=$groupName;Status='Bereits Mitglied'}
            continue
        }
        if ($PSCmdlet.ShouldProcess("$sam -> $groupName",'Mitgliedschaft hinzufügen')) {
            Add-ADGroupMember -Identity $group.DistinguishedName -Members $user.DistinguishedName -ErrorAction Stop
            [pscustomobject]@{Benutzer=$sam;Gruppe=$groupName;Status='Hinzugefügt'}
        } else {
            [pscustomobject]@{Benutzer=$sam;Gruppe=$groupName;Status='Nicht ausgeführt (WhatIf/abgelehnt)'}
        }
    } catch {
        Write-Warning "Fehler bei $sam -> $groupName : $($_.Exception.Message)"
        [pscustomobject]@{Benutzer=$sam;Gruppe=$groupName;Status='Fehler'}
    }
}
