---
ts: 2026-06-13T17:18:30Z
kind: result
role: shepherd
host: endolinbot
repo: kriscendobot/agoric-sdk
project: agoric-sdk
to: liaison
dispatch_root: /home/kris/dispatches/shepherd--04c6a8
prs:
  - repo: kriscendobot/agoric-sdk
    pr: 5
    role: target
refs:
  - https://github.com/kriscendobot/agoric-sdk/pull/5
  - https://github.com/kriscendobot/agoric-sdk/pull/5#issuecomment-4699231124
  - entries/2026/06/13/072800Z-dispatch-shepherd-1bd911.md
---

# result: shepherd — lint-primary fix; node-old failures out of scope

## Push

- `460035eb5d` `fix(lint): split nested await in provideSmartWallet for safe-await-separator` on `mirror/12527-endo-sync-refresh`.

## Per-failure terminal state and classification (head `2cc75c3491`)

| Job | State | Classification | Action |
| --- | --- | --- | --- |
| `lint-primary` | FAILURE | substance, in-scope | Fixed by `460035eb5d` |
| `test-dapp (node-new)` | FAILURE | env-acknowledge | MAINTAINERS.md § 463: documented expected-fail until endo sync merges |
| `test-quick (node-old)` | FAILURE | substance, out-of-scope | runnerChain cascade in `@endo/ses-ava` test runner; `next: fixer` |
| `test-quick2 (node-old)` | FAILURE | substance, out-of-scope | same root cause; `next: fixer` |
| `test-portfolio-contract (node-old)` | FAILURE | substance, out-of-scope | same root cause; `next: fixer` |
| `test-fast-usdc-deploy (node-new)` | FAILURE | unknown | needs re-verification on new head |
| `test-swingset (node-old, 2, 5)` | FAILURE | substance, platform-sensitive | metering tests expect `'created'`, get `undefined`; test source comment says "adjust the remaining computrons figure if this test fails due to platform changes" |

## Root-cause notes

### lint-primary

The prior shepherd's `fix(types): satisfy typecheck-tsgo` commit wrapped an `await` in parens to apply `as ERef<Bank>` in `packages/boot/tools/drivers.ts`. That made it the first nested `await` of the async function, violating `@jessie.js/safe-await-separator`. Split into a `const bankResult = await ...; const bank = bankResult as ERef<Bank>;` pair.

### runnerChain cascade on node-old only

Uncaught exception `assert.ok(refs.runnerChain)` repeats in many test files (chain-hub-transfer-routes, chain-hub, debug-*.test.js, noble-fwd-calc.test.ts, etc.). The string `runnerChain` does not appear anywhere in the project source; it is internal to the test runner shipped with the endo sync (likely `@endo/ses-ava/prepare-endo.js` or its `ava` dependency). `node-new` jobs pass on the same code, so this is a node-engine-specific regression introduced by the endo bump. Not addressable within the shepherd's surgical-fix scope on this PR's source diff.

### test-swingset metering on node-old (2, 5)

`metering › dynamic-vat-metered › exceed allocate / per-crank compute / stack` time out and return `status: undefined` instead of `'created'`. The test source itself documents this as a platform-tunable threshold ("adjust the remaining computrons figure if this test fails due to platform changes"). Tuning is fixer-territory, but only worthwhile if the runnerChain regression is resolved first.

## Re-runs issued

None. Two prior shepherd attempts had already worked on this matrix; the failure patterns are not transient flakes (consistent `assert.ok(refs.runnerChain)` across `node-old` runs and across test files). Re-running would burn CI minutes without changing the outcome.

## Convergence-summary comment

Posted: <https://github.com/kriscendobot/agoric-sdk/pull/5#issuecomment-4699231124>

## Recommended next stage

**`next: fixer`**, with the following framing for the fixer dispatch:

- The lint-primary failure is already fixed by `460035eb5d`; that should clear after CI re-runs.
- The `test-dapp (node-new)` failure stays as env-acknowledged per MAINTAINERS.
- The `runnerChain` cascade on `node-old` is the substance gap. Fixer should investigate whether a workspace-level pin (older `@endo/ses-ava` or `ava` version compatible with both node-old and the endo sync), a test-prelude shim, or a node-old-only skip-by-MAINTAINERS-doc is feasible. If none, escalate further to designer for whether `node-old` matrix entries should be temporarily disabled for this PR.
- The `test-swingset (node-old, 2, 5)` metering tuning is downstream of the runnerChain fix and should be touched in the same fixer pass only if straightforward.

## Self-improvement

Two prior shepherd attempts stalled on this same PR. The brief's explicit "push lint fix first, then end the turn" strategy worked. The shepherd skill could benefit from a norm that says "when you find a test failure whose triggering symbol is not in the project source, classify out-of-scope immediately and do not chase it" — that would have saved one of the prior attempts from spending its budget there. Will draft a `message` to liaison if this pattern recurs.

Self-improvement: nothing landed this dispatch; noted the "symbol-not-in-source means test-runner-internal regression" heuristic for shepherd's future iteration.
