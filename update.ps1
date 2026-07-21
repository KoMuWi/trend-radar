# Trend-Radar Update — Wochen-Handgriff
# Aufruf:  .\update.ps1                       -> zieht die neueste trend-radar*.html aus Downloads
#          .\update.ps1 C:\Pfad\zur\datei.html -> nimmt genau diese Datei
param([string]$Neu)

$ErrorActionPreference = "Stop"
$RepoDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $RepoDir

if (-not $Neu) {
    $kandidat = Get-ChildItem "$env:USERPROFILE\Downloads\trend-radar*.html" |
        Sort-Object LastWriteTime -Descending | Select-Object -First 1
    if ($null -eq $kandidat) {
        Write-Host "Keine trend-radar*.html in Downloads gefunden. Pfad angeben: .\update.ps1 <datei>" -ForegroundColor Red
        exit 1
    }
    $Neu = $kandidat.FullName
    Write-Host "Neueste Datei aus Downloads: $Neu ($($kandidat.LastWriteTime))"
}
if (-not (Test-Path $Neu)) { Write-Host "Datei nicht gefunden: $Neu" -ForegroundColor Red; exit 1 }

Copy-Item $Neu "$RepoDir\trend-radar.html" -Force

$sec = Read-Host "Radar-Passwort" -AsSecureString
$PW = [Runtime.InteropServices.Marshal]::PtrToStringUni([Runtime.InteropServices.Marshal]::SecureStringToGlobalAllocUnicode($sec))

python encrypt_page.py trend-radar.html index.html "$PW"
if ($LASTEXITCODE -ne 0) { Write-Host "Verschlüsselung fehlgeschlagen." -ForegroundColor Red; exit 1 }

git add index.html
git commit -m "Trend-Radar Update $(Get-Date -Format 'dd.MM.yyyy')"
git push
Write-Host ""
Write-Host "Online: https://komuwi.github.io/trend-radar/  (1-2 Min Verzögerung durch Pages)" -ForegroundColor Green
