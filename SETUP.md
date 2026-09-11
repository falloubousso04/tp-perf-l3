# Environnement de mesure

Toutes les mesures des trois TP ont été réalisées dans **WSL2 / Ubuntu 24.04 LTS**
sur une machine Windows 11 (noyau `6.6.87.2-microsoft-standard-WSL2`).

## Mise en place (déjà faite, conservée ici pour reproductibilité)

```bash
# Outils de charge et de mesure
sudo apt-get install -y apache2-utils sysstat strace linux-tools-common \
  linux-tools-generic bc gnuplot-nox jq git build-essential nodejs npm

# perf : le paquet linux-tools-generic n'installe pas de binaire lié au noyau
# WSL2 (nom de noyau non reconnu par le wrapper Ubuntu). Contournement : invoquer
# directement le binaire versionné, qui reste compatible (l'ABI perf_event_open
# est stable) :
sudo ln -sf /usr/lib/linux-tools-*/perf /usr/local/bin/perf

# k6 (dépôt officiel)
curl -s https://dl.k6.io/key.gpg | gpg --dearmor | sudo tee /usr/share/keyrings/k6-archive-keyring.gpg >/dev/null
echo "deb [signed-by=/usr/share/keyrings/k6-archive-keyring.gpg] https://dl.k6.io/deb stable main" \
  | sudo tee /etc/apt/sources.list.d/k6.list
sudo apt-get update && sudo apt-get install -y k6

# FlameGraph (Brendan Gregg)
git clone https://github.com/brendangregg/FlameGraph ~/FlameGraph
```

## Lancer le service

```bash
node server.js                        # 1 worker, port 8080, iterations par defaut = 200000
ITERATIONS=5 node server.js           # variante I/O-bound (calcul negligeable, fsync dominant)
WORKERS=4 node server.js              # variante multi-workers (bonus TP1 3.2)
```
