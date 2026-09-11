// TP3 - variante I/O-bound : iterations minimales, le fsync domine le cout de la requete.
import http from 'k6/http';

export const options = {
  scenarios: {
    charge_io: {
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
  http.get(`http://localhost:8080/commande?montant=100&iterations=1`);
}
