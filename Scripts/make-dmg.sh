#!/bin/bash
# Packages build/MicroduckDesktop.app into dist/MicroduckDesktop.dmg (+ .zip).
# Run Scripts/build-app.sh first (this script calls it if the app is missing).
set -euo pipefail
cd "$(dirname "$0")/.."

APP="build/MicroduckDesktop.app"
[[ -d "$APP" ]] || Scripts/build-app.sh

mkdir -p dist
rm -f dist/MicroduckDesktop.dmg dist/MicroduckDesktop.zip

STAGE="$(mktemp -d)"
trap 'rm -rf "$STAGE"' EXIT

cp -R "$APP" "$STAGE/"
ln -s /Applications "$STAGE/Applications"
cat > "$STAGE/HOW TO OPEN.txt" <<'EOF'
Microduck Desktop
=================

1. Drag "MicroduckDesktop" into the Applications folder.
2. FIRST LAUNCH: right-click (or Control-click) the app and choose "Open",
   then click "Open" in the dialog. This is needed once because the app
   isn't notarized by Apple (it's a free community build).
   On macOS 15+, if that is refused: open System Settings > Privacy &
   Security, scroll down, and click "Open Anyway".
3. A little duck appears at the bottom of your screen, and a duck icon
   appears in the menu bar. Use the menu bar icon for settings (colors,
   size, behaviors) or to quit.

Enjoy your Microduck!
EOF

echo "==> Creating dist/MicroduckDesktop.dmg"
hdiutil create -volname "Microduck Desktop" -srcfolder "$STAGE" -ov -format UDZO \
    dist/MicroduckDesktop.dmg

echo "==> Creating dist/MicroduckDesktop.zip"
ditto -c -k --keepParent "$APP" dist/MicroduckDesktop.zip

echo "==> Done:"
ls -lh dist/
