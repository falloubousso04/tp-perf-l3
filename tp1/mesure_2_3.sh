#!/usr/bin/env bash
# Exo 2.3 - Percentiles de temps de reponse via ab -e (distribution) et -g (gnuplot).
# Usage : ./mesure_2_3.sh

URL="http://localhost:8080/commande?montant=100&iterations=200000"
OUT="results"
mkdir -p "$OUT"

ab -n 500 -c 20 -e "$OUT/resultats.csv" -g "$OUT/gnuplot.tsv" "$URL" | tee "$OUT/ab_2_3.txt"

echo
echo "--- p50 / p95 / p99 (colonne 'Percentage served', resultats.csv) ---"
for p in 50 95 99 100; do
  grep "^${p}," "$OUT/resultats.csv"
done
