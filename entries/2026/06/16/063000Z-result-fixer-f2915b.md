---
ts: 2026-06-16T06:30:00Z
kind: result
role: fixer
repo: kriscendobot/agoric-sdk
project: agoric-sdk
refs:
  - entries/2026/06/16/061800Z-dispatch-fixer-f2915b.md
  - entries/2026/06/16/052900Z-result-fixer-a849e6.md
---

# Fixer: OODA cycle 4 on PR #5 (final lint sweep, dependency-graph, cascade verdict)

OODA cycle 4 on `kriscendobot/agoric-sdk#5` per
`skills/ci-failure-classification-loop/SKILL.md`. Prior fixer a849e6 cleared
the 12 in-scope lint-primary errors; this cycle addresses the 1 residual
lint-primary error (deferred from a849e6), the lint-rest engines.node
mismatch, and the dependency-graph TS2322 regression. Test-cascade
hypothesis verified.

## Pre / post

- Pre HEAD: `10cc23bc10fa07ca90d36b11f47c60f3c6d25e3f`
  (fix(orchestration): adopt upstream Agoric#12734 cleanup)
- Post HEAD: `d019de698e` (chore: Update yarn.lock)
- 5 commits pushed (append, no force):
  - `2759cce8e5` fix(fast-usdc-deploy): add @endo/common dep for objectExtendEach
  - `b726c4ef10` chore: Update yarn.lock
  - `031c133cb1` fix(engines): adopt upstream Agoric#12734 node 22-only requirement
  - `0e96c47faa` fix(orchestration): restore objectExtendEach in contract-tests prepack
  - `d019de698e` chore: Update yarn.lock

## Classification (cycle 4, head 10cc23bc10)

| Class | Job | Signature | Disposition |
| --- | --- | --- | --- |
| A | test-dapp (node-new) | docs dapp endo skew | skip (maintainer-authorized 2026-06-15) |
| B | (none) | | test-fast-usdc-deploy NOW PASSES |
| C | lint-primary | fast-usdc-deploy missing @endo/common dep | fix 2759cce8e5 |
| C | lint-rest | yarn.config.cjs engines.node mismatch | fix 031c133cb1 |
| C | dependency-graph | orchestration tools/contract-tests.ts TS2322 | fix 0e96c47faa |
| C/cascade | 24 test-* matrix jobs | cancelled by upstream lint/dep-graph fail | expected to clear |
| D | (none) | | |

## Per-fix SHA mapping

| # | Class | Scope | Fix | SHA |
|---|---|---|---|---|
| 1 | C | fast-usdc-deploy package.json | add `@endo/common@^1.4.0` | 2759cce8e5 |
| 1L | C | yarn.lock | regen | b726c4ef10 |
| 2 | C | yarn.config.cjs + 9 packages | adopt upstream `'^22.11'` engines | 031c133cb1 |
| 3 | C | orchestration tools/contract-tests.ts + package.json | restore objectExtendEach for type-correlation; add @endo/common dep | 0e96c47faa |
| 3L | C | yarn.lock | regen | d019de698e |

## Cascade verdict

**Verified: cascade, not real failure.** Examined
`test-swingset (node-old, 0, 5)` log (job 81587650602): all tests up to
06:04:18 passed (✔), then `##[error]The operation was canceled.`
indicating workflow-level fail-fast killed downstream test jobs because
lint-primary / lint-rest / dependency-graph failed earlier in the same
`Test all Packages` workflow's job graph. Once those three pass, the
matrix should run to green (modulo Class A's test-dapp).

## Strategy

The cycle continues the "favoring solutions pursued there" pattern but
with a refinement: cycle 3's adoption of upstream Agoric#12734's
`objectMap` substitution in `orchestration/tools/contract-tests.ts`
introduced a TS2322 regression that breaks `prepack`. The deploy-config.js
sibling carries an explanatory comment about exactly this trade-off
(`objectExtendEach` preserves K's correlation; `objectMap` does not).
Restore `objectExtendEach` in `contract-tests.ts` and add the `@endo/common`
dep that orchestration now needs. The upstream cleanup commit's intent
(retain the comment) is preserved by re-adding it.

## Local validation

- `corepack yarn lint:eslint packages/fast-usdc-deploy/src/utils/deploy-config.js`:
  0 errors, 8 pre-existing warnings.
- `corepack yarn constraints`: 0 errors post-fix.
- pre-push-gates: 8 probes pass, yarn format pass, yarn lint fails on
  pre-existing 2119 `lint:types` / `lint:packages` inherited errors
  (unchanged from prior cycle; unrelated to this cycle's changes).

## PR comment

Posted top-level summary @-mentioning @kriskowal with the cycle-4
classification, per-fix SHA mapping, the major win note
(`test-fast-usdc-deploy` PASSES), and the cascade verdict:
<https://github.com/kriscendobot/agoric-sdk/pull/5#issuecomment-4715646577>

## Recommended next stage

`next: ooda-observation`. The CI run on `d019de6` will reveal whether
lint-primary / lint-rest / dependency-graph now pass and whether the 24
test-* matrix jobs clear as the cascade hypothesis predicts. The
orchestrator's next OODA cycle should:

1. Observe the new rollup once it settles.
2. Classify residuals: expected (test-dapp), regression (any test that
   was green and went red), tractable (anything new).
3. If lint-primary / lint-rest / dependency-graph green and the cascading
   test-* jobs run cleanly to green, the loop converges; only Class A
   remains red and the loop terminates per
   `skills/ci-failure-classification-loop/SKILL.md` § Termination
   conditions. Per recent journal context, APPROVED on a steward-owned PR
   dispatches the conductor for merge.

Self-improvement: nothing this time. The pattern of cycle 3 adopting an
upstream substitution and introducing a regression covered by the
sibling file's explanatory comment suggests a leverage point: when
adopting upstream wholesale (the d8a32b / 3723ee / a849e6 pattern), check
sibling files for explanatory comments that document type-correlation or
similar invariants the upstream substitution would silently break. The
candidate "dropped-dep cross-check probe" from fixer 3723ee remains the
highest-leverage improvement and is already on the liaison's queue;
adding "sibling-comment cross-check" might be a second probe, but the
sample size (one case so far) is too small to land yet.
