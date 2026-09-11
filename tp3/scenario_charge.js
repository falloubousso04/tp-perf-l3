// TP3 - charge soutenue a taux d'arrivee constant, duree longue pour couvrir
// vmstat/iostat/mpstat/perf/strace en parallele.
// Usage : k6 run --env RATE=22 --env ITER=16000000 --env DURATION=45s scenario_charge.js
import http from 'k6/http';

export const options = {
  scenarios: {
    charge_soutenue: {
      executor: 'constant-arrival-rate',
      rate: __ENV.RATE,
      timeUnit: '1s',
      duration: __ENV.DURATION || '45s',
      preAllocatedVUs: 100,
      maxVUs: 300,
    },
  },
};

export default function () {
  http.get(`http://localhost:8080/commande?montant=100&iterations=${__ENV.ITER}`);
}
