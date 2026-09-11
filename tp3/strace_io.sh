#!/usr/bin/env bash
# Exo 2.2 - Suivi des appels systeme disque avec strace (variante I/O-bound).
# Usage : sudo ./strace_io.sh   (le service doit deja tourner, charge active)

OUT="results"
mkdir -p "$OUT"

pid=$(pgrep -f server.js | head -1)
if [ -z "$pid" ]; then
  echo "service-commandes introuvable (pgrep -f server.js)" >&2
  exit 1
fi
echo "PID service = $pid  (Ctrl+C pour arreter apres quelques secondes)"

strace -T -f -p "$pid" -e trace=write,fsync,read,openat 2> "$OUT/trace_io.txt"
grep -E "fsync|write" "$OUT/trace_io.txt" | head -20 | tee "$OUT/trace_io_extrait.txt"
