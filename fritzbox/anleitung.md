# Flashen einer FritzBox 4040

Diese Anleitung wurde von https://wiki.bremen.freifunk.net/Anleitungen/Firmware/Flashen-FritzBox-4040 kopiert und für Freifunk KBU adaptiert.

Die folgenden Infos wurden aus verschiedenen Foren etc. zusammengetragen und sind mit Stand 12/2020 geprüft.

Anzumerken ist: Das Flashen einer FritzBox ist nichts für Anfänger. Bitte informiert euch bei Leuten, die bereits die 4040 geflasht haben. Kommt gerne auf eines unserer Treffen, auch per Videokonferenz, dort sind immer ein paar flashen dabei.

Eine Anleitung aus den Erfahrungen aus 12/2020 ausgeführt mit Linux:

-  Firmware herunterladen: http://images.kbu.freifunk.net/multihood/stable/other/Diese Datei Verwenden: http://images.kbu.freifunk.net/multihood/stable/other/gluon-ffkbu-v2021.1.2-Wireguard-avm-fritz-box-4040-bootloader.bin 
-  Python3-Skript aus diesem Repo verwenden
-  beide Dateien im selben Verzeichnis ablegen.
-  WLAN am PC abschalten
-  LAN-Schnittstelle des PC auf feste IP einstellen: 192.168.178.2 Subnetzmaske: 255.255.255.0 Gateway: 192.168.178.1
-  PC per LAN-Kabel mit der FritzBox (LAN 1) verbinden.
-  Verzeichnis mit den beiden Dateien im Terminal öffnen.
-  Befehl eingeben: `python3 fritzflash.py` und  Enter drücken
-  FritzBox ans Stromnetz anschließen.
-  Wenn alle Lampen aufleuchten nochmals Enter
-  Anweisung im Terminal folgen.
-  LAN-Schnittstelle des PC auf DHCP zurückstellen.
-  Warten bis LAN wider aktiv ist dann 192.168.1.1 aufrufen.
-  Den Router im Browser Webinterface einrichten (wie bei allen neuen Knoten).

# Konfigurationsmodus/Fritzbox 4040

Der Konfigurationsmodus der FB 4040 wir wie folgt erreicht: Im normalen Betrieb die WPS-Taste drücken; nach ca. 10-15 Sekunden (Sobald einmal alle Lampen aufleuchten loslassen ) daraufhin erfolgt ein Reset des Routers und ein neustart im Konfigurationsmodus.

Der Router darf dabei nicht vom Strom getrennt werden.
