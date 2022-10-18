# wifi
## Übersicht
Dieses Script ermöglich die Umstellung der Funkkanäle auf einzelnen Knoten. Dadurch lassen sich separate Mesh-Netzwerke in unmittelbarer Umgebung erstellen und somit die allgemeine Airtime im Funknetz reduzieren.

## Anleitung
Vor Benutzung müssen die Funkkanäle bzw. Variablen im Skript selber angepasst werden:
* `2_4GHZCHANNEL`: Kanal für das 2,4GHz Netz
* `5GHZCHANNEL`: Kanal für das 5GHz Netz

Danach muss das Script via scp auf den entsprechenden Node hochgeladen und einmalig ausgeführt werden.

**Wichtig: Es muss stets ein Mesh-on-Lan Knoten mit dem gleichen Funkkanal für die restlichen Knoten verfügbar sein, da sonst der Zugriff via SSH zu der restlichen Funkkette abgetrennt wird. Idealerweise ändert man die Funkkanäle auf dem entferntesten Knoten zuerst und endet am Knoten mit Kabelanbindung.**

## Hinweise
Nach Änderung der Funkkanäle kann es - je nach Größe des Meshes - einige Zeit dauern, bis die Knoten untereinander ihr Routing neu ausgehandelt haben. Während dieser Zeit ist ein SSH-Zugriff auf diese Geräte zeitweise unter Umständen eingeschränkt.

Als Funkkanäle für das 2,4GHz Netz werden die überlappungsfreien Kanäle 1,6 und 11 empfohlen. Im 5GHz Netz die Kanäle 36,40,44 und 48. Kanäle oberhalb von 48 werden auf Grund etwaiger Einschränkung durch DFS <span style="text-decoration:underline">nicht</span> empfholen.