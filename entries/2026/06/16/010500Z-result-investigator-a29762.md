---
ts: 2026-06-16T01:05:00Z
kind: result
role: investigator
repo: kriscendobot/agoric-sdk
project: agoric-sdk
refs:
  - entries/2026/06/16/001258Z-result-fixer-cc9bb5.md
  - entries/2026/06/15/230109Z-result-fixer-cb7a05.md
  - entries/2026/06/14/102900Z-result-fixer-38fcec.md
---

# Investigator: PR #5 failing-job root-cause revisit (Float64Array, doc dep skew)

Maintainer kriskowal directive on PR #5 (2026-06-16T00:44:35Z): "Let's begin
investigating the root cause of the failing jobs while the rest are settling."
The two settled failures at dispatch time were `test-dapp (node-new)` and
`test-fast-usdc-deploy (node-old)`; the latter had been labeled "structural
impasse" by prior fixers. The brief asked to revisit that framing.

## Class E: test-fast-usdc-deploy (node-old) - SES 2.x Float\*Array compartment-global removal

### Root cause (with citation chain)

The 20 cascading test failures (`prop 87: Beta`, `LP deposits`, `prop 88: RC1`,
`writes GTM ... to vstorage`, `deploy RC2`, `deploy CCTP beta`, `makes usdc
advance`, etc.) all derive from one error in `kunser` at
`packages/kmarshal/src/kmarshal.js:103`:

```
TypeError: Float64Array is not a constructor
  at kunser (packages/kmarshal/src/kmarshal.js:103:51)
  at queueAndRun (packages/SwingSet/tools/run-utils.js:127:15)
  at async Object.evalProposal (packages/boot/tools/supports.ts:1523:5)
  at async evalReleasedProposal (packages/fast-usdc-deploy/test/walletFactory.ts:58:7)
```

Citation chain:

- `ses-2.2.0/src/permits.js:128-155`: `Float16Array`, `Float32Array`,
  `Float64Array` listed in `initialGlobalPropertyNames` (start compartment only).
- `ses-2.2.0/src/tame-nan-sidechannel.js:234-237` block comment: "Separately,
  we do not include the `Float*Array` constructors on the list of universal
  safe globals. Thus, constructed compartments do not get these by default."
- `ses-1.15.0/src/permits.js`: had `Float64Array` available to all compartments
  (no comparable initialGlobalPropertyNames split for these constructors).
- SES 2.0.0 CHANGELOG (endojs/endo#3153, "Plug NaN Side-channel"): explicit
  statement that `Float*Array` was moved out of universal globals, and that
  `@endo/marshal`'s `encodePassable.js` was refactored to use `DataView`
  methods instead of `Float64Array` so marshal itself would work in compartments.

The pre-built upstream release bundles (`fast-usdc-beta-1`,
`fast-usdc-rc1`, `fast-usdc-rc2`, `fast-usdc-cctp-b1`; published 2025-02 through
2025-05 on `Agoric/agoric-sdk` releases) embed the **pre-fix** `@endo/marshal`
source. When SwingSet evaluates these bundles inside vat child compartments
under SES 2.x, the embedded `encodePassable.js` reaches `new Float64Array(...)`
and the compartment global is undefined, surfaced as "Float64Array is not a
constructor".

The cascade shape:

- `prop 87: Beta` wraps `evalReleasedProposal('fast-usdc-beta-1', ...)` in
  `t.throwsAsync({ message: /^unsettled value for "kp[0-9]+"/ })` to tolerate
  the documented noble-ICA-misconfigured failure mode. The new `Float64Array`
  rejection does NOT match the regex, so `t.throwsAsync` fails: prop 87 ends
  red.
- The contract never instantiates. `LP deposits` fails on `vbankAsset.FastLP`
  being undefined ("Cannot read properties of undefined (reading 'brand')").
- `prop 88: RC1` runs `evalReleasedProposal('fast-usdc-rc1', ...)`, which
  similarly fails on Float64Array (after a benign 404 fallback for
  `eval-fast-usdc-reconfigure-plan.json` which doesn't exist in the rc1 tag).
- All 16 subsequent serial tests cascade against missing fastUsdc instance
  state (`no data at path published.fastUsdc`, `unsettled value for kp1152`,
  etc.).

### Revised framing

"Structural impasse" was directionally right but underdetermined. The precise
framing: **SES 2.0 deliberately removed `Float*Array` from compartment-shared
globals as a NaN side-channel hardening; the pre-built fast-usdc release
bundles cannot run inside SES 2.x vat compartments because their embedded
pre-fix marshal source still calls `new Float64Array(...)`.** This is not
"requires a strategic decision from the fixer's options menu"; it is "the
SES 2.x security hardening shipped before Agoric refreshed the released
bundles".

### Tractable angles

1. **Refresh upstream bundles**: Agoric retags the four releases with bundles
   built against `@endo/marshal >= 1.10.0` (post-DataView fix). Not in our
   control. Tractability **none in-PR**.
2. **Endow `Float64Array` in SwingSet vat compartments**: SES 2.0 CHANGELOG
   explicitly documents this as the supported escape hatch. One-line at
   `packages/SwingSet/src/supervisors/subprocess-node/supervisor-subprocess-node.js:144-148`
   (add `Float64Array: globalThis.Float64Array, Float32Array: ..., Float16Array: ...`
   to `workerEndowments`). Widens SwingSet's vat trust boundary permanently.
   Upstream Agoric/SwingSet architectural decision; out of scope for a
   mirror PR. Tractability **medium mechanically; out-of-scope politically**.
3. **Skip the released-proposal upgrade-path suite**: `test.serial.skip` on
   prop 87, prop 88, RC2, CCTP beta with TODO citing endojs/endo#3153. Removes
   4 tests directly; the cascading 16 still fail differently (no instance), so
   to skip cleanly means skipping all 22 tests in the file. Tractability
   **high mechanically; medium semantically (coverage loss)**.
4. **Widen `t.throwsAsync` regex on prop 87 to accept Float64Array** and
   add try/early-return guards on subsequent serial tests. Roughly the same
   coverage loss as 3, preserves test names. Tractability **medium**.
5. **Pin marshal/SES 1.x scoped to fast-usdc-deploy only**: not viable. SES
   is a single per-process lockdown; even workspace-scoped resolutions would
   not change which SES runs in the vat process (root-determined). Killed.
6. **Upstream `#documentation-branch:`-style override**: no analog for
   fast-usdc bundles. Killed.

### Maintainer-decision dimension

Pick one:

- (3/4) Ship the SES 2.x bump now, lose 22 tests of upgrade-path coverage on
  this PR until upstream refreshes bundles. Defensible.
- (2) Hold PR #5 open until an upstream SwingSet decision on endowing
  Float64Array; meanwhile run the rest of the gauntlet green.
- Wait for upstream Agoric to retag four releases against new marshal. Open-
  ended timeline.

### Recommended next stage

If skip-suite chosen: `next: fixer` to apply test.serial.skip + TODO.
If Float64Array-endow chosen: that becomes an upstream SwingSet PR via
boatman, separate from PR #5.
Otherwise: `next: maintainer` for the strategic decision.

## Class D: test-dapp (node-new) - downstream documentation SES 1.x pin

Confirmed framing. The job fetches `Agoric/documentation@main` (commit
`d89bd222`), runs `yarn link ../agoric-sdk --all --relative`, and yarn 4
rejects 36 link attempts with `YN0071 Cannot link X into @agoric/documentation:
dependency Y@1.10.0 conflicts with parent dependency Y@1.8.0` across `@endo/marshal`,
`@endo/errors`, `@endo/eventual-send`, `@endo/init`, `@endo/patterns`,
`@endo/promise-kit`, `@endo/pass-style`, `@endo/bundle-source`, `ses@1.14.0`
vs `ses@2.2.0`, etc.

`MAINTAINERS.md` lines 462-463 anticipate exactly this: "syncing Endo versions
will break the optional `documentation` `test-dapp` test, and that cannot be
fixed until after the Endo sync merges". The documented workflow (MAINTAINERS.md
§464-491) is to open a parallel sync-endo PR on `Agoric/documentation`, then
use the `#documentation-branch: $USER-sync-docs-$NOW` directive in PR #5's
description to point CI at the linked branch.

### Tractable angles

1. **Open parallel `Agoric/documentation` sync-endo PR + `#documentation-branch:`
   directive on PR #5**: documented workflow. Requires boatman / upstream
   identity; not bot-actionable. Tractability **out-of-scope politically**.
2. **No bot-side fix**.

### Recommendation

Framing stands. `next: maintainer` for the upstream coordination decision.

## Other classes (currently passing or still settling)

- **Class A** (`lint-primary` multichain `null == true`): resolved by fixer
  cc9bb5 on head `46b5491d` (ava ^7 bump + resolution). Current CI: SUCCESS.
- **Class B** (`test-cosmic-swingset (node-old)` SIGHUP): SUCCESS on this run.
  cb7a05's SES-pin work likely transitively resolved.
- **Class C** (`test-cosmic-swingset (node-new)`): SUCCESS.
- **Still settling** at result time: `test-boot (node-new, 0, 4)`,
  `test-boot (node-new, 2, 4)`, `test-swingset (xs, 1/2/3, 5)`. Their cohort
  siblings (node-old shards, other matrix axes) all green so probable PASS
  on settle. No new investigation lines opened.

## Tractability matrix

| Class | Root cause | Best in-PR angle | Tractability |
|---|---|---|---|
| D test-dapp | downstream documentation SES 1.x pin | none in-PR; parallel doc PR | N/A in-PR |
| E fast-usdc | SES 2.x removed Float\*Array from shared compartment globals | skip released-proposal suite | high mech / medium semantic |

## Posted

Top-level summary comment on PR #5 with @kriskowal mention:
<https://github.com/kriscendobot/agoric-sdk/pull/5#issuecomment-4713906845>

## Recommended next stage

`next: maintainer` for both Class D and Class E strategic decisions. Class E
has a viable in-PR option (skip-suite) that becomes `next: fixer` once chosen;
Class D has no in-PR option and requires upstream coordination.

Self-improvement: when a fixer surfaces a CI failure as "structural impasse"
in a tag-loaded ecosystem like SES + bundled marshal, the investigator's
high-leverage move is to read the upstream changelog at the version boundary
the fixer named. The endojs/endo#3153 release notes describe both the cause
(Float\*Array removal) and the documented escape (compartment endowment),
which is exactly the kind of precise framing the "structural impasse" tag
under-determines. The pattern: when a fixer says "pre-built X against new Y
fails", the investigator pulls Y's changelog at the bump boundary and grep
for the symbol in X's failure. Future investigators triaging SES/Endo-version
impasses on agoric-sdk should follow that path. Adding this to the
investigator's standing playbook (under "Operating norms": "When a fixer
escalates 'structural impasse' on a version bump, read the upstream changelog
at the bump boundary for explicit incompatibility notes before accepting the
impasse framing.") would compound across future Endo syncs.
