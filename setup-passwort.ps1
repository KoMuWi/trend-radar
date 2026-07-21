# Einmalige Einrichtung: Team-Passwort sicher im Windows Credential Manager hinterlegen.
# Aufruf per setup-passwort.cmd (Doppelklick). Das Passwort landet in KEINER Datei.
$ErrorActionPreference = "Stop"
$RepoDir = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$RepoDir\credman.ps1"

Write-Host "Trend-Radar: Team-Passwort im Windows Credential Manager hinterlegen." -ForegroundColor Cyan
Write-Host "(Verschluesselt mit deinem Windows-Login, nur fuer diesen Benutzer lesbar.)"
Write-Host ""

$s1 = Read-Host "Team-Passwort" -AsSecureString
$s2 = Read-Host "Wiederholen  " -AsSecureString
$p1 = [Runtime.InteropServices.Marshal]::PtrToStringUni([Runtime.InteropServices.Marshal]::SecureStringToGlobalAllocUnicode($s1))
$p2 = [Runtime.InteropServices.Marshal]::PtrToStringUni([Runtime.InteropServices.Marshal]::SecureStringToGlobalAllocUnicode($s2))

if ($p1 -ne $p2) { Write-Host "Eingaben stimmen nicht ueberein - bitte erneut ausfuehren." -ForegroundColor Red; exit 1 }
if ($p1.Length -lt 4) { Write-Host "Passwort zu kurz - bitte erneut ausfuehren." -ForegroundColor Red; exit 1 }

if (-not [TrCredMan]::Write("trend-radar-passwort", $p1)) {
    Write-Host "Fehler beim Schreiben in den Credential Manager." -ForegroundColor Red; exit 1
}
$check = [TrCredMan]::Read("trend-radar-passwort")
if ($check -ne $p1) { Write-Host "Verifikation fehlgeschlagen." -ForegroundColor Red; exit 1 }

Write-Host ""
Write-Host "Passwort sicher hinterlegt. Die automatischen Updates koennen es jetzt nutzen." -ForegroundColor Green
