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
    Add-Content -Path $Log -Value $line -Encoding utf8
    Write-Host $line
}

try {
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
    exit 1
}
