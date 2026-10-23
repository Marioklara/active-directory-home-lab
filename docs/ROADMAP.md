# Lern-Roadmap für Junior-Systemadministration

## Phase 1: Bestand

- [x] AD, DNS, DHCP und Dateifreigaben im PDF dokumentiert
- [x] Erste GPO getestet
- [ ] RDP-Fehler reproduzieren und Lösung testen
- [ ] VM-IPs, Betriebssystemstände und Testprotokolle ergänzen

## Phase 2: PowerShell

- [x] Benutzeranlage mit deaktivierten Konten als Skript bereitgestellt
- [x] Gruppenmitgliedschaft und sicheres Onboarding als Skripte bereitgestellt
- [x] Einfacher read-only AD-/DNS-Check bereitgestellt
- [ ] Alle Skripte zuerst mit -WhatIf, dann auf eigenen VMs testen
- [ ] Doppelte CSV-Einträge, nicht vorhandene OU/Gruppe und nicht erlaubte Zugriffe testen

## Phase 3: Sicherheit und Betrieb

- [ ] AGDLP für reale Testfreigabe umsetzen
- [ ] USB-, Laufwerkszuordnung- und Firewall-GPOs als Testfälle dokumentieren
- [ ] Windows LAPS auf einem Testclient einrichten
- [ ] System-State-Backup und Restore nachweisen

## Phase 4: Cloud

- [x] Entra Admin Center als erste Übung dokumentiert
- [ ] Entra-Gruppen, MFA und Conditional Access vertiefen
- [ ] Hybrid-Identity erst als getestet deklarieren, wenn der eigene Sync-Versuch erfolgreich nachgewiesen ist

[x] bedeutet in diesem Repository **dokumentiert oder als Skript vorhanden**, nicht automatisch live getestet.
