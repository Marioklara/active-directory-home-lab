# Fehleranalyse: erst Ursache, dann Lösung

## Domänenanmeldung schlägt fehl

Erst Netzwerk, DNS und Zeit prüfen:

~~~powershell
ipconfig /all
nslookup -type=SRV _ldap._tcp.dc._msdcs.firma.local
w32tm /query /status
~~~

Windows-Clients in AD brauchen den richtigen AD-DNS-Server. Nach einer Korrektur erneut testen und Ergebnis dokumentieren.

## GPO greift nicht

~~~powershell
gpupdate /force
gpresult /r
New-Item -ItemType Directory -Path C:\Temp -Force
gpresult /h C:\Temp\gpo.html
~~~

OU-Verknüpfung, Benutzer-/Computerkonfiguration, Sicherheitsfilterung und Ereignisprotokolle prüfen.

## SMB-Freigabe nicht erreichbar

~~~powershell
Test-NetConnection FILESERVER -Port 445
whoami /groups
~~~

Datei-Freigaberechte und NTFS-Berechtigungen **beide** prüfen. Kein pauschales Everyone/Full-Control. Vergleich mit erlaubtem und abgelehntem Testbenutzer dokumentieren.

## RDP: Zugriff verweigert

Die PDF dokumentiert einen verweigerten RDP-Zugriff. Prüfen: RDP am Zielsystem aktiviert? Netzwerk und TCP 3389 erreichbar? Firewall-Regeln? Erlaubnis zur Anmeldung via RDP (lokale Gruppe oder Richtlinie)? Benutzerrecht per GPO verweigert?

Nur berechtigte Testkonten erlauben. Nicht pauschal Administratorrechte vergeben. Der RDP-Zugriff auf Domain Controller ist besonders restriktiv zu behandeln.

## Lab-Health-Check

~~~powershell
.\scripts\Test-LabHealth.ps1 -DomainFqdn firma.local
~~~

Der Check ist read-only und kein vollständiger AD-Audit.
