Inbox empty. Work complete.

---

## Completion report

**Reproduced the ymax0 v320 upgrade overflow and verified the `hex.js` fix through `inquisitor`, against the real mainnet swing-store — both halves demonstrated.**

### Result (the control/patched delta, identical conditions)
On the captured snapshot `agoric-26146641` (`host.height 26146641`, `integrity_check → ok`), same freshly-built on-chain `xsnap-worker`, same newly-allocated vat `v293`, same code path (`vatAdminSvc.getBundleCap` → `createVat`, which makes a real worker import the v320 contract bundle). Only the bundle differed:
- **Control** (stock v320 `bundle-ymax0`, `b1-2922a5f6…`, **10** `flatMap`): `Vat Creation Error: Stack meter exceeded` — XS value stack exhausted **during** bundle import.
- **Patched** (`hex.js` `flatMap`→loop, `b1-e3c6727c…`, **9** `flatMap`): `vat source bundle lacks buildRootObject()` — the bundle **imported cleanly** (module eval, incl. the `hex.js` `decodings` table, completed) and failed only at the benign post-import supervisor check.

The 10→9 delta is exactly `@agoric/internal/src/hex.js`'s `new Map(encodings.flatMap(...))` → `new Map`+`for`+`.set()` loop; the other nine `flatMap`s (all tiny arrays) are untouched and the import still goes green.

### Obstacle hit and resolved
The snapshot is **chain-tip**, captured after the incident, so the live ymax0 vat (`v275`) is already **terminated** — the faithful upgrade vector (`E(adminFacet).upgradeContract` via `ymax0Kit`) fails up front with `upgrade() on non-running vat "v275"`. Switched to `createVat(bundleCap)`, which required three bot-fork enablers: build `xsnap-lockdown` and `swingset-xsnap-supervisor` dist bundles (the bare immutable install omits them), and a one-line `inquisitor` overlay fix so its read-only swing-store seeds a transcript span for a freshly-created vatID (`initTranscript` was a no-op → `no current transcript`). Also fixed two driver bugs en route (`const {E}=powers` shadowing the global `E`; an in-eval comment containing `import (` tripping SES's `rejectImportExpressions`).

### Persisted
- **Issue #9 progress comment** posted (control-reproduced + patched-verified, with evidence, the one-site diff, and the obstacle): https://github.com/kriskowal/garden/issues/9#issuecomment-4848214817 — **left open** (submitter closes).
- **Garden skill** `skills/agoric-chain-snapshot/SKILL.md` updated with the validated `createVat` procedure and the chain-tip finding → pushed to **main2** (`8c888be1b`).
- **`inquisitor` overlay enabler** → `kriscendobot/agoric-sdk` branch `debug/xs-stack-overflow-methodology` (`8fd166e67f`).

### Follow-ups (optional)
- If a full contract-start (not just a clean import) is wanted as further confirmation, drive the patched bundle the rest of the way through ZCF `startInstance` (uses the same overlay enabler). I offered this on the thread.
- All work stayed on `kriscendobot/agoric-sdk` and bot-owned forks; no upstream `agoric/agoric-sdk` interaction.
