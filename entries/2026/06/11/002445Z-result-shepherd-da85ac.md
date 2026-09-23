---
ts: 2026-06-11T00:24:45Z
kind: result
role: shepherd
host: endolinbot
project: agoric-sdk
repo: kriscendobot/agoric-sdk
dispatch_root: /home/kris/dispatches/shepherd--da85ac
short_id: da85ac
to: liaison
refs:
  - entries/2026/06/10/223100Z-dispatch-shepherd-e70ca8.md
  - entries/2026/06/10/222951Z-result-weaver-d3a4e9.md
  - entries/2026/06/10/181800Z-result-fixer-d6af77.md
prs:
  - repo: kriscendobot/agoric-sdk
    pr: 5
    role: target
    state: DRAFT
next: none
---

# result: shepherd PR kriscendobot/agoric-sdk#5 (da85ac)

## Pre / post head SHAs

- Pre: `02782246bb5abb4af012fae35b3072b9d82b7998` (post-weaver-rebase tip on `mirror/12527-endo-sync-refresh`).
- Post: `02782246bb5abb4af012fae35b3072b9d82b7998` (unchanged — no shepherd commits; only `gh run rerun --failed` invocations).

## Per-check terminal state (final, attempt 3 of run 27310476937)

68 SUCCESS, 12 SKIPPED, 1 FAILURE.

- **SUCCESS (68)**: `breakage`, `build (node-new)`, `build (node-old)`, `check-lockfiles`, `dependency-graph`, `flake-check`, `golangci-lint (no-failure)`, `gotest`, `lint`, `lint-primary`, `lint-rest`, `merge-strategy (chosen)`, `run-scripts-tests`, `test-boot (node-{new,old},xs)` all 12 shards, `test-codegen`, `test-cosmic-swingset (node-{new,old},xs)`, `test-fast-usdc-deploy (node-{new,old})`, `test-governance (node-{new,old})`, `test-inter-protocol (node-{new,old})`, `test-portfolio-contract (node-{new,old})`, `test-quick (node-new)` (passed on attempt 3 rerun), `test-quick (node-old)` (passed on attempt 2 rerun), `test-quick (xs)`, `test-quick2 (node-{new,old},xs)`, `test-solo (node-{new,old})`, `test-swingset (node-{new,old},xs)` all 15 shards, `test-zoe-swingset (node-{new,old},xs)`, `test-zoe-unit (node-{new,old},xs)`, `up-to-date`, `wait-integration-pre-checks`.
- **FAILURE (1)**: `test-dapp (node-new)`.
- **SKIPPED (12)**: integration-tests workflow skip path (`build-sdk-ci-image`, `deployment-test`, `finalize-integration-result`, `getting-started`, `getting-started-flag`, `linear-history`, `no-fixup-commits`, `pre_check`, `test-docker-build`, `test-multichain-e2e`, `test-ymax-planner-build`, `trigger`); not gating.

## Per-failure classification

### `test-dapp (node-new)` — environment-acknowledge

Run `27310476928`, job `80679152583`. Same shape the prior fixer `d6af77` classified: `YN0071: Cannot link` errors against the `agoric/documentation` workspace because `agoric/documentation`'s own closure pins older `@endo/*` versions (`@endo/bundle-source@4.1.2 vs 4.3.1`, `@endo/errors@1.2.13 vs 1.3.1`, `@endo/eventual-send@1.3.4 vs 1.5.0`, `@endo/init@1.1.12 vs 1.1.13`, `@endo/marshal@1.8.0 vs 1.10.0`, `@endo/pass-style@1.6.3 vs 1.8.0`, `@endo/patterns@1.7.0 vs 1.9.0`, `@endo/promise-kit@1.1.13 vs 1.2.1`). Documented in `MAINTAINERS.md` § Syncing Endo dependency versions: "At this time, syncing Endo versions will break the optional `documentation` `test-dapp` test, and that cannot be fixed until after the Endo sync merges". Same red on upstream PR #12527's `test-dapp (node-new)`. No re-run owed; environment-acknowledge.

### `test-quick (node-old)` — flake, cleared on rerun

Run `27310476937` attempt 1, job `80679830769`: failed at `packages/portfolio-deploy/test/portfolio.test.ts:69` in `test.before("bootstrap")` with `Error: Timed out waiting 900.1s for snapshot lock /tmp/agoric-sdk-test-snapshots-00424dad358d/portfolio-deploy/runutils/portfolio-ready.lock` at `acquireSnapshotLock (packages/boot/test/tools/runutils-snapshots.ts:285:13)` → `loadOrCreateCachedSnapshot (...:327:16)`. Same pre-existing test-infrastructure brittleness the prior fixer `d6af77`'s § "test-quick (node-new) flake note" documented (parallel `before('bootstrap')` hooks in `portfolio.test.ts` and `portfolio-new-contract.test.ts` race for the same `portfolio-ready.lock`; the 15-minute `SNAPSHOT_LOCK_WAIT_MS` cap is exceeded on slow CI nodes). First time this flake landed on `node-old`; prior occurrence was on `node-new`. Re-ran via `gh run rerun 27310476937 --failed` (attempt 2). Job `80686569503` on attempt 2: passed in 17m32s.

### `test-quick (node-new)` — flake, cleared on second rerun

The original `27310476937` job for `test-quick (node-new)` was cancelled by the new pushed attempt's `cancel-previous-runs` workflow. Attempt 2 rerun (job `80686569513`): failed again at the same `portfolio.test.ts:69` snapshot-lock timeout (`Timed out waiting 900.0s for ... portfolio-ready.lock`). Same flake signature as `test-quick (node-old)`. Re-ran via `gh run rerun 27310476937 --failed` (attempt 3). Attempt 3 job: passed.

## Re-runs issued

| Attempt | Trigger | Affected jobs | Outcome |
|---|---|---|---|
| 2 | `gh run rerun 27310476937 --failed` (~23:21Z) | `test-quick (node-old)`, `test-quick (node-new)` | `test-quick (node-old)` PASS; `test-quick (node-new)` FAIL (same flake) |
| 3 | `gh run rerun 27310476937 --failed` (~23:53Z) | `test-quick (node-new)` | PASS |

## Shepherd-side commits

None. No in-scope substance to fix.

## PR comments posted

Per dispatch brief authorization:

- **Convergence summary** (top-level): <https://github.com/kriscendobot/agoric-sdk/pull/5#issuecomment-4675988168>
- **Directive reply** to `4675167395`: <https://github.com/kriscendobot/agoric-sdk/pull/5#issuecomment-4675989682>

No review re-request (PR is DRAFT per dispatch).

## Cross-verification with prior fixer's `d6af77` diagnosis

The prior fixer noted "First terminal completion of `test-quick (node-new)` on this PR's history ... failed in `packages/portfolio-deploy/test/portfolio.test.ts`'s `before('bootstrap')` hook with `Timed out waiting 900.1s for snapshot lock`. ... This is a pre-existing test-infrastructure brittleness, not something my fix introduced." This shepherd's observation confirms the diagnosis carries across the weaver's rebase to upstream master tip `57c65644e1`: the same `portfolio.test.ts` snapshot-lock race fires on both `node-old` and `node-new` independently. Future fixer/scout work could:

- (a) bump `SNAPSHOT_LOCK_WAIT_MS` (currently `15 * 60_000` in `packages/boot/test/tools/runutils-snapshots.ts:6`) to 25-30 min;
- (b) set `serial: true` in `packages/portfolio-deploy/package.json` § ava;
- (c) serialize the two test files' `before('bootstrap')` hooks via a shared mutex.

All three are out of scope for shepherd. Noting for the next fixer or scout encountering this PR's flake budget.

The weaver's rebase onto upstream master picked up upstream's ava state directly, so the prior fixer's ava-restore commit `cf798d660e` and yarn.lock follow-ups are still in the head SHA's history (commits `181a10e25d`, `425ffc4e49`) and the test-quick flake here is purely the snapshot-lock race, NOT a recurrence of the `runnerChain` cascade the prior fixer rooted. (`runnerChain` would have manifested as `AssertionError: null == true` at `ava/lib/worker/main.cjs:8`; the failure logs show only the snapshot-lock timeout.)

## Recommended next stage

`next: none`. PR #5 is review-ready. The single FAILURE is the documented environment-acknowledge that the prior fixer's `d6af77` already classified and that upstream PR #12527 carries with the same shape. The PR remains DRAFT per dispatch (the maintainer is watching directly); the stated purpose is the bot-side mirror of `Agoric/agoric-sdk#12527` for ferry. Whether to re-ferry to #12527 with the new head and base is the maintainer's call (and the boatman dispatch is host-gated to the credentialed host).

Self-improvement: shepherd dispatch's "watch CI to convergence" plus the `pr-ci-watch` skill played cleanly with the `Monitor` tool's persistent stream and `gh run rerun --failed` to drive a 1-of-3 → 2-of-3 → 3-of-3 rerun chain. The prior fixer `d6af77`'s note that the snapshot-lock race is pre-existing test-infrastructure brittleness, not introduced by this PR, was the directive that let me classify both reds as flake-shaped without diagnosing source from scratch. Worth noting in this skill's procedure: when a prior result entry on the same PR has already classified a flake signature, a shepherd dispatch can cite-and-rerun rather than re-diagnose. Below threshold for a separate skill or role edit; documenting here.
