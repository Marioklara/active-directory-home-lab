# Architektur und Voraussetzungen

## Ausgangslage aus der PDF

- Hyper-V mit drei Rollen: AD-Server, Windows-Client, Fileserver
- Internes virtuelles Netzwerk LabNAT
- Domäne firma.local mit OUs IT, Verwaltung und Personal
- DHCP-Pool 192.168.50.100–200 und DNS-Weiterleitungen
- SMB-/NTFS-Berechtigungen sowie erfolgreich getestete Sperr-GPO

Unbekannt bzw. nicht nachgewiesen: feste VM-IP-Adressen, exakte Windows-Builds, Firewall-Regeln, Domänenfunktionsebene, AD-Backup und Restore. Keine Produktionsumgebung wird hier vorausgesetzt.

## Vorbereitung

1. Das Projekt in einer isolierten Lab-Umgebung nutzen; Windows PowerShell 5.1 und das ActiveDirectory-Modul installieren.
2. Domain-Join, DNS-Auflösung und Admin-Berechtigungen prüfen.
3. CSV-Dateien an die tatsächlichen OU-DNs und Gruppennamen anpassen.
4. Änderungen mit -WhatIf simulieren; erst danach bewusst ausführen.
5. Positiv- und Negativtests im [Testplan](TESTPLAN.md) festhalten.

## AGDLP-Übung (noch offen)

Account -> Global Group -> Domain Local Group -> Permissions.
Beispiel: Testbenutzer -> GG_Verwaltung -> DL_FS_Verwaltung_Read -> NTFS-Leserechte.

Die ursprüngliche PDF zeigt das Gruppenprinzip, aber kein vollständig getestetes AGDLP-Modell. Neue Domain-Local-Gruppen und Rechte daher nur nach separater Freigabe anlegen.
