#!/usr/bin/env bash
# Exo 2.1/2.2 - Balayage de charge en modele ouvert (k6, taux d'arrivee constant).
# Necessite MU (debit de saturation, exo 1.1) et ITER (iterations fixees).
# Usage : MU=400 ITER=200000 ./sweep_open.sh

: "${MU:?definir MU (req/s, issu de find_mu.sh)}"
: "${ITER:?definir ITER}"

OUT="results"
mkdir -p "$OUT"

for pct in 30 50 70 80 90 95 98; do
  rate=$(( MU * pct / 100 ))
  echo "=== rho=${pct}%  rate=${rate} req/s ==="
  k6 run --env RATE="$rate" --env ITER="$ITER" scenario.js \
    --summary-export="$OUT/res_${pct}.json"
  echo
done
