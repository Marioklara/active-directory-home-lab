# Testplan und Nachweise

## Bereits in der ursprünglichen PDF dokumentiert

| Funktion | PDF | Status |
| --- | --- | --- |
| Hyper-V, AD-Server, Client, Fileserver | S. 2 | dokumentiert |
| OUs, Benutzer, Gruppen | S. 3–4 | dokumentiert |
| Freigabe und NTFS-Zugriff | S. 5–6 | dokumentiert und Zugriff getestet |
| DNS-Forwarder und DHCP-Scope | S. 7–8 | Konfiguration dokumentiert |
| Systemsteuerung per GPO blockiert | S. 9 | am Client getestet |
| Entra ID | S. 10 | nur Grundlagen |
| RDP | S. 6 | Zugriff verweigert; kein erfolgreicher Fix belegt |

## Neue Tests: noch auf eigenen VMs ausführen

| ID | Prüfschritt | Erwartung | Ist / Datum |
| --- | --- | --- | --- |
| T01 | dcdiag /q auf DC | keine relevanten Fehler | offen |
| T02 | Resolve-DnsName -Type SRV _ldap._tcp.dc._msdcs.firma.local | SRV-Einträge vorhanden | offen |
| T03 | ipconfig /all am Client | AD-DNS-Server eingetragen | offen |
| T04 | gpresult /r und gpresult /h | richtige GPO übernommen | offen |
| T05 | whoami /groups | passende AD-Gruppen | offen |
| T06 | SMB-Zugriff: berechtigtes/unberechtigtes Konto | Zugriff erlaubt / verweigert | offen |
| T07 | New-LabUsersFromCsv.ps1 -WhatIf | keine Kontoänderung | offen |
| T08 | CSV-Import zweimal ausführen | kein Duplikat, Konto deaktiviert | offen |
| T09 | Add-LabGroupMembers.ps1 zweimal | zweite Ausführung erkennt Mitgliedschaft | offen |
| T10 | Enable-LabUser.ps1 | sicher aktiviert, Passwortwechsel verlangt | offen |
| T11 | Test-LabHealth.ps1 | erfolgreiche AD/DNS-Checks | offen |
| T12 | RDP mit autorisiertem Testbenutzer | erfolgreich, unberechtigter abgewiesen | offen |
| T13 | Backup/Restore separat testen | dokumentierte Wiederherstellung | offen |
| T14 | Windows LAPS auf Testclient | Rotation und Berechtigungen nachgewiesen | offen |

Pro Test Datum, VM, Befehl, erwartete und tatsächliche Ausgabe sowie anonymisierte Beweise dokumentieren. Der GitHub-CI-Test führt keine echten AD-Aufgaben aus.
