// Superseded promise-space upgrade vector for kriskowal/garden#9.
// Reaches ymax0's bootstrap kit through the promise space
// (E(ymax0Kit.adminFacet).upgradeContract) — but that adminFacet drives the
// ORIGINAL, now-terminated ymax0 instance (vat v275), not the live v290. So it
// fails BEFORE any worker spins up, with
//   vatAdminService rejecting attempt to perform "upgrade"() on non-running vat "v275"
// and is kept only as the record of WHY the bootstrap adminFacet is the wrong
// target (see the stale-bootstrap-kit note in the parent SKILL.md). The faithful
// path is the delegated ContractControl — repro-cc-direct-driver.mjs.
//
// Provenance: reconstructed from the SKILL.md methodology; the verbatim original
// lived in a build worktree that redeploy wiped before it was committed. The call
// sequence follows the documented vector and has NOT been re-run on this host.
// The consume-space name `ymax0Kit` matches the bootstrap kit at
// `v1.vs.vc.5.symax0Kit`; adjust to the actual produced name if it differs.
import fs from 'node:fs';

const label = process.env.RUN_LABEL || 'ps-upgrade';
const bundle = JSON.parse(fs.readFileSync(process.env.BUNDLE_JSON, 'utf8'));
const bundleID = `b1-${bundle.endoZipBase64Sha512}`;
if (!swingStore.kernelStorage.bundleStore.hasBundle(bundleID)) {
  await swingStore.kernelStorage.bundleStore.addBundle(bundleID, bundle);
}
console.warn(`[${label}] installed ${bundleID}`);

let outcome;
try {
  await runCoreEval(`async powers => {
    const ymax0Kit = await powers.consume.ymax0Kit;
    await E(ymax0Kit.adminFacet).upgradeContract('${bundleID}', {});
  }`);
  outcome = 'RETURNED_NO_OVERFLOW';
} catch (err) {
  // Expected here: "…non-running vat \"v275\"" — the stale-bootstrap-kit finding.
  outcome = `THREW: ${err && err.message}`;
}
console.warn(`[${label}] OUTCOME: ${outcome}`);
