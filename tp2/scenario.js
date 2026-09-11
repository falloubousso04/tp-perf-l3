// TP2 - scenario k6 : modele ouvert a taux d'arrivee constant (RATE req/s).
// Usage : k6 run --env RATE=350 --env ITER=200000 --summary-export=results/res_XX.json scenario.js
import http from 'k6/http';

export const options = {
  scenarios: {
    charge_ouverte: {
      executor: 'constant-arrival-rate',
      rate: __ENV.RATE,
      timeUnit: '1s',
      duration: '20s',
      preAllocatedVUs: 200,
      maxVUs: 500,
    },
  },
};

export default function () {
  http.get(`http://localhost:8080/commande?montant=100&iterations=${__ENV.ITER}`);
}
