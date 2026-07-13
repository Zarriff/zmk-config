#!/bin/sh
# Convert the keymap-drawer SVGs to PDFs for viewing outside the IDE.
# Requires librsvg: brew install librsvg
set -e
cd "$(dirname "$0")/.."

command -v rsvg-convert >/dev/null 2>&1 || {
    echo "rsvg-convert not found; install it with: brew install librsvg" >&2
    exit 1
}

for svg in keymap-drawer/*.svg; do
    [ -e "$svg" ] || { echo "no SVGs in keymap-drawer/ — push and pull to let CI draw them" >&2; exit 1; }
    pdf="${svg%.svg}.pdf"
    rsvg-convert -f pdf -o "$pdf" "$svg"
    echo "wrote $pdf"
done
