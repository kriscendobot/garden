// Faithful-import repro driver for kriskowal/garden#9.
// Seeds the over-threshold ymax0 bundle into the snapshot's bundle store
// (the offline equivalent of MsgInstallBundle / "install the bundle first"),
// then drives a real on-chain XS worker to import it via vatAdminSvc.createVat.
// Control (stock v320 bundle) is expected to overflow the XS value stack.
import fs from 'node:fs';

const label = process.env.RUN_LABEL || 'unlabeled';
const bundle = JSON.parse(fs.readFileSync(process.env.BUNDLE_JSON, 'utf8'));
const bundleID = `b1-${bundle.endoZipBase64Sha512}`;
console.warn(`[repro:${label}] bundleID=${bundleID}`);

// Step 1 (publish MsgInstallBundle) -> seed the bundle bytes into the overlay.
if (!swingStore.kernelStorage.bundleStore.hasBundle(bundleID)) {
  await swingStore.kernelStorage.bundleStore.addBundle(bundleID, bundle);
  console.warn(`[repro:${label}] addBundle OK (installed first)`);
} else {
  console.warn(`[repro:${label}] bundle already present`);
}

// Drive a fresh on-chain worker to import the bundle (createVat import path,
// compartmentImportNow -> execute -> hex.js flatMap where the overflow lives).
let outcome;
try {
  await runCoreEval(`async powers => {
    const vas = await powers.consume.vatAdminSvc;
    const bc = await E(vas).getBundleCap('${bundleID}');
    await E(vas).createVat(bc, { name: 'ymax0repro' });
  }`);
  outcome = 'RETURNED_NO_OVERFLOW';
} catch (err) {
  outcome = `THREW: ${err && err.message}`;
}
console.warn(`[repro:${label}] OUTCOME: ${outcome}`);
