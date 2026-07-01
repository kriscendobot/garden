// Produce the PATCHED ymax0 bundle for the kriskowal/garden#9 A/B: rewrite the
// `hex.js` `decodings = new Map(RI.flatMap(...))` table (which materializes
// ~1,024 [key,value] pairs on the XS value stack) to a bounded `new Map` + `for`
// + `.set()` loop (O(1) value-stack peak). Removes exactly one `.flatMap(`
// (10 -> 9) in the flattened `portfolio.contract.bundle.js`, updates the module
// sha512 and the compartment-map entry, and re-zips a fresh endoZipBase64 bundle
// (new `b1-…` id) so a real on-chain XS worker will import it.
//
// Run with cwd inside a built kriscendobot/agoric-sdk worktree so `@endo/zip`
// resolves from that tree's node_modules:
//   cd <agoric-sdk-worktree> && node <this>/patch-hex-bundle.mjs <control.json> <out.json>
//
// Verified 2026-07-01 on agoric-26146641: control overflows ("Stack meter
// exceeded" during import), patched imports clean (reaches the benign
// "lacks buildRootObject()" post-import check).
import fs from 'node:fs';
import crypto from 'node:crypto';
import { createRequire } from 'node:module';
import { pathToFileURL } from 'node:url';

// Resolve @endo/zip from the cwd (the agoric-sdk worktree), not this file's dir.
const req = createRequire(`${process.cwd()}/`);
const { writeZip, readZip } = await import(pathToFileURL(req.resolve('@endo/zip')));

const [, , inPath, outPath] = process.argv;
if (!inPath || !outPath) {
  console.error('usage: node patch-hex-bundle.mjs <control-bundle.json> <out.json>');
  process.exit(64);
}
const sha512hex = b => crypto.createHash('sha512').update(b).digest('hex');

const bundle = JSON.parse(fs.readFileSync(inPath, 'utf8'));
const zipBytes = new Uint8Array(Buffer.from(bundle.endoZipBase64, 'base64'));

// Read the two archive entries (compartment-map.json first, then the module).
// ZipReader wants a Uint8Array and its `read()` returns a Promise<Uint8Array>.
const reader = await readZip(zipBytes, inPath);
const cm = JSON.parse(
  Buffer.from(await reader.read('compartment-map.json')).toString('utf8'),
);

// Locate the single flattened module.
let modLoc;
for (const comp of Object.values(cm.compartments)) {
  for (const m of Object.values(comp.modules || {})) {
    if (m.location && m.location.endsWith('portfolio.contract.bundle.js')) modLoc = m;
  }
}
if (!modLoc) throw Error('flattened contract module not found in compartment-map');

// The archive stores the module under "<compartment-location>/<module-location>".
const compName = Object.values(cm.compartments).find(c =>
  Object.values(c.modules || {}).some(m => m === modLoc),
).location;
const modEntry = `${compName}/${modLoc.location}`;
const mod = JSON.parse(Buffer.from(await reader.read(modEntry)).toString('utf8'));

const control =
  'P_=new Map(RI.flatMap((e,t)=>{let r=e.toLowerCase(),o=e.toUpperCase();return[[r,t],[`${r[0]}${o[1]}`,t],[`${o[0]}${r[1]}`,t],[o,t]]}))';
const patched =
  'P_=(()=>{let M=new Map();for(let t=0;t<RI.length;t++){let e=RI[t],r=e.toLowerCase(),o=e.toUpperCase();M.set(r,t);M.set(`${r[0]}${o[1]}`,t);M.set(`${o[0]}${r[1]}`,t);M.set(o,t)}return M})()';

const src = mod.__syncModuleProgram__;
if (!src.includes(control)) throw Error('control decodings expression not found (bundle drifted?)');
const before = (src.match(/flatMap\(/g) || []).length;
mod.__syncModuleProgram__ = src.replace(control, patched);
const after = (mod.__syncModuleProgram__.match(/flatMap\(/g) || []).length;
console.warn(`flatMap count: ${before} -> ${after}`);

const newModBytes = Buffer.from(JSON.stringify(mod));
modLoc.sha512 = sha512hex(newModBytes);

// Re-zip: compartment-map.json first (endo requirement), then the module.
const zw = writeZip();
await zw.write('compartment-map.json', Buffer.from(JSON.stringify(cm)));
await zw.write(modEntry, newModBytes);
const outZip = await zw.snapshot();
const b64 = Buffer.from(outZip).toString('base64');
const outBundle = {
  moduleFormat: 'endoZipBase64',
  endoZipBase64: b64,
  endoZipBase64Sha512: sha512hex(b64),
};
fs.writeFileSync(outPath, JSON.stringify(outBundle));
console.warn(`wrote ${outPath}  bundleID b1-${outBundle.endoZipBase64Sha512}`);
