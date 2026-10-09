<#
.SYNOPSIS
  Downloads the brand fonts as TrueType for the marketing screenshot tests.

.DESCRIPTION
  Archivo, IBM Plex Sans and IBM Plex Mono go to .dart_tool/reel_fonts, where
  test/marketing/marketing_support.dart loads them (Flutter's FontLoader cannot
  read woff2). Cached files are kept.

.EXAMPLE
  .	ooletch_brand_fonts.ps1
#>
[CmdletBinding()]
param()

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
