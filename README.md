# Trend-Radar (passwortgeschützt)

Wöchentliches Trend-Dashboard unseres E-Commerce-Projekts, gehostet auf GitHub Pages:
**https://komuwi.github.io/trend-radar/**

## Wie der Passwortschutz funktioniert

GitHub Pages ist öffentlich — deshalb liegt hier **niemals das Dashboard im Klartext**, sondern nur `index.html`: eine verschlüsselte Version (PBKDF2-SHA256 mit 600.000 Iterationen + AES-256-GCM). Die Entschlüsselung passiert komplett im Browser (WebCrypto), nachdem das Team-Passwort eingegeben wurde. Mit „auf diesem Gerät merken" bleibt man angemeldet (Schlüssel im localStorage). Ohne Passwort ist der Inhalt kryptografisch unlesbar.

## Wöchentliches Update (Windows)

1. Neue `trend-radar.html` aus Cowork in den Downloads-Ordner speichern.
2. In diesem Ordner ausführen:
   ```powershell
   .\update.ps1
   ```
   (zieht automatisch die neueste `trend-radar*.html` aus Downloads; alternativ Pfad angeben)
3. Passwort eingeben → verschlüsseln, committen, pushen passiert automatisch. Nach 1–2 Minuten ist die neue Version online.

## ⚠️ Regeln

- **NIEMALS `trend-radar.html` (Klartext) committen** — die `.gitignore` verhindert das, nicht aushebeln.
- Das Passwort steht in keiner Datei und gehört in keine Datei. Es wird nur mündlich/direkt im Team geteilt.
- `trend-radar-state.json` ist nur lokale Sicherung, gehört nicht ins Repo.
