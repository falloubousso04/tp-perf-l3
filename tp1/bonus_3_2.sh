#!/usr/bin/env bash
# Exo 3.2 (bonus) - Verification experimentale d'Amdahl : debit avec 1, 2, 4 workers.
# A executer depuis la racine du depot (node server.js doit y etre accessible).
# Usage : ./tp1/bonus_3_2.sh

set -e
URL="http://localhost:8080/commande?montant=100&iterations=200000"
OUT="tp1/results"
mkdir -p "$OUT"

for w in 1 2 4; do
  echo "=== WORKERS=$w ==="
  WORKERS=$w node server.js > "/tmp/srv_${w}.log" 2>&1 &
  pid=$!
  sleep 1.5
  ab -n 800 -c 20 "$URL" | tee "$OUT/ab_workers_${w}.txt"
  kill "$pid" 2>/dev/null || true
  pkill -f "WORKERS=$w node server.js" 2>/dev/null || true
  sleep 1
done
pkill -f "node server.js" 2>/dev/null || true
echo done
