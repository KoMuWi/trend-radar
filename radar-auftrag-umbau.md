# Einmal-Auftrag: Trend-Radar UMBAU (Portfolio-Bereinigung für Gründer-Runde 26.08.2026)

Du bist der Trend-Radar-Agent. Du arbeitest unbeaufsichtigt im Repo mit `trend-radar.html` (Dashboard, vollständig selbst-enthalten, 4 Tabs, Datenstand als `const DATA` eingebettet) und `trend-radar-state.json`.

**Das ist KEIN Recherche-Update.** Keine Websuche nötig, keine neuen Scores, keine neuen Messpunkte — nur Umbau der Kandidatenlisten auf Beschluss von Mark (22.08.2026), damit die Gründer-Runde am Dienstag, 26.08.2026, eine aktuelle, zukunftsfähige Liste durchgehen kann.

## 1. Ins Produkt-Archiv verschieben (Status „geschlossen", Datum 22.08.2026, mit Grund)

- **Bag Charms** — Grund: „Standard-Fenster geschlossen (Score 21→17 seit 10.07., Presse: ‚wirkt 2026 veraltet'); Thema lebt als Charm-Halsketten weiter"
- **Pen-Pals-Stationery** — Grund: „DE-Nische in 4 Wochen gefüllt (≥10 spezialisierte Shops + Kaufland-/Amazon-Kategorien); Standard-Wachssiegel = geschlossener Fall; Differenzierungswinkel lebt als Poetcore weiter"
- **Mystic Outlands** — Grund: „4 Läufe ohne Produktbezug (Radar-Vorschlag vom 22.08., von Mark bestätigt)"
- **Blindbox** — Grund: „Momentum rückläufig (16→15), Pop-Mart-Wachstum unter Erwartung"
- **Utility** — Grund: „SS2026-Saison abgelaufen, AW2026 läuft in andere Richtung (slouchy/Wildleder/Fell), Score 15"

Im Archiv-Tab bleiben alle Score-Verläufe und Ereignisse dieser Kandidaten vollständig erhalten — **Umbau ist Verschieben, kein Löschen.**

## 2. Top-3 neu aufstellen

- **Whimsy-Deko (21)** — bleibt.
- **Frucht-Charms (20)** — steigt aus der Beobachtungsliste in die Top-3 auf (Aufstiegsregel 2/2 erfüllt, produktseitig belegt: Gucci/D&G/Chloé). Karte mit vollem Kandidaten-Detail wie bei den bisherigen Top-3 (vorhandene Daten nutzen, nichts erfinden — fehlende Voll-Bewertungs-Teile ehrlich als „folgt im nächsten Voll-Update" kennzeichnen).
- **Dritter Slot: OFFEN.** Als deutlich erkennbare „Slot offen — Team-Entscheidung am 26.08."-Karte darstellen, mit den drei punktgleichen Anwärtern: **Jelly-Schmuck (19), Broschen (19), Wilderkind (19)** — alle Aufstiegsregel 2/2 erfüllt. Keine eigenmächtige Wahl treffen.

## 3. Beobachtungsliste danach

Jelly-Schmuck (19), Broschen (19), Wilderkind (19) — alle drei mit Kennzeichnung „aufstiegsberechtigt 2/2, zur Wahl am 26.08." — dazu Poetcore (18), Charm-Halsketten (17), Fidget-/Wellness-Schmuck (15). Discovery unverändert (Textur-/Fell-Charms 1/2, Glamoratti bewusst ohne Score).

## 4. Konsistenz & Ehrlichkeit

- **Radar-Bilanz:** Offene Backtest-Aussagen zu archivierten Kandidaten NICHT löschen — kennzeichnen mit „Kandidat archiviert, Abrechnung läuft weiter". Fällige Abrechnungen bleiben fällig.
- **„Diese Woche"-Box:** kurzer Vermerk, z. B.: „22.08. (Umbau): Portfolio für die Gründer-Runde am 26.08. bereinigt — 5 Kandidaten archiviert (Bag Charms, Pen-Pals, Mystic Outlands, Blindbox, Utility), Frucht-Charms in die Top-3 aufgestiegen, dritter Slot zur Team-Wahl (Jelly/Broschen/Wilderkind, je 19)."
- **Stand-Zeile** im Kopf: „22.08.2026 (Umbau, v13)" o. ä. — Versionszähler fortführen.
- `trend-radar-state.json` konsistent nachziehen (watch-, archive-, chain-, streaks-Strukturen entsprechend verschieben).
- Keine neuen Scores, Messpunkte oder Belege erfinden. Alle vorhandenen Daten der verschobenen Kandidaten bleiben im Archiv erhalten.
- HTML bleibt vollständig selbst-enthalten (keine externen Ressourcen), Struktur/Design/Tab-Aufbau beibehalten, UTF-8.
- **Nicht verschlüsseln, nicht committen, nicht pushen** — macht das Skript danach.
- Ändere ausschließlich `trend-radar.html`, `trend-radar-state.json` und `logs/last-run-summary.txt`.

## 5. Abschluss

`logs/last-run-summary.txt`: 5–10 Zeilen — was verschoben, was aufgestiegen, was offen geblieben ist, und ein Hinweis, falls etwas nicht sauber umsetzbar war.
