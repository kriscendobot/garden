// Concurrent-observer contract-control upgrade driver for kriskowal/garden#9
// (mhofman's full #9 protocol, run to completion 2026-07-01).
//
// The inquisitor overlay cannot service post-upgrade smart-wallet/vstorage
// traffic, so the block never quiesces and `await EV(cc).upgrade()` (run-utils
// queueAndRun) HANGS. Instead: enqueue via controller.queueToVatObject for a kpid,
// start controller.run() WITHOUT awaiting, and poll the overlay incarnation +
// controller.kpStatus(kpid) on a setTimeout loop.
//
//   ko25961078 = ymax0's delegated ContractControl (owner v1;
//                v43.vs.vc.1144877.symaxControl). ymax1 is ko25964180.
//   v290       = the live ymax0 ZCF vat (zcf-b1-68c494-ymax0).
//   bundleId   = the CONTRACT bundle (portfolio.contract), NOT the ZCF vat source
//                bundle — ZCF re-imports the contract bundle in a fresh worker,
//                where hex.js overflows. Passing the ZCF source bundle is the
//                classic mistake.
//
// SIGNAL: a new incarnation span opens IMMEDIATELY in ALL cases — do NOT read
// "span opened" as success.
//   SUCCESS = kpResolution does not reject; the fresh worker span reaches the
//             full [249702,249706) (clean import).
//   FAILURE = kpResolution rejects with `Error: vat-upgrade failure`, span
//             truncated at [249702,249705), and the preserved slog carries the
//             delivery-level cause {"#error":"Stack meter exceeded", …} (exit 12).
//
// Preserve the slog BEFORE inquisitor's shutdown() removes the testdb:
//   cp "$(ls -t /tmp/testdb-*/flight-recorder.bin | head -1)" ./flight.bin
//   grep -c 'Stack meter exceeded' ./flight.bin
//
// Run with INQUISITOR_MAX_VATS_ONLINE=50.
//
// Provenance: reconstructed from the SKILL.md methodology; the verbatim original
// lived in the ymax0-inquisitor-build worktree that redeploy wiped before it was
// committed. The call sequence follows the documented vector and has NOT been
// re-run on this host.
import fs from 'node:fs';

const label = process.env.RUN_LABEL || 'cc2';
const CC_KREF = process.env.CC_KREF || 'ko25961078'; // ymax0 ContractControl
const ZCF_VAT = process.env.ZCF_VAT || 'v290'; // live ymax0 ZCF vat
const bundle = JSON.parse(fs.readFileSync(process.env.BUNDLE_JSON, 'utf8'));
const bundleID = `b1-${bundle.endoZipBase64Sha512}`;
if (!swingStore.kernelStorage.bundleStore.hasBundle(bundleID)) {
  await swingStore.kernelStorage.bundleStore.addBundle(bundleID, bundle);
}

const incarnationOf = vatID =>
  swingStore.kernelStorage.transcriptStore.getCurrentSpanBounds(vatID).incarnation;
const incBefore = incarnationOf(ZCF_VAT);
console.warn(`[${label}] installed ${bundleID}; ${ZCF_VAT} incarnation=${incBefore}`);

// Enqueue for a kpid, then crank the kernel WITHOUT awaiting (avoids the
// scripted-mode / queueAndRun deadlock).
const kpid = controller.queueToVatObject(
  kslot(CC_KREF),
  'upgrade',
  [{ bundleId: bundleID, privateArgsOverrides: {} }],
  'ignore',
);
console.warn(`[${label}] queued upgrade -> ${kpid}`);
const runP = controller.run();
runP.catch(() => {});

// Poll incarnation + kpStatus until the result promise settles.
const settled = await new Promise(resolve => {
  const tick = () => {
    const st = controller.kpStatus(kpid);
    const inc = incarnationOf(ZCF_VAT);
    if (st === 'fulfilled' || st === 'rejected') {
      resolve({ status: st, inc });
    } else {
      setTimeout(tick, 50);
    }
  };
  tick();
});
await runP.catch(() => {});

// Read the resolution EXACTLY ONCE (repeat calls -> refCount underflow).
let detail;
if (settled.status === 'rejected') {
  const err = kunser(controller.kpResolution(kpid));
  // err is an Error — log message/stack, never JSON.stringify (renders {}).
  detail = `REJECTED: ${err && err.message}\n${err && err.stack}`;
} else {
  detail = `FULFILLED: ${JSON.stringify(kunser(controller.kpResolution(kpid)))}`;
}
console.warn(
  `[${label}] OUTCOME: ${settled.status}; incarnation ${incBefore}->${settled.inc}`,
);
console.warn(`[${label}] ${detail}`);
