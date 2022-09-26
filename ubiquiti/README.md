# Ubiquiti Firmeware Flasher
## Einleitung
Dieses Script dient zur automatisierten Installation der Gluon-Firmware auf Ubiquiti APs. Es vereint die Prüfung von Modellen auf Kompatibilität sowie das Flashen der Software mit Hinblick auf die zuletzt durch Ubiquiti eingeführten Schreibsperre des internen Speichers.

## Unterstützte Geräte
Folgende Modelle werden derzeit unterstützt:

* AP-AC Pro

Eine Erweiterung auf andere Modelle ist jederzeit möglich, da der grundsätzliche Installationsprozess bei allen Geräten der gleiche ist.

## Voraussetzungen
Vor Benutzung des Scripts muss sichergestellt sein, dass das betroffene Gerät über Ethernet mit dem Rechner verbunden ist und das zugehörige Interface auf eine IP im Bereich `192.168.1.0/24` eingestellt ist. Dabei wird die IP `192.168.1.20` vom Accesspoint selbst belegt. Diese IP kann also nicht verwendet werden.

Ebenso muss sichergestellt sein, dass das betroffene Gerät bisher in keinem Ubiquiti-Netzwerk über einen Controller (Software, Cloud-Key etc.) eingebunden war. Andernfalls ist zuerst ein Reset des Gerätes auf Werkseinstellungen notwendig.

Das Script prüft vor dem Flashprozess, ob die erforderlichen Pakete `wget` und `sshpass` lokal installiert sind.

## Benutzung
Das Script führt den Benutzer interaktiv durch den Prozess und gibt Anweisungen, wann was genau zu tun ist. Der gesamte Prozess ist dabei wir folgt aufgebaut:

* Warten auf Antwort der IP-Adresse des Gerätes
* Identifizierung des Modells und Prüfung auf Unterstützung
* Auswahl der passenden Firmware
* Prüfung auf Schreibblockade mit etwaiger Entsperrung des Flashspeichers
* Schreiben der Firmware in die Speicherblöcke
* Neustart des Gerätes

Sollte der Flashprozess - aus welchem Grund auf immer - unterbrochen werden, kann mittels der TFTP-Anleitung von Ubiquiti die original Firmware jederzeit wiederhergestellt werden:

https://help.ui.com/hc/en-us/articles/204910124-UniFi-Network-Leveraging-TFTP-Recovery-Advanced-Users-Only-

Das Script wurde bisher unter MacOS X getestet, sollte jedoch auch mit jedem Linux-System kompatibel sein.

## Abschließende Bemerkungen
Dieses Script lebt - genau wie das Freifunk-Projekt - von der Mitarbeit der Community. Sollten Verbesserungen und/oder Anpassungen durch Dritte erfolgen wäre es angebracht, das Projekt nicht nur zu forken sondern auch PRs zu eröffnen, damit jeder, welcher sich dieses Script herunterlädt, davon profitieren kann.