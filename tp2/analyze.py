#!/usr/bin/env python3
"""
TP2 - construit le tableau rho -> W_mesure / W_theo a partir des exports k6
(results/res_XX.json) et trace le graphique (results/courbe_rho_w.png).

Usage : python3 analyze.py <mu> <temps_service_s_a_faible_charge>
  ex.  python3 analyze.py 420 0.032
"""
import json
import sys
import glob
import re

def charger_resumes(dossier="results"):
    lignes = []
    for path in sorted(glob.glob(f"{dossier}/res_*.json"), key=lambda p: int(re.search(r"res_(\d+)\.json", p).group(1))):
        pct = int(re.search(r"res_(\d+)\.json", path).group(1))
        with open(path, encoding="utf-8") as f:
            data = json.load(f)
        # k6 --summary-export : metrics.http_req_duration.avg (ms)
        w_ms = data["metrics"]["http_req_duration"]["avg"]
        p95_ms = data["metrics"]["http_req_duration"].get("p(95)")
        lignes.append((pct, w_ms, p95_ms))
    return lignes

def main():
    if len(sys.argv) != 3:
        sys.exit(__doc__)
    mu = float(sys.argv[1])
    service_time = float(sys.argv[2])  # 1/mu mesure a faible charge, en secondes

    lignes = charger_resumes()
    if not lignes:
        sys.exit("aucun results/res_*.json trouve - lancer sweep_open.sh d'abord")

    print(f"{'rho(%)':>7} {'W_mesure(ms)':>14} {'p95(ms)':>10} {'W_theo(ms)':>12}")
    rows = []
    for pct, w_ms, p95_ms in lignes:
        rho = pct / 100.0
        w_theo_s = service_time / (1 - rho) if rho < 1 else float('inf')
        w_theo_ms = w_theo_s * 1000
        print(f"{pct:>7} {w_ms:>14.2f} {p95_ms or 0:>10.2f} {w_theo_ms:>12.2f}")
        rows.append((rho, w_ms, w_theo_ms))

    try:
        import matplotlib
        matplotlib.use("Agg")
        import matplotlib.pyplot as plt

        rhos = [r[0] for r in rows]
        w_mes = [r[1] for r in rows]
        w_th = [r[2] for r in rows]

        plt.figure(figsize=(7, 5))
        plt.plot(rhos, w_mes, "o-", label="W mesure (k6)")
        plt.plot(rhos, w_th, "s--", label="W theorique (M/M/1)")
        plt.xlabel("rho = lambda / mu")
        plt.ylabel("temps de reponse moyen (ms)")
        plt.title("Temps de reponse vs utilisation - service-commandes")
        plt.legend()
        plt.grid(True, alpha=0.3)
        plt.tight_layout()
        plt.savefig("results/courbe_rho_w.png", dpi=150)
        print("\nGraphique ecrit dans results/courbe_rho_w.png")
    except ImportError:
        print("\n(matplotlib absent : tableau seul, pas de graphique genere)")

if __name__ == "__main__":
    main()
