---
ts: 2026-06-16T02:13:01Z
kind: result
role: fixer
repo: kriscendobot/agoric-sdk
project: agoric-sdk
refs:
  - entries/2026/06/16/010500Z-result-investigator-a29762.md
  - entries/2026/06/16/011000Z-dispatch-fixer-65b4a3.md
---

# Fixer: endow SwingSet vat evaluator with Float*Array constructors per ses#3153

Maintainer directive (kriskowal 2026-06-16T01:07:34Z on PR
kriscendobot/agoric-sdk#5): "We should endow the SwingSet evaluator with the
floating point typed arrays." This addresses the Class E framing from the
investigator (`010500Z-result-investigator-a29762.md`): SES 2.0 removed
`Float*Array` from constructed-compartment globals as part of NaN
side-channel hardening (endojs/endo#3153), but the pre-built upstream
release bundles (fast-usdc-beta-1/rc1/rc2/cctp-b1) still embed
`@endo/marshal-v1.6.3/src/encodePassable.js` whose module-top-level
`const asNumber=new Float64Array(1)` crashes inside a SES 2.x vat
compartment.

## Pre / post

- Pre-fix HEAD: `46b5491deccdeb42776b444226d6044a150c0639` (chore: Update
  yarn.lock, the prior fixer cc9bb5's tip).
- Post-fix HEAD: `c2de346cc527954bb2e6b8705e3a97fa818a4032`
  (fix(SwingSet): endow vat evaluator with Float*Array constructors per
  ses#3153).
- Pushed: `git push origin HEAD:mirror/12527-endo-sync-refresh` (append).

## Files touched and endowment pattern

Six sites, 62 insertions, no other changes. Pattern is identical at every
site:

```js
// SES 2.0 (endojs/endo#3153) removed Float*Array from shared compartment
// globals as part of NaN side-channel hardening. Pre-built upstream
// release bundles (e.g. fast-usdc-beta-1/rc1/rc2/cctp-b1) embed pre-fix
// @endo/marshal source that still calls `new Float64Array(...)` inside
// encodePassable, so we endow the constructors here to keep those
// bundles deserializable. New marshal source uses DataView and does
// not need the endowment.
Float16Array: globalThis.Float16Array,
Float32Array: globalThis.Float32Array,
Float64Array: globalThis.Float64Array,
```

- `packages/SwingSet/src/controller/controller.js`: the kernel bundle
  endowment (the kernel itself runs in a constructed compartment via
  `importBundle(kernelBundle, ...)`, so `globalThis.Float64Array` is
  undefined there and would propagate `undefined` down to every layer
  that captures `globalThis.Float64Array` from kernel scope).
- `packages/SwingSet/src/kernel/vat-loader/manager-local.js`: local-worker
  vat factory.
- `packages/SwingSet/src/supervisors/subprocess-node/supervisor-subprocess-node.js`:
  Node subprocess supervisor.
- `packages/swingset-xsnap-supervisor/lib/supervisor-subprocess-xsnap.js`:
  xsnap-worker supervisor.
- `packages/vats/src/core/chain-behaviors.js`: CORE_EVAL proposal
  compartment + `evaluateBundleCap` path in the bootstrap-vat handler.
- `packages/zoe/src/contractFacet/evalContractCode.js`: ZCF contract
  evaluator (where ZCF spawns released contract code into its vat
  compartment).

## Diagnostic chain

The investigator's framing was correct, and the cited location
(`supervisor-subprocess-node.js:144`) was the right starting point. The
load-bearing site was upstream of all four supervisors: the kernel bundle
itself in `controller.js:350`. A throw-probe in chain-behaviors.js
surfaced `globalThis.Float64Array=undefined` at the bootstrap vat with
the supervisor-only endowment in place; that proved the kernel scope
itself lacked Float64Array because the kernel runs in a constructed
compartment. Endowing the kernel bundle propagates the constructor
through to every layer below. The five supervisor / vat / contract / proposal
sites are defense-in-depth at each compartment-creation boundary in the
vat-instantiation path; consistency across sites is more valuable than
minimality here, since each site is a documented endowment point and the
SES 2.0 removal applies uniformly.

## Local validation

- `corepack yarn workspace @aglocal/fast-usdc-deploy test`:
  - Pre-fix on `46b5491dec`: 20 failing tests, all with
    `TypeError: Float64Array is not a constructor` (prop 87 Beta, prop 88
    RC1, deploy RC2, deploy CCTP beta, and the 16 dependent fast-usdc
    tests that cascaded against missing `published.fastUsdc` state).
  - Post-fix on `c2de346cc5`: **31 / 31 passing, 5 todo, EXIT=0**. The
    chain-impact iteration suite ran 7m 15s under xs-worker with no
    regression.
- Pre-push-gates (`skills/pre-push-gates/SKILL.md`):
  - `yarn format`: pass (auto-fixed 6 paths; re-staged).
  - `yarn lint`: pass (clean).
  - 8 probes: all pass (filename-no-stutter, no-ascii-banners,
    no-inline-import-jsdoc, no-non-ascii-in-source, no-pull-citations,
    security-md-hash-uniform, sentence-per-line-md, test-package-no-main).
  - `yarn typecheck`: skip (no typecheck script at workspace root).
  - Result: **gate passed**.

## PR comment

Posted a top-level summary @-mentioning @kriskowal:
<https://github.com/kriscendobot/agoric-sdk/pull/5#issuecomment-4714209699>

## Recommended next stage

`next: ooda-observation`. The fix is in CI's hands now. When CI settles:

- Class E (`test-fast-usdc-deploy (node-old)`) should flip green on the
  next OODA cycle (deterministic from local validation: same suite, same
  bundles, same SES version, same fix).
- Class D (`test-dapp (node-new)` documentation SES 1.x pin) is unchanged
  by this push and still requires the parallel `Agoric/documentation`
  sync-endo PR per MAINTAINERS.md § 464-491. Out of scope here.
- Other CI matrix axes that were passing pre-fix should remain green; the
  endowment is purely additive (adds three new globals to compartments,
  removes nothing).

When CI converges, the orchestrator (per OODA cycle) decides whether to
ferry to `Agoric/agoric-sdk` directly via boatman or defer to a maintainer
review pass.

Self-improvement: the fixer's playbook should treat "endow X in
compartment Y" tasks as requiring a propagation audit: when SES 2.x
removes a global from constructed compartments, the kernel itself is
typically a constructed compartment (via importBundle of a kernelBundle),
so capturing `globalThis.X` from any code that runs inside the kernel
gives `undefined` unless the kernel bundle's own endowments include X.
Future Endo / SES bumps that prune compartment globals follow the same
chain: kernel bundle endowment is upstream of vat-supervisor endowments
which are upstream of vat-internal compartment-creation endowments.
Endow at the topmost site that consumes the symbol, not just the leaf
site where the symbol is named.
