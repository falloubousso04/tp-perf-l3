#!/usr/bin/env bash
# Exo 3.1 - Modele ferme (ab) au meme rho que le modele ouvert, pour comparaison.
# Usage : MU=400 ITER=200000 ./sweep_closed.sh

: "${MU:?definir MU}"
: "${ITER:?definir ITER}"

OUT="results"
mkdir -p "$OUT"
URL="http://localhost:8080/commande?montant=100&iterations=${ITER}"

for pct in 90 98; do
  c=$(( MU * pct / 100 ))
  n=$(( c * 40 ))
  echo "=== rho=${pct}% (ferme, c=$c, n=$n) ==="
  ab -n "$n" -c "$c" "$URL" | tee "$OUT/closed_${pct}.txt"
  echo
done
