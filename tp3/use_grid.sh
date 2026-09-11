#!/usr/bin/env bash
# Exo 3.1 - Releve brut pour remplir la grille USE (CPU, Memoire, Disque, Reseau).
# A lancer PENDANT la charge (ab), en parallele du service.
# Usage : sudo ./use_grid.sh cpu   (ou io)

VARIANTE="${1:?usage: use_grid.sh <cpu|io>}"
OUT="results"
mkdir -p "$OUT"
F="$OUT/use_grid_${VARIANTE}.txt"

{
  echo "### CPU - mpstat -P ALL 1 3"
  mpstat -P ALL 1 3
  echo
  echo "### CPU - vmstat 1 3 (colonne r = saturation)"
  vmstat 1 3
  echo
  echo "### CPU - dmesg (throttling)"
  dmesg 2>/dev/null | grep -i -E "throttl|thermal" || echo "(rien trouve)"
  echo
  echo "### Memoire - free -m"
  free -m
  echo
  echo "### Memoire - dmesg (OOM killer)"
  dmesg 2>/dev/null | grep -i "oom" || echo "(rien trouve)"
  echo
  echo "### Disque - iostat -x 1 3"
  iostat -x 1 3
  echo
  echo "### Reseau - ss -s (retransmissions TCP)"
  ss -s
  echo
  echo "### Reseau - netstat -s (erreurs/pertes, extrait)"
  netstat -s 2>/dev/null | grep -i -E "retrans|error|drop" || echo "(netstat indisponible)"
} | tee "$F"

echo
echo "Releve ecrit dans $F"
