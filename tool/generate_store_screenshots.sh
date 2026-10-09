#!/usr/bin/env bash
# Generates the Play Store phone screenshots from the real app screens.
#
#   tool/generate_store_screenshots.sh [output-dir]
#
# Default output is the marketing assets folder outside this repo, so nothing
# generated here can be committed by accident.
set -euo pipefail

cd "$(dirname "$0")/.."

OUT_DIR="${1:-D:/projects/AI_Cockpit/product/marketing_assets/play_store/screenshots}"

bash "$(dirname "$0")/fetch_brand_fonts.sh"

echo "==> Rendering"
mkdir -p "$OUT_DIR"
flutter test test/marketing/store_screenshots_test.dart \
  --dart-define=STORE_OUT="$OUT_DIR"

echo
echo "==> Done. Files in $OUT_DIR:"
ls -1 "$OUT_DIR"
