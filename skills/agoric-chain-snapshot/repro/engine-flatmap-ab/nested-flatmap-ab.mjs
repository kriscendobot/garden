// Nested-heavy A/B that SEPARATES the two flatAux pop placements. An array of N
// single-element sub-arrays flattened depth 1: every outer element hits the
// NESTED branch (recurse), every inner element hits the LEAF branch. Per present
// element the stock engine leaves ~2 resident value-stack slots (one leaf ref +
// one sub-array ref); the 73aad47b leaf-branch pop reclaims only the leaf (~N
// residual sub-array refs); PR#1's end-of-block pop reclaims both (~0 residual).
//
// Expected at stackCount=4096, meteringLimit=0:
//   stock  overflows around N~2000  (~2N ~= 4096)
//   cherry overflows around N~4100  (~N  ~= 4096, the un-popped sub-array refs)
//   pr1    clears well past N=4200  (O(depth))
//
//   for v in stock cherry pr1; do
//     XSNAP_WORKER=./worker-4096-$v LABEL=$v node nested-flatmap-ab.mjs 2000 3800 4200
//   done
import { makeWorker, classify } from './xsdrive.mjs';

function script(N) {
  return `
    const outer = Array.from({length: ${N}}, () => [{}]);  // N sub-arrays, 1 obj each
    const flat = outer.flat(1);
    throw new Error('OK len=' + flat.length);
  `;
}

const label = process.env.LABEL || process.env.XSNAP_WORKER;
const Ns = process.argv.slice(2).map(Number);
for (const N of (Ns.length ? Ns : [1000, 2000, 3000, 3800, 4200])) {
  const w = await makeWorker({ name: 'w', meteringLimit: 0 });
  const res = await w.evaluate(script(N));
  w.close();
  console.log(`${label}\tN=${N}\t${classify(res)}${res.error ? ' ' + res.error.slice(0, 30) : ''}`);
}
