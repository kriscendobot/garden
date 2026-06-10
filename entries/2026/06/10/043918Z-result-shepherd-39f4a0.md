---
ts: 2026-06-10T04:39:18Z
kind: result
role: shepherd
host: endolinbot
project: agoric-sdk
repo: kriscendobot/agoric-sdk
dispatch_root: /home/kris/dispatches/shepherd--39f4a0
short_id: 39f4a0
to: liaison
refs:
  - entries/2026/06/10/041600Z-result-fixer-c39b42.md
  - entries/2026/06/10/035700Z-result-shepherd-528eb6.md
  - entries/2026/06/10/035300Z-dispatch-shepherd-528eb6.md
prs:
  - repo: kriscendobot/agoric-sdk
    pr: 5
    role: mirror
    state: DRAFT
next: fixer
---

# result: shepherd PR kriscendobot/agoric-sdk#5 (39f4a0)

## Subject

Convergence verification after fixer c39b42's `chore: Update yarn.lock` push at `cc64691f78`. YN0028 immutable-lockfile gate is cleared (`build (node-new)` and `build (node-old)` both PASS). However, a substantial new band of test failures has surfaced that was previously masked by the install-gate red. The pattern does not appear on upstream PR Agoric/agoric-sdk#12527, so it is not Endo-bump-intrinsic; it is an artifact of the bot mirror's rebase onto current `master-daf7a86` combined with the prior fixer's minimal-deferral choice.

## Pre / post SHAs

Pre and post are the same; no push from this shepherd. The fixer's `cc64691f78` is the head observed.

## CI snapshot at result time

Final counts after waiting for terminal convergence (the long-running `test-boot` shards and `test-cosmic-swingset` are still in progress; the failure pattern is independent of their outcome):

- PASS: 20 checks. Includes `build (node-new)`, `build (node-old)`, `lint`, `breakage`, `up-to-date`, `gotest`, `golangci-lint (no-failure)`, `merge-strategy (chosen)`, `run-scripts-tests`, `flake-check`, `test-zoe-unit (xs)`, `wait-integration-pre-checks`, and lockfile/preflight checks.
- FAIL: 38 checks. Classification below.
- PENDING: 11 checks (long-running test-boot shards and cosmic-swingset, expected to flip to FAIL based on the dominant pattern).
- SKIPPING: 11 (workflow gating).

## Verification: `test-dapp (node-new)` reaches MAINTAINERS-documented expected-fail

The fixer's "## CI state at result time" predicted the YN0028 gate clearance would let `test-dapp (node-new)` reach the documented failure substance. Verified true.

The job at run 27252744719 / job 80480476344 fails at the step `point dapp to agoric-SDK HEAD` running `yarn link ../agoric-sdk --all --relative`, producing ~50 `YN0071 Cannot link ... dependency @endo/<pkg>@npm:<new> conflicts with parent dependency @endo/<pkg>@npm:<old>` errors. Examples:

- `Cannot link @agoric/cosmic-swingset into @agoric/documentation@workspace:. dependency @endo/bundle-source@npm:4.3.1 conflicts with parent dependency @endo/bundle-source@npm:4.1.2`
- `Cannot link @agoric/zoe into @agoric/documentation@workspace:. dependency @endo/pass-style@npm:1.8.0 conflicts with parent dependency @endo/pass-style@npm:1.6.3`

This is the exact shape MAINTAINERS § Syncing Endo dependency versions documents: the companion change on agoric/documentation has not landed, so the link step exposes the cross-fork version skew. The PR body's expected-fail framing applies. Acceptable to environment-acknowledge.

## Failure classification (the rest)

### Class 1 — Expected-fail per MAINTAINERS (1 check)

- `test-dapp (node-new)` — verified above.

### Class 2 — YN0028 lockfile-mismatch in lint-rest's `yarn install && yarn doctor` (1 check)

- `lint-rest` (job 80480943937) fails at step `yarn install && yarn doctor` with `YN0028: The lockfile would have been modified by this install`. The yarn version here is **4.12.0** (vs the **4.6.0** used by `build`, which passed under `yarn install --immutable`). 4.12.0's fresh resolution upgrades `@endo/captp@^4.5.0 -> 4.5.1`, `@endo/check-bundle@^1.1.0 -> 1.1.1`, `@endo/common@^1.3.0 -> 1.4.0`, `@endo/errors@^1.2.13 -> 1.3.1`, `@endo/eventual-send@^1.3.4 -> 1.5.0` (the `YN0085 +` add list in the log). The fixer's local environment resolved to the older patch versions because of stale npm-metadata caching; the lockfile committed those older versions.

Root cause: the lockfile commit was authored against stale npm metadata. A re-run of `yarn install` in CI-matching conditions (4.12.0 fresh resolution) would produce the canonical lockfile that satisfies both yarn versions on the immutable side.

### Class 3 — Real test regression from rebase + partial-deferral Endo path (~30 checks)

The dominant pattern across the failing test workflows is `AssertionError [ERR_ASSERTION]: The expression evaluated to a falsy value: assert(refs.runnerChain)` printed in TAP output. Examples confirmed:

- `test-inter-protocol (node-old)`: 34 failures including `test/swingsetTests/fluxAggregator/fluxAggregator-service-upgrade.test.js`, `test/swingsetTests/psmUpgrade/psm-upgrade.test.js`, `test/swingsetTests/reserve/assetReserve-upgrade.test.js`, all citing `assert(refs.runnerChain)` as the falsy expression.
- `test-solo (node-old)`: `test/home.test.js` (`packages/solo/test/home.test.js`) fails on the same `assert(refs.runnerChain)`.
- `test-fast-usdc-deploy (node-old)`: `test/fast-usdc.test.ts`, `test/chain-impact.test.ts`, `test/utils/config-marshal.test.js`, `test/utils/chain-policies.test.ts`, all on the same `refs.runnerChain` falsy assertion.
- `test-quick (xs)`: same pattern across `test/swingsetTests/ertpService/ertp-service-upgrade.test.js`, `test/swingsetTests/basicFunctionality/basicFunctionality.test.js`, etc.
- `test-swingset (node-new, 0, 5)`: many `Uncaught exception in test/abandon-export.test.js`, `test/activityhash-vs-start.test.js`, etc., with stack trace bottoming at `/home/runner/work/agoric-sdk/agoric-sdk/packages/internal/node_modules/ava/lib/worker/main.cjs:8:1` showing `AssertionError [ERR_ASSERTION]: null == true`.

A secondary signature appears in `test-portfolio-contract (node-new)`, `test-governance (node-new)`, `test-zoe-unit (node-new)`: `YAMLException: unacceptable kind of an object to dump [object Undefined]` from `node_modules/supertap/node_modules/js-yaml/lib/js-yaml/dumper.js:779` via `TapReporter.writeCrash` (`packages/portfolio-contract/node_modules/ava/lib/reporters/tap.js:111:36`). This is downstream of the same condition: the supertap reporter is asked to YAML-dump a failure detail that is `undefined` because of the upstream crash.

The `refs.runnerChain` identifier does not appear in the source tree on any branch (master, upstream-pr-12527, mirror/12527-endo-sync-refresh, or any imported package). The most likely sources are built/bundled code or a runtime-generated bootstrap-relay artifact. Investigation in this dispatch did not pin the origin; pinning it requires running the failing test locally with the CI's exact resolved tree (which the prior fixer's local-yarn-4.6.0 path did not produce).

### Comparison to upstream PR #12527's CI

I checked all the same job names on Agoric/agoric-sdk#12527 (the source PR this mirror tracks). All of them are SUCCESS there:

- `test-quick (node-new/node-old/xs)`: SUCCESS
- `test-quick2 (node-new/node-old/xs)`: SUCCESS
- `test-governance (node-new/node-old)`: SUCCESS
- `test-portfolio-contract (node-new/node-old)`: SUCCESS
- `test-swingset (xs/node-new/node-old, 0-4, 5)`: SUCCESS (all 15 shards)

The only failure on upstream PR #12527 is `test-dapp (node-new)` (Class 1, same shape as here). So Class 3 is **not** Endo-bump-intrinsic; it is the delta between this mirror's head and upstream PR's head, which is the rebase onto current `master-daf7a86` combined with the prior fixer's choice of the minimal-deferral path.

## Why this is beyond shepherd scope

The shepherd's hard escalation points include "Public-API rewrites or behavior changes that need a design decision" and "Changes that would touch more than ~5 files or rewrite logic spanning multiple modules." Class 3 is the second of those: ~30 distinct test files across `packages/SwingSet`, `packages/ERTP`, `packages/zoe`, `packages/fast-usdc-deploy`, `packages/portfolio-contract`, `packages/governance`, `packages/inter-protocol`, `packages/solo`, `packages/agoric-cli` all fail on the same bootstrap-level assertion. The fix is either (a) the full `yarn up ses '@endo/*' -R` walk the prior fixer documented as deferred (40+ TypeScript errors to absorb), or (b) splitting the Endo bump into a separate follow-up PR per the prior fixer's "tractable next dispatch" note.

The prior shepherd (528eb6, the dispatcher that produced the fixer dispatch this one verifies) named the trade-off explicitly: clear CI on the existing substance vs. complete the deferred bump. The minimal path is now shown to be insufficient for the bot mirror's rebased base, even though it was sufficient for upstream PR #12527's original base.

## PR comments posted

Per the dispatch brief's authorization for the convergence summary and the directive reply:

- Top-level convergence summary on PR #5: <https://github.com/kriscendobot/agoric-sdk/pull/5#issuecomment-4666577263>
- Reply on kriskowal's directive comment 4662462430 ("Pray shepherd."): <https://github.com/kriscendobot/agoric-sdk/pull/5#issuecomment-4666578710>

No CI-fix push was made by this shepherd (Class 3 is beyond surgical scope; Class 2 is best handled by the fixer in the next cycle alongside Class 3).

## Recommended next stage

`next: fixer`, with a wider brief than the prior fixer:

1. Take the full `yarn up ses '@endo/*' -R` walk per MAINTAINERS, including the catalog block in `.yarnrc.yml` and per-proposal walks the prior fixer documented in entries/2026/06/10/041600Z-result-fixer-c39b42.md § "Catalog 'dev' gate diagnosis" and § "a3p `prepare-test.sh` interaction outcome".
2. Absorb the 40+ TypeScript errors the prior fixer documented in § "Bump deferral", in a cleanup pass spanning `client-utils`, `ERTP`, `async-flow`, `governance`, `internal`, `network`, `orchestration`, `vats`, `zone`.
3. Verify the resulting CI run matches upstream PR Agoric/agoric-sdk#12527's CI pattern (only `test-dapp (node-new)` red).
4. Drop the patch on `@endo/pass-style` (now absorbed in 1.8.0 per prior fixer's verification); update the patch on `@endo/compartment-mapper` for the new `'link-pattern'` instance in `link.js` per prior fixer's verification.

Alternative: `next: liaison` if the maintainer prefers to split the Endo bump into a separate `chore(deps): bump Endo to 1.8.0 / 4.3.1 / 2.2.0` follow-up PR per the prior fixer's "tractable next dispatch" note, then re-base this mirror PR on top. That keeps this PR's substance at the original-PR-mirror shape (minimal cherry-pick + lockfile reconciliation) and isolates the bump cost.

The next-stage decision is the maintainer's; the shepherd's classification is `next: fixer` because that path stays inside the existing PR scope and continues the chain authorization implicit in "Pray shepherd."

Self-improvement: nothing this time. The "watch-only dispatches are wrong dispatches" norm in roles/shepherd/AGENT.md was honored in spirit (this dispatch had substantive verification work: confirming the MAINTAINERS expected-fail framing, classifying the new band of failures, comparing to upstream PR #12527, posting the comment). No new lesson surfaced about role or skill structure.
