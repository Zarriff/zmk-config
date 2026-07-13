#!/bin/sh
# Draw the keymap locally: ZMK keymap -> SVG -> PDF into keymap-drawer/.
# Requires: uv (for uvx) and librsvg (brew install librsvg).
set -e
cd "$(dirname "$0")/.."

KEYMAP=config/piantor_pro_bt.keymap
LAYOUT=config/piantor_pro_bt.json
CONFIG=keymap_drawer.config.yaml
OUT=keymap-drawer/piantor_pro_bt

command -v uvx >/dev/null 2>&1 || { echo "uvx not found; install uv (brew install uv)" >&2; exit 1; }
command -v rsvg-convert >/dev/null 2>&1 || { echo "rsvg-convert not found; brew install librsvg" >&2; exit 1; }

# The parser needs zmk-helpers' key-label header (combo positions use LB2 etc.).
# Cache it once; revision pinned to match zmk-helpers in config/west.yml.
HELPERS_REV=v0.3
HEADER=.zmk/keymap-drawer/include/zmk-helpers/key-labels/42.h
if [ ! -f "$HEADER" ]; then
    mkdir -p "$(dirname "$HEADER")"
    curl -fsSL "https://raw.githubusercontent.com/urob/zmk-helpers/$HELPERS_REV/include/zmk-helpers/key-labels/42.h" -o "$HEADER"
fi

mkdir -p keymap-drawer
uvx --from keymap-drawer keymap -c "$CONFIG" parse -z "$KEYMAP" > "$OUT.yaml"
uvx --from keymap-drawer keymap -c "$CONFIG" draw "$OUT.yaml" -j "$LAYOUT" > "$OUT.svg"
rsvg-convert -f pdf -o "$OUT.pdf" "$OUT.svg"
echo "wrote $OUT.svg, $OUT.pdf"
