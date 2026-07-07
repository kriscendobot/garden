// Synthetic, shape-faithful A/B of the @agoric/internal/src/hex.js decodings
// builder against one xsnap-worker (selected by $XSNAP_WORKER). Reproduces the
// XS value-stack WIDTH overflow (not recursion depth) that aborts the ymax0 v320
// contract-upgrade import at the on-chain default stackCount=4096.
//
// hex.js: new Map(RI.flatMap((e,t) => [[r,t],[m1,t],[m2,t],[o,t]]))  (RI len 256).
// flatMap(depth 1): each element -> a 4-array (NESTED branch, recurse); each pair
// -> LEAF branch. Width-parameterized by N so the transient flatMap slots cross
// 4096 on an engine that leaves them resident.
//
// Requires xsdrive.mjs (the fd-3/fd-4 netstring driver) alongside; set
// $XSNAP_WORKER to the worker under test. meteringLimit=0 -> the native value
// stack is the binding limit, as on chain. classify()=='STACK_OVERFLOW' (exit 12)
// is the overflow; the completion signal is a thrown Error carrying the Map size.
//
//   for v in stock cherry pr1; do
//     XSNAP_WORKER=./worker-4096-$v LABEL=$v node synth-flatmap-ab.mjs 700 900 1100
//   done
import { makeWorker, classify } from './xsdrive.mjs';

function script(N) {
  return `
    const RI = Array.from({length: ${N}}, (_, i) => String(i));
    const decodings = new Map(RI.flatMap((e, t) => {
      const r = e.toLowerCase(), o = e.toUpperCase();
      return [[r, t], [r + '_' + o, t], [o + '_' + r, t], [o, t]];
    }));
    throw new Error('OK size=' + decodings.size);   // completion signal, value read back
  `;
}

const label = process.env.LABEL || process.env.XSNAP_WORKER;
const Ns = process.argv.slice(2).map(Number);
for (const N of (Ns.length ? Ns : [256, 700, 900, 1000, 1100, 1300])) {
  const w = await makeWorker({ name: 'w', meteringLimit: 0 });
  const res = await w.evaluate(script(N));
  w.close();
  console.log(`${label}\tN=${N}\tpairs=${N * 4}\t${classify(res)}${res.error ? ' ' + res.error.slice(0, 40) : ''}`);
}
