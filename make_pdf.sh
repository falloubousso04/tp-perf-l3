#!/usr/bin/env bash
# Regenere les 3 rapports PDF a partir des RAPPORT_TPx.md.
#
# Etape 1 (ce script, sous WSL/Linux) : Markdown -> HTML autonome (CSS + images
# encodees en base64) via pandoc. Necessite : apt install pandoc.
# Les images referencees dans les .md (courbe_rho_w.png, flamegraph.svg)
# doivent se trouver a cote des .md au moment de la conversion.
#
# Etape 2 (sous Windows) : HTML -> PDF via impression headless d'un navigateur
# Chromium, qui respecte les regles CSS @page/print de report_style.css :
#   msedge --headless --disable-gpu --no-pdf-header-footer \
#     --print-to-pdf="RAPPORT_TP1.pdf" "file:///.../RAPPORT_TP1.html"
# (idem pour TP2 et TP3, avec un --user-data-dir distinct par appel pour
# eviter les conflits de profil si les commandes sont lancees en parallele)

set -e
cd "$(dirname "$0")"
mkdir -p pdf
for f in RAPPORT_TP1 RAPPORT_TP2 RAPPORT_TP3; do
  pandoc "$f.md" -f markdown+fenced_divs -t html5 --standalone \
    --css=report_style.css --embed-resources \
    -o "pdf/$f.html"
done
ls -la pdf/
