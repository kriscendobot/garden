---
ts: 2026-06-10T18:18:00Z
kind: result
role: fixer
host: endolinbot
project: agoric-sdk
repo: kriscendobot/agoric-sdk
dispatch_root: /home/kris/dispatches/fixer--d6af77
short_id: d6af77
to: liaison
refs:
  - entries/2026/06/10/151500Z-dispatch-fixer-d6af77.md
  - entries/2026/06/10/043918Z-result-shepherd-39f4a0.md
  - entries/2026/06/10/041600Z-result-fixer-c39b42.md
  - entries/2026/06/10/035700Z-result-shepherd-528eb6.md
prs:
  - repo: kriscendobot/agoric-sdk
    pr: 5
    role: mirror
    state: DRAFT
next: none
---

# result: fixer PR kriscendobot/agoric-sdk#5 (d6af77)

## Pre / post SHAs

- Pre: `cc64691f78` (prior fixer's `chore: Update yarn.lock`; head per dispatch brief).
- Post: `b69f426410` (HEAD on `mirror/12527-endo-sync-refresh`, append-pushed via `git push origin HEAD:mirror/12527-endo-sync-refresh`; the dispatch prompt said `bot` remote, but `origin` IS the bot fork remote in this project worktree).

Three new commits on top of `cc64691f78`:

| SHA | Title | Substance |
|---|---|---|
| `cf798d660e` | `chore(deps): restore ava ^7.0.0 across workspaces` | Restore `ava ^7.0.0` and `@fast-check/ava ^3.0.1` in 29 package.json files to match `master-daf7a86` (`@endo/ses-ava` left at `^1.4.0` because that bump is part of the legitimate Endo sync). |
| `c81cab79cf` | `chore: Update yarn.lock` | Reconcile root `yarn.lock` to the restored ava versions (41 +/307 -). |
| `b69f426410` | `chore(a3p-integration): refresh yarn.lock and pin @endo/promise-kit / ses` | Refresh top-level `a3p-integration/yarn.lock` (newer @endo/* patch versions); add two `resolutions` to force single `@endo/promise-kit` and `ses` versions, eliminating the `YN0071 Cannot link` errors that arose between published `@agoric/synthetic-chain`'s closure and the parent SDK's portal-linked @endo packages. |

## Diagnosis: the `runnerChain` cascade

The shepherd 39f4a0 named this as `rebase-delta-intrinsic` and recommended either the full `yarn up` bump walk or splitting the Endo bump into a separate PR. The actual root cause turned out to be narrower and more targetable than either path: the cherry-pick from `Agoric/agoric-sdk#12527` (which predates master commit `51cb8ec4e0` "chore(deps): bump ava to ^7.0.0 across workspaces") reverted `ava ^7.0.0` to `ava ^6.4.1` in 29 package.json files when it landed on `master-daf7a86`. Same reversion shape for `@fast-check/ava ^3.0.1 → ^1.1.5` (or `^2.0.1` in some workspaces).

Reproduced locally with `cd packages/inter-protocol && npx ava test/clientSupport.test.js`:
```
AssertionError [ERR_ASSERTION]: null == true
  at TracingChannel.traceSync (node:diagnostics_channel:328:14)
```

The stack trace was misleading. `node:diagnostics_channel:328` is where Node v22's `TracingChannel.traceSync` wraps the module loader via `start.runStores`. The actual assertion fires at `ava/lib/worker/main.cjs:8`:
```js
const {flags, refs} = require('./state.cjs');
assert(refs.runnerChain);
```

`refs.runnerChain` is set by `ava/lib/worker/base.js:89` (`refs.runnerChain = runner.chain`) when the ava worker spawns. The CJS module cache (`state.cjs` is the singleton holding the references) is per-physical-file. So if base.js and main.cjs load different physical `state.cjs` files, the assignment in one doesn't survive to the other.

Local instrumentation (added `console.error` to base.js's `refs.runnerChain = runner.chain` line and `fs.writeSync(2, ...)` to main.cjs's assertion site) confirmed:
- base.js (the worker entry) ran from `packages/inter-protocol/node_modules/ava@6.4.1/lib/worker/base.js` and set `refs.runnerChain` correctly in v6.4.1's state.cjs.
- main.cjs (loaded by the test file's `import 'ava'` chain via `@agoric/swingset-vat`) never executed at all from v6.4.1's path. Instead it loaded from `node_modules/ava@7.0.0/lib/worker/main.cjs` (because `@agoric/swingset-vat` declares `ava ^7.0.0` and yarn hoists it to root).
- v7.0.0's `state.cjs` is a separate physical file with its own module cache entry. Its `refs.runnerChain` was never set; the assertion fired `null == true`.

The mixed ava major versions across the workspace mean any test file that imports `@agoric/swingset-vat/tools/prepare-test-env-ava.js` (which is most SwingSet-bootstrapped tests) hits this mismatch when its workspace declares ava 6 locally. The shepherd's prior identification of `runnerChain` as the dominant failure signature was exactly right; the root cause was just upstream of where the prior diagnosis put it.

### Files affected by the restore

29 package.json files: `multichain-testing` (no — `@endo/ses-ava` only, intentional sync bump; reverted), `packages/ERTP`, `packages/SwingSet` (no — `@endo/ses-ava` only), `packages/base-zone`, `packages/builders`, `packages/casting`, `packages/deploy-script-support`, `packages/fast-usdc-deploy`, `packages/governance`, `packages/inter-protocol`, `packages/internal`, `packages/kmarshal`, `packages/network`, `packages/notifier`, `packages/orchestration`, `packages/portfolio-contract`, `packages/smart-wallet`, `packages/solo`, `packages/spawner`, `packages/store`, `packages/swingset-xsnap-supervisor`, `packages/telemetry`, `packages/time`, `packages/vat-data`, `packages/vats`, `packages/vow`, `packages/wallet/api`, `packages/xsnap-lockdown`, `packages/xsnap`, `packages/zoe`, `packages/zone`.

Per-package version restorations applied by a Node script that reads each file's daf7a864 version from git, copies `ava` and `@fast-check/ava` from `devDependencies` / `dependencies` / `peerDependencies` sections, and writes back. `@endo/ses-ava` deliberately excluded (its bumps in this PR are part of the Endo sync).

## Class 2 fix: a3p-integration `lint-rest`

The shepherd's Class 2 was the YN0028 in lint-rest's `cd a3p-integration && yarn install && yarn doctor` step. After my ava restore, that lockfile drift persisted: yarn 4.12.0 in CI's hardened mode (PR context) refuses to update lockfile in place; newer `@endo/captp 4.5.1 / check-bundle 1.1.1 / common 1.4.0 / errors 1.3.1 / eventual-send 1.5.0 / marshal 1.10.0 / pass-style 1.8.0 / promise-kit 1.2.1` versions are now in npm.

Running `cd a3p-integration && corepack yarn install` refreshed the lockfile but then `yarn install --immutable` failed with `YN0071: Cannot link`:
- `@endo/import-bundle@1.6.1` dep `ses@^1.13.0` conflicts with tree `ses@2.0.0`
- `@endo/bundle-source` (portal-linked) dep `@endo/promise-kit@1.2.1` conflicts with `@agoric/swingset-vat@dev-c393dc4`'s `@endo/promise-kit@1.2.0`

These two pinning conflicts are semver-compatible but yarn's node-modules linker requires exact matches for parent-child relations. Added two top-level resolutions in `a3p-integration/package.json`:
```json
"@endo/promise-kit": "npm:^1.2.1",
"ses": "npm:^2.0.0"
```

After: `yarn install --immutable` exits clean.

## Verification

- Local: `cd packages/inter-protocol && npx ava test/clientSupport.test.js` → passes (was the failing reproducer pre-fix).
- Local: `cd packages/inter-protocol && npx ava test/feeDistributor.test.js` → passes (4 tests).
- Local: `cd packages/inter-protocol && npx ava test/swingsetTests/fluxAggregator/fluxAggregator-service-upgrade.test.js` → passes (1 test, 24.9s).
- Local: `cd packages/inter-protocol && npx ava test/swingsetTests/psmUpgrade/psm-upgrade.test.js` → passes (1 test, 26.7s).
- Local: `corepack yarn install --immutable` at root → PASS (no YN0028).
- Local: `corepack yarn build` at root → PASS (clean compile, 31s).
- Local: `cd a3p-integration && corepack yarn install --immutable` → PASS (no YN0028, no YN0071).
- Local: `corepack yarn workspace @agoric/inter-protocol lint:eslint` → no errors.
- Local: `corepack yarn workspace @agoric/inter-protocol lint:types` → no errors.

## CI state at result time

PR head `b69f426410` on run `27289408321`.

- PASS: 68 of 69 substantive checks. Includes `test-quick (node-new)` (passed on rerun after a one-shot snapshot-lock flake; node-old and xs passed first try), all `test-boot (*)` shards, all `test-swingset (*)` shards, all `test-zoe-unit (*)`, all `test-quick2 (*)`, `test-inter-protocol`, `test-solo`, `test-fast-usdc-deploy`, `test-portfolio-contract`, `test-governance`, `test-cosmic-swingset (*)`, `lint-rest`, `lint-primary`, `dependency-graph`, `build (*)`, plus the rest of golang/lint/lockfile checks.
- FAIL: 1. `test-dapp (node-new)` — documented expected-fail per `MAINTAINERS.md` § Syncing Endo dependency versions. The job fails at `yarn link ../agoric-sdk --all --relative` with ~50 `YN0071 conflicts with parent dependency @endo/<pkg>@npm:<old>` errors because `agoric/documentation` has not been updated yet. Same shape as upstream PR #12527's `test-dapp (node-new)` red. Acceptable to environment-acknowledge.

## `test-quick (node-new)` flake note

First terminal completion of `test-quick (node-new)` on this PR's history (cc64691f78 → c81cab79cf → b69f426410 — the latter two cancelled by the next push, the latest ran to terminal). The first run on `b69f426410` failed in `packages/portfolio-deploy/test/portfolio.test.ts`'s `before('bootstrap')` hook with `Timed out waiting 900.1s for snapshot lock /tmp/agoric-sdk-test-snapshots-*/portfolio-deploy/runutils/portfolio-ready.lock`.

The 15-minute lock timeout (`SNAPSHOT_LOCK_WAIT_MS = 15 * 60_000` in `packages/boot/test/tools/runutils-snapshots.ts`) was exceeded because `portfolio-new-contract.test.ts`'s parallel `before('bootstrap new-contract snapshot')` was holding the `portfolio-ready.lock` while creating its snapshot (the new-contract path internally calls `loadOrCreatePortfolioSnapshot('portfolio-ready')` first, acquiring the same lock). On node-old, both bootstraps completed in ~9 minutes well within the window. On node-new the same workload exceeded 15 minutes. The rerun (no source change) passed: `test-quick (node-new)` ran from ~17:00 to ~17:56, with the portfolio.test.ts bootstrap completing within window.

This is a pre-existing test-infrastructure brittleness, not something my fix introduced. Future work could either (a) bump `SNAPSHOT_LOCK_WAIT_MS` to 25-30 minutes for slow CI nodes, or (b) set `serial: true` in `packages/portfolio-deploy/package.json` § ava to prevent the two test files from racing. Both are out of scope for this fixer dispatch.

## PR comments posted

Per the dispatch brief's per-action authorizations (fixer's standing authorization for top-level summary comment under `roles/COMMON.md` § External-repo etiquette, per the maintainer's iterate-until-green directive that arrived as comment 4673074594):

- Top-level "what landed" summary: <https://github.com/kriscendobot/agoric-sdk/pull/5#issuecomment-4673115591>

No re-request of review (PR is DRAFT per dispatch authorization; the maintainer is watching directly).
No PR-body redraft (the dispatch did not ask for one).

## Recommended next stage

`next: none`. The PR's CI is green except for the documented expected-fail `test-dapp (node-new)` per MAINTAINERS.md. The PR is ready for maintainer review and the maintainer's next step is upstream-PR-mirror review on `Agoric/agoric-sdk#12527` (this PR's stated purpose). No further fixer work is queued.

If the maintainer prefers the broader path (the prior fixer's deferred `yarn up ses '@endo/*' -R` walk + 40+ TypeScript regressions in a separate PR), that's a separate dispatch with its own scope. This PR's minimum-net-diff achieved the green-CI target.

Self-improvement: the `runnerChain` assertion stack trace pointed at `node:diagnostics_channel:328:14` (Node's TracingChannel wrapping the module loader), which was misleading. The actual assertion source was `ava/lib/worker/main.cjs:8`, but only after recognizing that `node:diagnostics_channel:328` is a generic wrap-point for any synchronous module load operation in v22+. Future debugging of "assertion at node:diagnostics_channel" should immediately bypass that frame and look at the assert site itself (the assertion's `message` field tells you where, e.g. `assert(refs.runnerChain)`). Below threshold for a separate `skills/<skill>/SKILL.md` lesson; noting here in case a future fixer or shepherd encounters the same noise.
