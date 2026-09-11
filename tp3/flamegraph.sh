#!/usr/bin/env bash
# Exo 4.1 - Genere un flame graph a partir d'un profil perf (variante CPU-bound).
# Necessite le depot FlameGraph clone dans ~/FlameGraph (voir setup.sh).
# Usage : sudo ./flamegraph.sh

OUT="results"
FG="$HOME/FlameGraph"
mkdir -p "$OUT"

pid=$(pgrep -f server.js | head -1)
if [ -z "$pid" ]; then
  echo "service-commandes introuvable (pgrep -f server.js)" >&2
  exit 1
fi

perf record -F 99 -p "$pid" -g -o "$OUT/perf_fg.data" -- sleep 15
perf script -i "$OUT/perf_fg.data" > "$OUT/out.perf"
"$FG/stackcollapse-perf.pl" "$OUT/out.perf" > "$OUT/out.folded"
"$FG/flamegraph.pl" "$OUT/out.folded" > "$OUT/flamegraph.svg"
echo "flame graph ecrit dans $OUT/flamegraph.svg"
