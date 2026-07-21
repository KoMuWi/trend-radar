# Trend-Radar (passwortgeschützt)

Wöchentliches Trend-Dashboard unseres E-Commerce-Projekts, gehostet auf GitHub Pages:
**https://komuwi.github.io/trend-radar/**

## Wie der Passwortschutz funktioniert

GitHub Pages ist öffentlich — deshalb liegt hier **niemals das Dashboard im Klartext**, sondern nur `index.html`: eine verschlüsselte Version (PBKDF2-SHA256 mit 600.000 Iterationen + AES-256-GCM). Die Entschlüsselung passiert komplett im Browser (WebCrypto), nachdem das Team-Passwort eingegeben wurde. Mit „auf diesem Gerät merken" bleibt man angemeldet (Schlüssel im localStorage). Ohne Passwort ist der Inhalt kryptografisch unlesbar.

## Updates laufen vollautomatisch

Der Windows-Taskplaner auf Marks Rechner startet `auto-update.ps1`:

- **Montags 7:30 — Voll-Update** (`-Mode voll`): Claude-CLI recherchiert nach der Methodik im Dashboard, aktualisiert `trend-radar.html` + `trend-radar-state.json`, dann wird verschlüsselt und gepusht.
- **Donnerstags 7:30 — Spike-Check** (`-Mode spike`): nur Momentum der Top 3; veröffentlicht nur bei Auffälligkeiten.
- PC aus zum Termin? Der Lauf wird automatisch nachgeholt, sobald der Rechner wieder an ist. Rückwirkende Datenpunkte werden dabei bewusst **nicht** erfunden — es zählt nur der echte Messzeitpunkt.
- Das Passwort liest das Skript aus dem **Windows Credential Manager** (einmalig hinterlegt per `setup-passwort.cmd`), es steht in keiner Datei.
- Protokoll: `logs\auto-update.log`, Kurzbericht des letzten Laufs: `logs\last-run-summary.txt`.

### Manuelles Update (Fallback)

1. Neue `trend-radar.html` (z. B. aus Cowork) in den Downloads-Ordner speichern.
2. Doppelklick auf `update.cmd` (zieht automatisch die neueste `trend-radar*.html` aus Downloads).
3. Passwort eingeben → verschlüsseln, committen, pushen. Nach 1–2 Minuten online.

## ⚠️ Regeln

- **NIEMALS `trend-radar.html` (Klartext) committen** — die `.gitignore` verhindert das, nicht aushebeln.
- Das Passwort steht in keiner Datei und gehört in keine Datei. Es wird nur mündlich/direkt im Team geteilt.
- `trend-radar-state.json` ist nur lokale Sicherung, gehört nicht ins Repo.
