# Playable - A WiFi speaker conductor.

### ALLGEMEIN
Es gibt im Grossen und Ganzen nur zwei "Listen".
1. Liste möglicher Streaming-Dienste (TuneIn, iHeartRadio, Pandora, Spotify, Tidal, Napster, Deezer, Qobuz, etc., diese Liste wird zu Beginn erstmal nur TuneIn enthalten, als nächste Dienste würde ich dann Deezer und Spotify einbauen. Sie wird also sukzessive erweitert)
2. Liste aller im Netzwerk gefundener Lautsprecher

Generell werden die für Developer zugängigen APIs der Streaming-Dienste verwendet, da die meisten einen Account/Login benötigen. Ausgehend davon wird dann in Abhängigkeit der Möglichkeiten des jeweiligen API der Content der Streaming-Dienste dargestellt.

*Playable* ist eine Software, die **keine Musik** zu den Lautsprechern streamt! Das machen die Lautsprecher jeweils autark. *Playable* stellt in dem gesamten Zusammenspiel nur den "Dirigenten" dar. Es ist also eine Art Controller, der den Lautsprechern sagt, was sie tun sollen. Die Lautsprecher nehmen diese Anweisungen entgegen, und tun es dann.

### LAUTSPRECHER EINZELN
#### Auswahl und Streaming
In der Liste der Lautsprecher gibt es immer einen, der gerade den Fokus hat. Ich agiere also im Kontext des gerade ausgewählten Lautsprechers. Möchte ich z.B. über den Lautsprecher "Wohnzimmer" streamen, dann wähle ich zunächst "Wohnzimmer" in der Liste aus. Nun sollte es die Möglichkeit einer Auswahl aller der Streaming-Dienste geben, für die Login-Credentials hinterlegt sind, oder die evtl. ohne diese auskommen).

**Gedanken zum Bedienkonzept**: Bisher ist der Ausgangspunkt der Bedienung immer die Liste der Lautsprecher. Diese stehen im Zentrum. Wie wäre es aber, den Spiess einfach umzudrehen? Ausgangspunkt - und somit Zentrum des UI - sind die Streaming-Dienste und deren Content. Ich navigiere hier hin und her, wähle aus, was ich hören will, und sage dann nur noch, **wo** ich es hören möchte.  
*Was meinst du?*

### FUNKTIONSUEBERSICHT
1. Scannen des lokalen Netzwerkes nach evtl. vorhandenen Lautsprechern
2. Anzeige jedes gefundenen Lautsprechers mit seinem Namen