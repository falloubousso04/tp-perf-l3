#!/usr/bin/env bash
# Exo 1.1 - Trouver le debit de saturation mu, en augmentant la concurrence ab.
# Chaque palier est repete 3 fois pour distinguer un vrai plateau du bruit.
# Usage : ITER=16000000 ./find_mu.sh

: "${ITER:?definir ITER (nb iterations donnant ~20-50ms de temps de service)}"
URL="http://localhost:8080/commande?montant=100&iterations=$ITER"
OUT="results"
mkdir -p "$OUT"

for c in 5 10 20 40 80 120; do
  n=$(( c * 15 ))
  for rep in 1 2 3; do
    echo "=== c=$c rep=$rep n=$n ==="
    ab -n "$n" -c "$c" "$URL" 2>&1 | grep -E "Requests per second|Failed requests|Time per request" \
      | tee -a "$OUT/find_mu_c${c}.txt"
  done
  echo
done
