# Sicherheit, Windows LAPS und Wiederherstellung

## Sicherheit im Lab

- Getrennte Admin- und Alltagskonten üben, Rechte minimal halten.
- Windows-Updates, Firewall-Regeln und relevante Ereignisprotokolle prüfen.
- SMB und RDP niemals direkt zum Internet öffnen; Remote-Admin-Zugang absichern.
- Keine Kennwörter, Kennwort-Exporte, Token oder echten Benutzerdaten nach GitHub laden.

## Windows LAPS (noch nicht eingerichtet)

Windows LAPS verwaltet individuelle lokale Administratorpasswörter auf unterstützten Geräten. Zuerst Updates, OS-Versionen, Domänenfunktionsebene und Rechte prüfen. Die AD-Schemaerweiterung ist eine Änderung an der Gesamtstruktur und muss bewusst geplant werden; **nicht** blind Update-LapsADSchema ausführen.

Übungsablauf:
1. Anforderungen anhand [Microsoft Learn: Windows LAPS und lokales AD](https://learn.microsoft.com/de-de/windows-server/identity/laps/laps-scenarios-windows-server-active-directory) prüfen.
2. Backup und AD-Berechtigungen dokumentieren.
3. Nur auf isolierter Test-OU / Testclient geeignete Richtlinien anwenden.
4. Rotation und nur autorisierten Passwortzugriff nachweisen, Kennwörter nie im Screenshot zeigen.
5. Bei älteren Domänenfunktionsebenen Einschränkungen der LAPS-Verschlüsselung beachten.

## Backup und Restore (noch nicht nachgewiesen)

- Geeignete **System-State-Sicherung** für Domain Controller einrichten; Fileserver-Daten separat sichern.
- Sicherungszeitpunkt, Ziel, Ergebnis und Restore-Ablauf dokumentieren.
- Wiederherstellung nur in **isolierter Testumgebung** ausprobieren.
- Hyper-V-Checkpoints sind kein Ersatz für konsistentes AD-Backup.
- Domain Controller niemals leichtfertig aus einem alten Snapshot in eine laufende Domäne zurücksetzen.

## Für das Portfolio

Vorher/Nachher-Screenshots, Problemursache, einzelne Änderung, Negativtest, Wiederherstellung und Ergebnis als eigene Tests dokumentieren. Nichts als erfolgreich kennzeichnen, bevor es tatsächlich geprüft ist.
