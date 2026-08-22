# Trend-Radar Auto-Update: Recherche (Claude CLI) -> verschluesseln -> pushen.
# Wird vom Windows-Taskplaner gestartet:  Mo 7:30 -Mode voll  |  Do 7:30 -Mode spike
param([ValidateSet("voll", "spike")][string]$Mode = "voll")

$ErrorActionPreference = "Stop"
$RepoDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $RepoDir
New-Item -ItemType Directory -Force "$RepoDir\logs" | Out-Null
$Log = "$RepoDir\logs\auto-update.log"

function Say($msg, $lvl) {
    if ($null -eq $lvl) { $lvl = "INFO" }
    $line = "{0} [{1}] [{2}] {3}" -f (Get-Date -Format "yyyy-MM-dd HH:mm:ss"), $lvl, $Mode, $msg
    for ($i = 0; $i -lt 5; $i++) {
        try { Add-Content -Path $Log -Value $line -Encoding utf8; break } catch { Start-Sleep -Milliseconds 400 }
    }
    Write-Host $line
}

function Popup($text) {
    # Sichtbare Meldung fuer Mark, ohne das Skript zu blockieren (eigener Prozess)
    $msg = $text -replace "'", "''"
    $cmd = "Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('$msg', 'Trend-Radar Auto-Update', 'OK', 'Warning') | Out-Null"
    Start-Process powershell -ArgumentList "-NoProfile", "-WindowStyle", "Hidden", "-Command", $cmd | Out-Null
}

# Nur ein Lauf gleichzeitig (Voll-Update und Spike-Check holen sich nach PC-Pause sonst beide zur selben Sekunde nach)
$mutex = New-Object System.Threading.Mutex($false, "Global\TrendRadarAutoUpdate")
$gotLock = $false
try {
    $gotLock = $mutex.WaitOne([TimeSpan]::FromMinutes(90))
    if (-not $gotLock) { Say "Anderer Lauf blockiert seit 90 Min - Abbruch." "ERROR"; exit 1 }

    Say "=== Lauf gestartet ==="

    # Werkzeuge auffinden (Taskplaner-Umgebung hat evtl. keinen frischen PATH)
    $Claude = "$env:USERPROFILE\.local\bin\claude.exe"
    if (-not (Test-Path $Claude)) { throw "claude.exe nicht gefunden: $Claude" }
    $env:Path = [Environment]::GetEnvironmentVariable('Path', 'Machine') + ';' + [Environment]::GetEnvironmentVariable('Path', 'User')
    $Python = (Get-Command python -ErrorAction Stop).Source
    Say "claude: $Claude | python: $Python"

    # Passwort zuerst pruefen - ohne Passwort gar nicht erst recherchieren
    . "$RepoDir\credman.ps1"
    $PW = [TrCredMan]::Read("trend-radar-passwort")
    if ([string]::IsNullOrEmpty($PW)) { throw "Kein Passwort im Credential Manager (setup-passwort.cmd ausfuehren!)" }

    # Login-Check vor der Recherche: abgelaufene CLI-Anmeldung sonst = stiller Dauerfehler
    $auth = ("Antworte nur mit: OK" | & $Claude -p --max-turns 1 2>&1 | Out-String)
    if ($LASTEXITCODE -ne 0 -or $auth -match "authenticate|login") {
        throw "Claude-CLI nicht angemeldet (Sitzung abgelaufen). Terminal oeffnen, 'claude' starten, '/login' eingeben - danach laeuft die Automatik wieder."
    }

    git pull --quiet 2>$null
    $hashVor = (Get-FileHash "$RepoDir\trend-radar.html" -Algorithm SHA256).Hash

    # Recherche-Lauf (unbeaufsichtigt, begrenzte Werkzeuge)
    $promptDatei = if ($Mode -eq "voll") { "radar-auftrag-voll.md" } else { "radar-auftrag-spike.md" }
    $prompt = Get-Content "$RepoDir\$promptDatei" -Raw -Encoding UTF8
    Say "Starte Claude-Recherche ($promptDatei) ..."
    $prompt | & $Claude -p --allowedTools "WebSearch,WebFetch,Read,Write,Edit,Glob,Grep" --permission-mode acceptEdits --max-turns 120 | Out-File "$RepoDir\logs\claude-output.txt" -Encoding utf8
    if ($LASTEXITCODE -ne 0) { throw "Claude-Lauf fehlgeschlagen (Exit $LASTEXITCODE) - siehe logs\claude-output.txt" }

    $hashNach = (Get-FileHash "$RepoDir\trend-radar.html" -Algorithm SHA256).Hash
    $geaendert = ($hashVor -ne $hashNach)

    if ($Mode -eq "spike" -and -not $geaendert) {
        Say "Spike-Check ohne Auffaelligkeiten - nichts zu veroeffentlichen. Fertig."
        exit 0
    }
    if ($Mode -eq "voll" -and -not $geaendert) {
        throw "Voll-Update hat trend-radar.html nicht veraendert - Recherche vermutlich fehlgeschlagen. Nichts veroeffentlicht."
    }

    # Plausibilitaet der neuen Datei
    $html = Get-Content "$RepoDir\trend-radar.html" -Raw -Encoding UTF8
    if ($html.Length -lt 30000) { throw "Neue trend-radar.html verdaechtig klein ($($html.Length) Zeichen) - nichts veroeffentlicht." }
    if (([regex]::Matches($html, 'class="tab ')).Count + ([regex]::Matches($html, 'class="tab"')).Count -lt 4) { throw "Tabs unvollstaendig - nichts veroeffentlicht." }

    # Verschluesseln + veroeffentlichen
    & $Python "$RepoDir\encrypt_page.py" "$RepoDir\trend-radar.html" "$RepoDir\index.html" "$PW"
    if ($LASTEXITCODE -ne 0) { throw "Verschluesselung fehlgeschlagen (Exit $LASTEXITCODE)" }
    git add index.html
    git commit -m "Trend-Radar Auto-Update ($Mode) $(Get-Date -Format 'dd.MM.yyyy')" --quiet
    git push --quiet
    Say "Veroeffentlicht: https://komuwi.github.io/trend-radar/"
    Say "=== Lauf erfolgreich beendet ==="
} catch {
    Say "FEHLER: $($_.Exception.Message)" "ERROR"
    Popup ("Trend-Radar ($Mode) NICHT aktualisiert:`n`n" + $_.Exception.Message + "`n`nProtokoll: logs\auto-update.log")
    exit 1
} finally {
    if ($gotLock) { $mutex.ReleaseMutex() }
    $mutex.Dispose()
}
