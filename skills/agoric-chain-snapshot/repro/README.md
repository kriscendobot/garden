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
