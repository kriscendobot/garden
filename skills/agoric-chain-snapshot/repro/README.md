# Repro drivers for the ymax0 v320 XS value-stack overflow (kriskowal/garden#9)

These are the durable, committed drivers the parent `SKILL.md` references. Prior
rounds kept losing them (they lived in a build worktree that redeploys wiped), so
they now live here in the library. Each inquisitor driver runs **inside**
inquisitor's global context (piped on stdin under `INQUISITOR_NO_REPL=1`), so it
only needs `node:fs`; the endowments (`swingStore`, `runCoreEval`, `EV`,
`controller`, `kslot`, `runNextBlock`, `stable`, …) are already on `globalThis`.

## Files

- **`repro-createvat-driver.mjs`** — the decisive, unambiguous A/B vector. Seeds
  the bundle into the snapshot's bundle store (`addBundle` = the offline
  "install first"), then drives `vatAdminSvc.createVat(bundleCap)` so a fresh
  on-chain XS worker imports it (`compartmentImportNow` → `execute` → `hex.js`
  `flatMap`, where the overflow lives). Set `BUNDLE_JSON` and `RUN_LABEL`.
- **`repro-cc-direct-driver.mjs`** — the more-faithful contract-control upgrade
  vector: `EV(kslot('ko25961078')).upgrade({ bundleId, privateArgsOverrides:{} })`
  against the live ymax0 `ContractControl` (v1-owned on `agoric-26146641`). Fires
  the send WITHOUT awaiting, then cranks (`controller.run()`), per the scripted-
  mode caveat. Subject to the documented overlay wallet-bridge caveat, so it
  corroborates rather than replaces the `createVat` A/B.
- **`patch-hex-bundle.mjs`** — produces the PATCHED bundle from the control:
  rewrites the one `hex.js` `decodings = new Map(RI.flatMap(...))` (10 `.flatMap(`
  → 9) to a bounded `new Map` + `for` + `.set()` loop, fixes the module +
  compartment-map sha512, re-zips via `@endo/zip`. Run with cwd inside a built
  agoric-sdk worktree so `@endo/zip` resolves.

### The three upgrade-vector drivers (captured 2026-07-04, kriskowal/garden#22)

These trigger the upgrade through progressively more faithful paths. They were
referenced by the parent `SKILL.md` but had lived only in build worktrees that
redeploy wiped; they are **reconstructed from the SKILL.md methodology** in the
established inquisitor idiom (the verbatim originals were unrecoverable) and are
committed here so the vectors survive. Each follows its documented call sequence
but has **not** been re-run on this host — adapt the endowment signatures to the
tree you run against before relying on a fresh result.

- **`repro-upgrade-driver.mjs`** — the SUPERSEDED promise-space vector:
  `E(ymax0Kit.adminFacet).upgradeContract(bundleID)` via `runCoreEval`. Fails
  BEFORE any worker spins up (`…non-running vat "v275"`) because the bootstrap
  kit's adminFacet drives the original, now-terminated ymax0 instance — kept as
  the record of why the bootstrap adminFacet is the wrong target (stale-bootstrap-
  kit finding).
- **`repro-control-upgrade-driver.mjs`** — the WALLET-envelope-faithful vector:
  hand-marshals (`@endo/marshal`, smallcaps, zero slots) the control account's
  `invokeEntry`→`ymaxControl.upgrade` bridge action and injects it via
  `pushQueueRecord('actionQueue', …)` + `runNextBlock()`. Subject to the overlay
  WALLET-bridge caveat (the inbound WALLET action is not delivered to the wallet in
  the read-only overlay), so it corroborates rather than replaces the EV-direct
  vector.
- **`cc-upgrade-driver2.mjs`** — the CONCURRENT-OBSERVER contract-control upgrade
  (mhofman's full #9 protocol): `controller.queueToVatObject(kslot('ko25961078'),
  'upgrade', …)` for a kpid, `controller.run()` WITHOUT awaiting, poll incarnation
  + `kpStatus` on a `setTimeout` loop, read `kpResolution` exactly once. SUCCESS =
  no reject + span reaches `[249702,249706)`; FAILURE = `vat-upgrade failure` +
  slog `Stack meter exceeded`. Run with `INQUISITOR_MAX_VATS_ONLINE=50` and
  preserve `/tmp/testdb-*/flight-recorder.bin` before `shutdown()`.

## Verified A/B (2026-07-01, snapshot `agoric-26146641`)

```
# control (stock ymax-v0.3.2606-beta3 bundle-ymax0.json, bundleID b1-7b73897d…)
BUNDLE_JSON=bundle-ymax0.json RUN_LABEL=control INQUISITOR_NO_REPL=1 \
  node packages/cosmic-swingset/tools/inquisitor.mjs <swingstore.sqlite> \
  < repro-createvat-driver.mjs
#   OUTCOME: THREW: Vat Creation Error: Error: Stack meter exceeded

# patched (bundleID b1-6648cdf3…)
node .../patch-hex-bundle.mjs bundle-ymax0.json bundle-ymax0-patched.json
BUNDLE_JSON=bundle-ymax0-patched.json RUN_LABEL=patched INQUISITOR_NO_REPL=1 \
  node packages/cosmic-swingset/tools/inquisitor.mjs <swingstore.sqlite> \
  < repro-createvat-driver.mjs
#   OUTCOME: THREW: Vat Creation Error: Error: vat source bundle lacks buildRootObject()
#   (imported + evaluated clean — past the overflow — a raw contract bundle has no buildRootObject)
```

The over-threshold `bundle-ymax0.json` is fetched with
`gh release download ymax-v0.3.2606-beta3 --repo agoric/agoric-sdk --pattern
bundle-ymax0.json`. Scope: read-only analysis + on-host runs of the open-source
XS worker and public release assets, on bot forks only. No upstream
`agoric/agoric-sdk` interaction.
