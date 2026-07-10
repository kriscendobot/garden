// Engine-level A/B divergence probe: the two xsnap-worker binaries the
// variant-integration branch ships (kriscendobot/agoric-sdk#13,
// xst/integrate-variant-bump) —
//
//   legacy  → packages/xsnap/xsnap-native/...        → XS 13.3.0 (Moddable 3.9.2)
//   latest  → packages/xsnap/latest/xsnap-native/... → XS 16.7.1 (Moddable 5.5.0)
//
// driven through the REAL xsnap.js evaluate() harness (netstring protocol,
// on-chain value-stack size), not the standalone `xst` shell. Complements the
// sibling xst-release-ab / xst-flat-release-ab harnesses, which A/B stock `xst`
// release binaries at the 256K-slot shell stack; this one compares the actual
// consensus workers as built by the branch.
//
// Usage, from an agoric-sdk checkout with both variants built
//   (yarn install:prebuilt && yarn build:latest in packages/xsnap):
//     cd packages/xsnap
//     node --import @endo/init/debug.js /path/to/ab-probe.mjs
//   (this file only needs packages/xsnap on disk; run it from there so the
//    relative worker paths and ./test/message-tools.js resolve.)
//
// Output: a TSV table of each probe's observable result on each engine, with a
// DIVERGES flag. Any NEW, unexplained divergence is a first-class finding.
import '@endo/init/debug.js';
import * as proc from 'node:child_process';
import fs from 'node:fs';
import * as os from 'node:os';
import { tmpName } from 'tmp';
import { fileURLToPath } from 'node:url';
import { xsnap } from './src/xsnap.js';
import { options } from './test/message-tools.js';

const io = { spawn: proc.spawn, os: os.type(), fs, tmpName };

const workerFor = variant =>
  fileURLToPath(
    new URL(
      `./${variant === 'latest' ? 'latest/' : ''}xsnap-native/xsnap/build/bin/lin/release/xsnap-worker`,
      import.meta.url,
    ),
  );

// Each probe sends one observable string via issueCommand (captured as send()),
// or the harness records the thrown class (value-stack overflow / metering abort).
const probes = {
  // flat/flatMap value-stack (the ymax0 hex.js class), LEAF + NESTED branches
  'flat-leaf-4000': `var K=4000;var inner=[];for(var i=0;i<K;i++)inner.push(i);var r=[inner].flat();send('len='+r.length)`,
  'flat-leaf-100000': `var K=100000;var inner=[];for(var i=0;i<K;i++)inner.push(i);var r=[inner].flat();send('len='+r.length)`,
  'flat-nested-4000': `var N=4000;var inner=[0];var a=new Array(N);for(var i=0;i<N;i++)a[i]=inner;var r=a.flat(1);send('len='+r.length)`,
  'flat-nested-100000': `var N=100000;var inner=[0];var a=new Array(N);for(var i=0;i<N;i++)a[i]=inner;var r=a.flat(1);send('len='+r.length)`,
  'flatMap-50000': `var K=50000;var a=[];for(var i=0;i<K;i++)a.push(i);var m=new Map(a.flatMap(function(x){return [[x,x]]}));send('size='+m.size)`,
  // number / bigint / regex — core determinism
  'num-toString': `send((0.1+0.2).toString()+'|'+(1/3).toString()+'|'+(2**53).toString())`,
  'bigint-pow': `var b=12345678901234567n;send((b*b*b).toString())`,
  'number-toFixed': `send((1.005).toFixed(2)+'|'+(2.675).toFixed(2))`,
  'regex-unicode': `send(/\\p{Letter}+/u.test('abcÀ')+'|'+'aAbB'.match(/[a-z]/gi).join(''))`,
  'sort-numeric': `var a=[10,1,2,20,3];a.sort();send(a.join(','))`,
  'array-flat-deep': `send(JSON.stringify([1,[2,[3,[4]]]].flat(Infinity)))`,
  'json-order': `var o={};o.b=1;o.a=2;o[2]=3;o[1]=4;send(JSON.stringify(o))`,
  // error-message shape (create-vat.test.js / xsnap.test.js regexes depend on this)
  'err-notfunc': `try{var x=undefined;x()}catch(e){send(e.message)}`,
  'err-getprop': `try{null.foo}catch(e){send(e.message)}`,
  // newer intrinsics — present in XS 16.7.1, absent in XS 13.3.0
  'has-immutable-ab': `send(String(typeof ArrayBuffer.prototype.transfer)+'|'+String('immutable' in ArrayBuffer.prototype||('sliceToImmutable' in ArrayBuffer.prototype)))`,
  'array-fromAsync': `send(String(typeof Array.fromAsync))`,
  'object-groupBy': `send(String(typeof Object.groupBy)+'|'+String(typeof Map.groupBy))`,
  'iterator-helpers': `send(String(typeof Iterator!=='undefined' && typeof Iterator.prototype.map))`,
  'set-methods': `send(String(typeof Set.prototype.intersection)+'|'+String(typeof Set.prototype.union))`,
  'promise-withResolvers': `send(String(typeof Promise.withResolvers))`,
  'well-formed': `send(String(typeof String.prototype.isWellFormed))`,
};

async function runVariant(variant) {
  const results = {};
  for (const [name, src] of Object.entries(probes)) {
    let captured;
    const handleCommand = async msg => {
      captured = new TextDecoder().decode(msg);
      return new Uint8Array();
    };
    const opts = { ...options(io), handleCommand, meteringLimit: 0 };
    process.env.XSNAP_WORKER = workerFor(variant);
    const vat = await xsnap(opts);
    try {
      const wrapped = `(function(){function send(s){issueCommand(new TextEncoder().encode(String(s)).buffer);}${src}})();`;
      await vat.evaluate(wrapped);
      results[name] = `OK ${captured ?? ''}`.trim();
    } catch (e) {
      results[name] = `ERR ${String(e.message || e).split('\n')[0]}`;
    } finally {
      try {
        await vat.terminate();
      } catch {}
    }
  }
  return results;
}

const legacy = await runVariant('legacy');
const latest = await runVariant('latest');

console.log('probe\tlegacy(XS13.3.0)\tlatest(XS16.7.1)\tDIVERGES');
let diverged = 0;
for (const name of Object.keys(probes)) {
  const [a, b] = [legacy[name], latest[name]];
  const d = a === b ? '' : 'DIVERGES';
  if (d) diverged += 1;
  console.log(`${name}\t${a}\t${b}\t${d}`);
}
console.log(`\n${diverged} of ${Object.keys(probes).length} probes diverge`);
