// Faithful contract-control upgrade vector for kriskowal/garden#9.
// Seeds the over-threshold bundle (install-first), then triggers the LIVE ymax0
// ContractControl.upgrade(bundleId) -> E(liveKit.adminFacet).upgradeContract ->
// a fresh XS worker re-imports the bundle (where hex.js lives).
import fs from 'node:fs';
const label = process.env.RUN_LABEL || 'cc';
const bundle = JSON.parse(fs.readFileSync(process.env.BUNDLE_JSON, 'utf8'));
const bundleID = `b1-${bundle.endoZipBase64Sha512}`;
if (!swingStore.kernelStorage.bundleStore.hasBundle(bundleID)) {
  await swingStore.kernelStorage.bundleStore.addBundle(bundleID, bundle);
}
console.warn(`[cc:${label}] installed ${bundleID}`);
// Fire the send WITHOUT awaiting (avoids the scripted-mode deadlock), then crank.
let sendP;
try {
  sendP = EV(kslot('ko25961078')).upgrade({ bundleId: bundleID, privateArgsOverrides: {} });
  if (sendP && sendP.catch) sendP.catch(() => {});
} catch (e) { console.warn(`[cc:${label}] send-setup threw: ${e && e.message}`); }
let outcome;
try {
  await controller.run();
  try { const r = await sendP; outcome = `SETTLED (${typeof r})`; }
  catch (e) { outcome = `REJECTED: ${e && e.message}`; }
} catch (e) { outcome = `RUN THREW: ${e && e.message}`; }
console.warn(`[cc:${label}] OUTCOME: ${outcome}`);
// surface any terminated vat (an XS overflow terminates the upgrading worker)
try {
  const term = stable.db.prepare("SELECT vatID FROM vats WHERE terminated=1").all?.() || [];
  console.warn(`[cc:${label}] terminated vats:`, JSON.stringify(term));
} catch (e) {}
