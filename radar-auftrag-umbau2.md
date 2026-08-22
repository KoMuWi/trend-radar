# Einmal-Auftrag: Trend-Radar UMBAU II — Regeln + komplettes Redesign (Beschluss Mark, 22.08.2026)

Du bist der Trend-Radar-Agent. Unbeaufsichtigter Lauf im Repo mit `trend-radar.html` (Dashboard, vollständig selbst-enthalten, 4 Tabs, `const DATA` eingebettet) und `trend-radar-state.json`. **Kein Recherche-Lauf**: keine Websuche, keine neuen Scores, Messpunkte oder Belege. Zwei Aufgaben: (A) Regel-/Struktur-Umbau, (B) komplettes visuelles Redesign.

**Arbeite effizient: CSS zentral im `<style>`-Block umbauen (wenige große Edits), nicht Element für Element.**

## A. Regel- und Struktur-Umbau

1. **„Top-3-Kandidaten" wird „Top-Chancen (max. 5)".** Alle fünf aktuellen Kandidaten sind Voll-Kandidaten: Whimsy-Deko (21), Frucht-Charms (20), Jelly-Schmuck (19), Broschen (19), Wilderkind (19). Die „Slot offen"-Karte entfällt (Liste ist 5/5 voll). Für Jelly, Broschen und Wilderkind gilt dieselbe ehrliche Behandlung wie bei Frucht-Charms: noch nicht erhobene Voll-Bewertungsteile (Ampel-Rohwerte, Werbedruck, Review-Referenzen) NICHT erfinden, sondern als „folgt im nächsten Voll-Update (07.09.2026)" kennzeichnen, mit knapper Lesehilfe.
2. **Beobachtungsliste danach:** Poetcore (18), Charm-Halsketten (17), Fidget-/Wellness-Schmuck (15). Discovery unverändert (Textur-/Fell-Charms 1/2, Glamoratti ohne Score).
3. **Methodik-Tab — drei Regeländerungen dokumentieren (mit Datum „Beschluss Gründer/Mark 22.08.2026"):**
   - **Top-Chancen statt Top-3:** max. 5 Plätze; Aufnahme rein regelbasiert (Aufstiegsregel 2/2 unverändert). Ist die Liste voll (5/5), entscheidet die Gründer-Runde über Rotation (Team-Entscheid bleibt); Verwerfungsregel (Momentum ≤ 2 in drei Voll-Updates) unverändert.
   - **NEU „Muster-Deckel":** maximal 1–2 aktive Muster-Projekte parallel — die Kapazitätsgrenze liegt auf den Wetten, nicht auf der Liste. Muster-Regel selbst unverändert (Score ≥ 21 + Ampel 4× Ja in zwei aufeinanderfolgenden Voll-Updates + Rechte-Check + Team-Freigabe).
   - **NEU „Aufstiegs-Vorbereitung":** Erreicht ein Beobachtungs-Kandidat erstmals Voll-Score ≥ 19 (Aufstieg 1/2), erheben die folgenden Voll-Läufe seine Voll-Bewertungsteile im Hintergrund mit (komplette Signalkette, Referenz-Listings fixieren, Werbedruck-Basislinie). Speicherung im Datenstand (state.json, Feld `prep`), im Dashboard erst ab Aufstieg sichtbar. Zweck: kein Datenloch mehr beim Aufstieg.
4. **„Diese Woche"-Box:** kurzer Vermerk zum Regel-Umbau (max. 5 statt 3, Muster-Deckel, Aufstiegs-Vorbereitung; alle drei 19er aufgenommen — keine Slot-Wahl am 26.08. mehr nötig, stattdessen Muster-/Pilot-Diskussion).
5. **Stand-Zeile:** „22.08.2026 (Umbau II, v14)". `trend-radar-state.json` auf v14 nachziehen: Struktur `top` (5 Einträge), `watch`, leeres Feld `prep` anlegen, streaks/chain konsistent. Radar-Bilanz unangetastet (Fälligkeiten 31.08./07.09. inkl. Vermerke bleiben).

## B. Redesign „Industrial Blueprint" (Marks persönlicher Stil, wie seine PowerPoints)

Gesamten Look des Dashboards auf diese Design-Sprache umstellen — Farben, Typografie, Karten, Header. Ein einheitlicher heller Look; falls Dark-Mode-Styles (`prefers-color-scheme`) existieren: entfernen, es gibt bewusst nur dieses eine Design.

**Farben (Hex):**
- Seiten-Hintergrund: `#EAF1FA` · Haupttext: `#15325C` · gedämpfter Text: `#4A6FA5`
- Karten: `#FFFFFF` mit 1px Rahmen `#BBD3EE`, Ecken ~10–14px gerundet, KEINE einseitigen Farbbalken/Akzentstreifen, keine Verläufe
- Akzent (Scores, Badges, Zahlen, Links, aktive Tabs, Highlights): Orange `#FF7A00`
- Dunkle Flächen (nur Seiten-Header): `#0F3460`, darauf Text `#FFFFFF` / gedämpft `#BBD3EE`, feines Rasternetz aus 0.5px-Linien `#184A82` und vier kleine L-förmige Eckmarken in Orange (1.5px) — wie Registriermarken einer technischen Zeichnung
- Ampel-/Status-Semantik (grün/gelb/rot) darf für Ampeln und Trends erhalten bleiben, sparsam

**Typografie:**
- Fließtext/Überschriften: `Calibri, 'Segoe UI', system-ui, sans-serif`
- Zahlen, Scores, Labels, Kicker-Zeilen, Badges: `'Courier New', monospace`, gern in eckigen Klammern als technische Annotation, z. B. `[21]`, `[2/4]`, `[v14]`
- Seiten-Header: Kicker-Zeile in Courier/Orange/Versalien („TREND-RADAR · WEBSHOP-PROJEKT"), Titel groß/bold/weiß, Meta-Zeile in `#BBD3EE`

**Pflicht-Fix Signalkette (aktueller Design-Fehler, von Mark gemeldet):** Die Stations-Beschreibungen der Signalkette laufen über ihre Zeile/Spalte hinaus. Neu bauen als robustes Grid: jede Station eine gleichbreite Spalte, Beschreibungstext MUSS innerhalb der Spalte umbrechen (`overflow-wrap: anywhere; hyphens: auto`), Spaltenhöhe flexibel — nichts darf horizontal über Nachbarspalten oder den Kartenrand laufen. Auf schmalen Bildschirmen (< ~640px) die Kette vertikal untereinander. Nach dem Umbau gedanklich mit dem längsten vorhandenen Stationstext prüfen (z. B. die SEA-Erklärung bei Whimsy).

**Responsive:** Handy-Nutzung ist der Hauptanwendungsfall der Mitgründer — alle Breiten von 360px bis Desktop müssen sauber laufen (Karten stapeln, Tabellen/Ketten umbrechen oder scrollen im eigenen Container).

**Score-Verlauf (SVG-Chart):** Linienfarben auf die Palette umstellen (Orange für den Spitzenkandidaten, sonst Blautöne `#15325C`/`#4A6FA5`/`#BBD3EE`-Abstufungen), Gitterlinien dezent `#BBD3EE`, Achsentext Courier.

## C. Technik & Ehrlichkeit (wie immer)

- HTML bleibt vollständig selbst-enthalten (kein CDN, keine externen Fonts/Requests — Calibri/Courier New sind Systemschriften mit Fallbacks), UTF-8, 4-Tab-Aufbau bleibt.
- Keine Inhalte löschen — Archiv-Tab und Radar-Bilanz vollständig erhalten.
- Nicht verschlüsseln, nicht committen, nicht pushen — macht das Skript.
- Ändere ausschließlich `trend-radar.html`, `trend-radar-state.json`, `logs/last-run-summary.txt`.
- Abschluss: `logs/last-run-summary.txt` mit 5–10 Zeilen (was umgebaut, welche Regeln neu, was am Design geändert, was offen/nicht machbar war).
