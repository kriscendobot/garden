---
ts: 2026-06-16T05:29:00Z
kind: result
role: fixer
repo: kriscendobot/agoric-sdk
project: agoric-sdk
refs:
  - entries/2026/06/16/043800Z-dispatch-fixer-a849e6.md
  - entries/2026/06/16/034928Z-result-fixer-3723ee.md
---

# Fixer: OODA cycle 3 on PR #5 (absorb-fallout sweep, 12 lint-primary errors)

OODA cycle 3 on `kriscendobot/agoric-sdk#5` per
`skills/ci-failure-classification-loop/SKILL.md`. Prior fixer 3723ee fixed
n-readlines + vats and the failure signature changed; this cycle addresses
the residual 12 in-scope lint-primary errors uncovered by the cleared
fail-fast. One Class B error (fast-usdc-deploy / @endo/common) deliberately
skipped per dispatch authorization.

## Pre / post

- Pre HEAD: `509f34b0d04f7c01b1b6b21a83e74d8a4b1ec70d` (fix(vats): reorder
  imports per import/first after absorb)
- Post HEAD: `10cc23bc10` (fix(orchestration): adopt upstream Agoric#12734
  cleanup)
- 7 commits pushed (append, no force):
  - `c659a18` fix(SwingSet): adopt upstream Agoric#12734 yargs-parser to
    node:util parseArgs
  - `43b9d74` fix(deployment): adopt upstream Agoric#12734 minimist to
    node:util parseArgs
  - `37abe3b` fix(solo): adopt upstream Agoric#12734 minimist to node:util
    parseArgs
  - `a65706f` fix(fast-usdc-contract): drop unused TypedPattern type import
  - `8a1d0de` fix(governance): mark short-circuit assertion as void
  - `70863d3` fix(internal): convert StorageNode inline @typedef import to
    @import re-export
  - `10cc23b` fix(orchestration): adopt upstream Agoric#12734 cleanup

## Per-error fix mapping

| # | Class | File | Error | Fix | SHA |
|---|---|---|---|---|---|
| 1 | C | SwingSet/misc-tools/classify-promises.js:6 | yargs-parser missing dep | adopt upstream | c659a18 |
| 2 | C | SwingSet/misc-tools/replay-transcript.js:18 | yargs-parser missing dep | adopt upstream | c659a18 |
| 3 | C | SwingSet/misc-tools/scan-9039-promises.js:13 | yargs-parser missing dep | adopt upstream | c659a18 |
| 4 | C | SwingSet/tools/vat.js:4 | yargs-parser missing dep | adopt upstream | c659a18 |
| 5 | C | deployment/src/main.js:6 | minimist missing dep | adopt upstream | 43b9d74 |
| 6 | C | solo/src/main.js:3 | minimist missing dep | adopt upstream | 37abe3b |
| 7 | C | fast-usdc-contract/src/exos/status-manager.ts:21 | unused TypedPattern | drop import | a65706f |
| 8 | C | governance/src/contractGovernance/governParam.js:55 | floating promise | wrap in void | 8a1d0de |
| 9 | C | internal/src/lib-chainStorage.js:48 | inline @typedef import | hoist + re-export | 70863d3 |
| 10 | C | orchestration/docs/types.md:1 | markdown parse error | delete (upstream did) | 10cc23b |
| 11 | C | orchestration/src/exos/icq-connection-kit.js:5 | unused VowShape companion | adopt upstream | 10cc23b |
| 12 | C | orchestration/tools/contract-tests.ts:31 | @endo/common missing dep | adopt upstream | 10cc23b |
| — | B | fast-usdc-deploy/src/utils/deploy-config.js:4 | @endo/common missing dep | SKIP per dispatch | — |

Strategy: continued the "favoring solutions pursued there" pattern from
absorb fixer d8a32b. When upstream Agoric#12734 dropped a dep
(yargs-parser, minimist, @endo/common's objectExtendEach), the source-side
refactor in upstream was adopted wholesale rather than re-adding the dep.
This keeps our delta against upstream master minimal and faithful to the
absorb's net-diff intent.

## Local validation

- `corepack yarn lint:eslint --quiet`: only the one fast-usdc-deploy Class B
  error remains; all 12 in-scope errors resolved.
- Preserved-work spot-checks (unchanged):
  - Float*Array endow at all 6 SwingSet sites (per fixer 65b4a3).
  - multichain-testing dual-AVA install (per fixer cc9bb5).
  - Endo absorb's net effect (Endo @1.5.0 / @1.10.0 / ses 2.x /
    bundle-source 4.3.2 / type fixes).
  - swingset-runner slogulator readline replacement (per fixer 3723ee).
  - vats types.ts import order (per fixer 3723ee).

## Pre-push-gates result

- 8 deterministic probes: all pass.
- `yarn format`: pass (auto-formatter reflowed the governParam.js `void(...)`
  expression onto multi-line; no semantic change).
- `yarn lint --fix`: fails on `lint:packages` (typecheck-packages errors for
  cosmic-proto / client-utils) and `lint:types` (394 inherited errors). These
  are pre-existing monorepo state per the prior fixer (3723ee) result entry's
  same observation; unrelated to this cycle.
- `yarn typecheck`: skip (no root script).

## PR comment

Posted top-level summary @-mentioning @kriskowal with the per-error mapping,
SHAs, preserved-work note, strategy note, and recommended next stage:
<https://github.com/kriscendobot/agoric-sdk/pull/5#issuecomment-4715288901>

## Recommended next stage

`next: ooda-observation`. The CI run on `10cc23bc10` will reveal whether
lint-primary now passes and the fail-fast cascade clears. The orchestrator's
next OODA cycle should:

1. Observe the new rollup once it settles.
2. Classify residuals: expected (test-dapp), structural (fast-usdc-deploy),
   tractable (anything new).
3. If lint-primary green and the cascading test-* jobs run cleanly to green,
   the loop converges; remaining reds are A+B only and the loop terminates
   per `skills/ci-failure-classification-loop/SKILL.md` § Termination
   conditions. Per recent journal context, APPROVED on a steward-owned PR
   dispatches the conductor for merge.

Self-improvement: nothing this time. The "adopt upstream wholesale" pattern
for absorb-fallout lint errors (as opposed to back-adding the dropped dep)
is now visible in 3 commits across 3 dispatches (d8a32b's package.json
absorb, 3723ee's slogulator readline, and this cycle's 12-error sweep);
the pattern is well-attested and does not yet warrant a dedicated skill.
The candidate self-improvement from fixer 3723ee (a probe that cross-checks
dropped package.json deps against still-existing imports in the same
workspace's src/) would have caught items 1-6 of this cycle automatically;
that probe is queued as a `message` to the liaison from 3723ee and remains
the highest-leverage improvement.
