#!/usr/bin/env bash
# Exo 1.1/1.2 - Vue systeme globale (vmstat, iostat, mpstat) pendant une charge soutenue.
# A lancer PENDANT que ab tourne dans un autre terminal, avec un suffixe distinguant
# la variante ("cpu" ou "io").
# Usage : ./vue_globale.sh cpu

VARIANTE="${1:?usage: vue_globale.sh <cpu|io>}"
OUT="results"
mkdir -p "$OUT"

vmstat 1 10   | tee "$OUT/vmstat_${VARIANTE}.txt"
iostat -x 1 10 | tee "$OUT/iostat_${VARIANTE}.txt"
mpstat -P ALL 1 5 | tee "$OUT/mpstat_${VARIANTE}.txt"
