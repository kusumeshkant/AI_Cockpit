<#
.SYNOPSIS
  Generates the Play Store phone screenshots from the real app screens.

.DESCRIPTION
  Downloads the brand fonts as TrueType (Flutter's FontLoader cannot read
  woff2), then runs the opt-in generator test, which renders ActionsFeedScreen,
  ActionDetailScreen, SignInScreen and ConnectionsScreen with demo data and
  writes 1080x1920 PNGs in light and dark theme.

.PARAMETER OutDir
  Where the PNGs go. Defaults to the marketing assets folder outside this repo,
  so nothing generated here can be committed by accident.

.EXAMPLE
  .\tool\generate_store_screenshots.ps1
#>
[CmdletBinding()]
param(
  [string]$OutDir = 'D:\projects\AI_Cockpit\product\marketing_assets\play_store\screenshots'
)

$ErrorActionPreference = 'Stop'
Set-Location (Join-Path $PSScriptRoot '..')

& (Join-Path $PSScriptRoot 'fetch_brand_fonts.ps1')

Write-Host '==> Rendering'
New-Item -ItemType Directory -Force -Path $OutDir | Out-Null
& flutter test test/marketing/store_screenshots_test.dart "--dart-define=STORE_OUT=$OutDir"
if ($LASTEXITCODE -ne 0) { throw "flutter test failed with exit code $LASTEXITCODE" }

Write-Host ''
Write-Host "==> Done. Files in ${OutDir}:"
Get-ChildItem -Path $OutDir -Filter *.png | Select-Object -ExpandProperty Name
