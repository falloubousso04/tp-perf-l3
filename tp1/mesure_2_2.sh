#!/usr/bin/env bash
# Exo 2.2 - Debit sous charge concurrente avec ab, a plusieurs niveaux de concurrence.
# Usage : ./mesure_2_2.sh   (le service doit tourner sur le port 8080)

URL="http://localhost:8080/commande?montant=100&iterations=200000"
OUT="results"
mkdir -p "$OUT"

for c in 10 50 100; do
  n=$(( c * 10 ))
  echo "=== concurrence c=$c  (n=$n) ==="
  ab -n "$n" -c "$c" "$URL" | tee "$OUT/ab_c${c}.txt"
  echo
done
