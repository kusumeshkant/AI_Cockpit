<#
.SYNOPSIS
  Generates the "Sky & Niko" reel screenshots from the real app screens.

.DESCRIPTION
  Downloads the brand fonts as TrueType (Flutter's FontLoader cannot read
  woff2), then runs the opt-in generator test, which renders ActionsFeedScreen
  and ActionDetailScreen with demo data and writes 1080x1920 PNGs.

.PARAMETER OutDir
  Where the PNGs go. Defaults to the marketing assets folder outside this repo,
  so nothing generated here can be committed by accident.

.EXAMPLE
  .\tool\generate_reel_screenshots.ps1
#>
[CmdletBinding()]
param(
  [string]$OutDir = 'D:\projects\AI_Cockpit\product\marketing_assets\reel_sky_niko'
)

$ErrorActionPreference = 'Stop'
Set-Location (Join-Path $PSScriptRoot '..')

$fontDir = '.dart_tool/reel_fonts'

# The CSS API picks a format from the user agent: modern browsers get woff2,
# older ones woff, and a client advertising no webfont support gets TrueType.
$ua = 'curl/7.1'

# Family on Google Fonts -> family name Flutter sees, plus the weights used.
$families = @(
  @{ Google = 'Archivo';       Flutter = 'Archivo';        Weights = '400;500;600;700;800' },
  @{ Google = 'IBM+Plex+Sans'; Flutter = 'IBM_Plex_Sans';  Weights = '400;500;600;700' },
  @{ Google = 'IBM+Plex+Mono'; Flutter = 'IBM_Plex_Mono';  Weights = '500;600;700' }
)

New-Item -ItemType Directory -Force -Path $fontDir | Out-Null

Write-Host '==> Fonts'
foreach ($family in $families) {
  $existing = Get-ChildItem -Path $fontDir -Filter "$($family.Flutter)__*.ttf" -ErrorAction SilentlyContinue
  if ($existing) {
    Write-Host "    $($family.Flutter): cached"
    continue
  }

  $url = "https://fonts.googleapis.com/css2?family=$($family.Google):wght@$($family.Weights)&display=swap"
  $css = (Invoke-WebRequest -Uri $url -Headers @{ 'User-Agent' = $ua } -UseBasicParsing).Content

  # In TrueType mode there is one @font-face per weight and no unicode-range
  # subsets, so weight and url pair up in order.
  $weights = [regex]::Matches($css, 'font-weight:\s*(\d+)') | ForEach-Object { $_.Groups[1].Value }
  $urls    = [regex]::Matches($css, 'src:\s*url\((https:[^)]+\.ttf)\)') | ForEach-Object { $_.Groups[1].Value }

  for ($i = 0; $i -lt $urls.Count; $i++) {
    $dest = Join-Path $fontDir "$($family.Flutter)__$($weights[$i]).ttf"
    Invoke-WebRequest -Uri $urls[$i] -Headers @{ 'User-Agent' = $ua } -OutFile $dest -UseBasicParsing
    Write-Host "    $($family.Flutter) $($weights[$i])"
  }
}

Write-Host '==> Rendering'
New-Item -ItemType Directory -Force -Path $OutDir | Out-Null
& flutter test test/marketing/reel_screenshots_test.dart "--dart-define=REEL_OUT=$OutDir"
if ($LASTEXITCODE -ne 0) { throw "flutter test failed with exit code $LASTEXITCODE" }

Write-Host ''
Write-Host "==> Done. Files in ${OutDir}:"
Get-ChildItem -Path $OutDir -Filter *.png | Select-Object -ExpandProperty Name
