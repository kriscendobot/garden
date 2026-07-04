// Wallet-envelope-faithful upgrade vector for kriskowal/garden#9.
// Injects the smart-wallet `invokeEntry` bridge action the control account would
// send on chain, via inquisitor's pushQueueRecord + runNextBlock endowments (the
// inbound bridge-action injection path). The action targets the delegated
// `ymaxControl` entry and calls upgrade({ bundleId, privateArgsOverrides }):
//   actionQueue -> BridgeId.WALLET -> walletFactory.fromBridge
//     -> wallet.handleBridgeAction -> invoke.invokeEntry
//     -> myStore.get('ymaxControl').upgrade(...)
//     -> live instance adminFacet.upgradeContract -> fresh XS worker re-imports
//        the bundle (where hex.js `flatMap` overflows).
// The action carries ZERO object slots (pure-data args), so it is hand-marshalable
// with @endo/marshal and injected without any board-resolved remotables.
//
// Documented CAVEAT (overlay limitation): in the read-only inquisitor overlay the
// inbound WALLET bridge did NOT deliver the action to the wallet's
// handleBridgeAction — the block cranked routine work but wrote no
// `published.wallet.<address>` invocation record. Wiring the inbound WALLET
// handler (or reviving the control wallet) in the overlay is the open tooling
// step for a wallet-envelope-faithful run. Use repro-cc-direct-driver.mjs
// (EV-direct to the same ContractControl) as the runnable cross-check meanwhile.
//
// Provenance: reconstructed from the SKILL.md methodology; the verbatim original
// lived in a build worktree that redeploy wiped before it was committed. The
// action shape and endowment calls follow the documented vector and have NOT been
// re-run on this host — treat the bridge-record framing as a starting point to
// adapt to the exact pushQueueRecord signature in the tree you run against.
import fs from 'node:fs';
import { makeMarshal } from '@endo/marshal';

const label = process.env.RUN_LABEL || 'wallet-upgrade';
// ymax0-main control account (CONTROL_ADDRESSES / YMAX_CONTROL_WALLET_KEY in
// @agoric/portfolio-api/src/portfolio-constants.js).
const CONTROL_ADDRESS = 'agoric1e80twfutmrm3wrk3fysjcnef4j82mq8dn6nmcq';

const bundle = JSON.parse(fs.readFileSync(process.env.BUNDLE_JSON, 'utf8'));
const bundleID = `b1-${bundle.endoZipBase64Sha512}`;
if (!swingStore.kernelStorage.bundleStore.hasBundle(bundleID)) {
  await swingStore.kernelStorage.bundleStore.addBundle(bundleID, bundle);
}
console.warn(`[${label}] installed ${bundleID}`);

// Hand-marshal the BridgeAction with smallcaps; zero slots (pure data).
const { serialize } = makeMarshal(undefined, undefined, {
  serializeBodyFormat: 'smallcaps',
});
const bridgeAction = {
  method: 'invokeEntry',
  message: {
    targetName: 'ymaxControl',
    method: 'upgrade',
    args: [{ bundleId: bundleID, privateArgsOverrides: {} }],
  },
};
const capData = serialize(harden(bridgeAction));
if (capData.slots.length !== 0) {
  throw Error(`expected zero slots, got ${capData.slots.length}`);
}

// Enqueue the inbound WALLET action and crank a block.
pushQueueRecord('actionQueue', {
  type: 'WALLET_ACTION',
  owner: CONTROL_ADDRESS,
  action: JSON.stringify(capData),
  blockHeight: 0,
  blockTime: 0,
});
console.warn(`[${label}] enqueued WALLET_ACTION from ${CONTROL_ADDRESS}`);

let outcome;
try {
  await runNextBlock();
  const rec = swingStore.kernelStorage.kvStore.get(
    `published.wallet.${CONTROL_ADDRESS}`,
  );
  outcome = rec
    ? `cranked; wallet invocation record present`
    : `cranked; NO wallet invocation record (overlay WALLET-bridge caveat)`;
} catch (err) {
  outcome = `THREW: ${err && err.message}`;
}
console.warn(`[${label}] OUTCOME: ${outcome}`);
