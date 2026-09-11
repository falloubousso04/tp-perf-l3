#!/usr/bin/env bash
# Exo 2.1 - Profil CPU echantillonne avec perf (variante CPU-bound).
# Usage : sudo ./perf_profile.sh   (le service doit deja tourner, charge active)

OUT="results"
mkdir -p "$OUT"

pid=$(pgrep -f server.js | head -1)
if [ -z "$pid" ]; then
  echo "service-commandes introuvable (pgrep -f server.js)" >&2
  exit 1
fi
echo "PID service = $pid"

perf record -p "$pid" -g -o "$OUT/perf.data" -- sleep 15
perf report --stdio -i "$OUT/perf.data" | tee "$OUT/perf_report.txt" | head -40
