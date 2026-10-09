#!/usr/bin/env bash
# Generates the "Sky & Niko" reel screenshots from the real app screens.
#
#   tool/generate_reel_screenshots.sh [output-dir]
#
# Default output is the marketing assets folder outside this repo, so nothing
# generated here can be committed by accident.
set -euo pipefail

cd "$(dirname "$0")/.."

OUT_DIR="${1:-D:/projects/AI_Cockpit/product/marketing_assets/reel_sky_niko}"
FONT_DIR=".dart_tool/reel_fonts"

# Flutter's FontLoader reads ttf/otf only. The CSS API picks a format from the
# user agent: modern browsers get woff2, older ones woff, and a client that
# advertises no webfont support at all gets TrueType — which is what we need.
UA="curl/7.1"

# family-on-Google | family-in-Flutter | weights
FAMILIES=(
  "Archivo|Archivo|400;500;600;700;800"
  "IBM+Plex+Sans|IBM_Plex_Sans|400;500;600;700"
  "IBM+Plex+Mono|IBM_Plex_Mono|500;600;700"
)

mkdir -p "$FONT_DIR"

echo "==> Fonts"
for spec in "${FAMILIES[@]}"; do
  IFS='|' read -r google flutter weights <<<"$spec"

  # Already cached? The app's styles only need these weights.
  if compgen -G "$FONT_DIR/${flutter}__*.ttf" >/dev/null; then
    echo "    $flutter: cached"
    continue
  fi

  css=$(curl -sSL -A "$UA" \
    "https://fonts.googleapis.com/css2?family=${google}:wght@${weights}&display=swap")

  # In TrueType mode the API returns one @font-face per weight, with no
  # unicode-range subsets, so weight and url pair up in order.
  echo "$css" | awk '
    /font-weight:/ { match($0, /[0-9]+/); w = substr($0, RSTART, RLENGTH) }
    /src: url\(/ {
      match($0, /https:[^)]+\.ttf/); url = substr($0, RSTART, RLENGTH)
      if (w != "" && url != "") { print w, url; w = ""; url = "" }
    }
  ' | while read -r weight url; do
    curl -sSL -A "$UA" -o "$FONT_DIR/${flutter}__${weight}.ttf" "$url"
    echo "    $flutter $weight"
  done
done

echo "==> Rendering"
mkdir -p "$OUT_DIR"
flutter test test/marketing/reel_screenshots_test.dart \
  --dart-define=REEL_OUT="$OUT_DIR"

echo
echo "==> Done. Files in $OUT_DIR:"
ls -1 "$OUT_DIR"
