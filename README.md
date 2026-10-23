# Active Directory Home Lab

Praxisprojekt zur Windows-Server-Systemadministration und zum IT-Support.
Die [originale PDF-Dokumentation](Active-Directory-Home-Lab.pdf) beschreibt ein Hyper-V-Lab mit Domain Controller, Windows-Client und Fileserver.

## Bereits dokumentiert

- Hyper-V: AD-Server, Client und Fileserver im internen LabNAT
- Active Directory: Domain firma.local, OUs IT/Personal/Verwaltung, Benutzer und Gruppen
- DNS: DNS-Forwarder; DHCP: Pool 192.168.50.100 bis 192.168.50.200 und Reservierung
- Dateiserver: SMB-Freigabe und NTFS-Rechte; Testzugriff am Client
- Gruppenrichtlinien: Systemsteuerung in Test-OU gesperrt, erfolgreich am Client getestet
- Microsoft Entra ID: Einführung im Admin Center, keine nachgewiesene Hybrid-Synchronisation
- RDP: Zugriff wurde verweigert; erfolgreiche Fehlerbehebung bislang nicht dokumentiert

### Vereinfachter Aufbau

~~~text
Hyper-V-Host
  |
  +-- Internes LabNAT
        |-- AD-Server (AD DS / DNS / DHCP)
        |-- Fileserver (SMB / NTFS)
        +-- Windows-Client (Domain Join / GPO-Test)
~~~

Die vollständigen IP-Adressen und Windows-Builds sind in der PDF nicht belegt; deshalb werden hier keine erfunden.

## Neue PowerShell-Übungen

| Datei | Zweck | Sicherheitsprinzip |
| --- | --- | --- |
| [New-LabUsersFromCsv.ps1](scripts/New-LabUsersFromCsv.ps1) | AD-Benutzer aus CSV anlegen | Konten bleiben deaktiviert; -WhatIf |
| [Add-LabGroupMembers.ps1](scripts/Add-LabGroupMembers.ps1) | Vorhandene Benutzer AD-Gruppen zuordnen | Prüft direkte Mitgliedschaft; -WhatIf |
| [Enable-LabUser.ps1](scripts/Enable-LabUser.ps1) | Individuelles Kennwort vergeben und Konto aktivieren | SecureString statt Passwortdatei; -WhatIf |
| [Test-LabHealth.ps1](scripts/Test-LabHealth.ps1) | AD und DNS, optional SMB prüfen | Schreibgeschützt |

### Nutzung

Voraussetzungen: isolierte Lab-Domäne, Windows PowerShell 5.1, RSAT/ActiveDirectory-Modul, passende Berechtigungen. Beispiel-OUs und Gruppen müssen tatsächlich existieren oder in den CSV-Beispielen angepasst werden. Auf produktiven Systemen nicht ungeprüft ausführen.

~~~powershell
# 1. Nur simulieren (keine Benutzeranlage)
.\scripts\New-LabUsersFromCsv.ps1 -CsvPath .\examples\users.example.csv -WhatIf

# 2. Nach Prüfung deaktivierte Benutzer anlegen
.\scripts\New-LabUsersFromCsv.ps1 -CsvPath .\examples\users.example.csv

# 3. Gruppen-Mitgliedschaften simulieren
.\scripts\Add-LabGroupMembers.ps1 -CsvPath .\examples\group-members.example.csv -WhatIf

# 4. Passwort interaktiv festlegen und Konto aktivieren
.\scripts\Enable-LabUser.ps1 -SamAccountName lab.max -WhatIf
.\scripts\Enable-LabUser.ps1 -SamAccountName lab.max

# 5. Zustand lesen (ohne Änderungen)
.\scripts\Test-LabHealth.ps1 -DomainFqdn firma.local
~~~

Die CSV-Beispiele enthalten ausschließlich fiktive Demo-Benutzer und keine Passwörter.

## Weitere Dokumentation

- [Architektur und Voraussetzungen](docs/ARCHITEKTUR.md)
- [Testplan und Ergebnisse](docs/TESTPLAN.md)
- [Fehlersuche: DNS, GPO, SMB und RDP](docs/TROUBLESHOOTING.md)
- [Windows LAPS, Sicherheitsmaßnahmen und Backups](docs/SICHERHEIT-UND-BACKUP.md)
- [Nächste Lernschritte](docs/ROADMAP.md)

## Status und Grenzen

Der GitHub-Actions-Workflow prüft die **PowerShell-Syntax, CSV-Kopfzeilen und Links**. Er führt keine Skripte gegen Active Directory aus. Neue Funktionen sind erst dann als in der VM getestet zu markieren, wenn Ergebnisse protokolliert sind. Niemals echte Benutzerlisten, Zugangsdaten oder unbereinigte Logs veröffentlichen.
