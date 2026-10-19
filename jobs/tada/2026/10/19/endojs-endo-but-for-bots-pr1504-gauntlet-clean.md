# Gauntlet CLEAN stage: endojs/endo-but-for-bots#1504, done and CI green

The PR started red: `build-xsnap` failed, and `build` failed as a knock-on. I pushed one fix, and CI is now green on the new head `ee79556d4d` (35 checks, 0 failed).

**What was wrong.** `build-xsnap` failed at "Generate XS bootstraps" with `Cannot find external module "@endo/host-spawner/src/sandbox-spawner.js"`. The PR's new `packages/daemon/src/shell-engine.js` imports that module directly. But `packages/daemon/scripts/bundle-bus-daemon-rust-xs.mjs` drops the whole `@endo/host-spawner` package from the XS daemon bundle as Node-only. Only the host engine (`src/host-spawner.js`) actually uses `node:child_process`, and it reaches the daemon through the injected `hostTools` power. `sandbox-spawner.js` doesn't use any `node:` modules.

**Fix (commit ee79556d4d, pushed with `safe-push-pr-head.sh`).** I removed `@endo/host-spawner` from `EXCLUDED_PACKAGES` and added a comment explaining why. The bundler only pulls in modules that are actually imported, so the Node half still stays out.

**Local checks:**
- `yarn bundle:xs` succeeds.
- `daemon_bootstrap.js` contains `sandbox-spawner.js` and no `child_process`.
- `packages/daemon/test/xs-worker-bundles.test.js`: 6 passed.
- `host-spawner` tests: 12 passed. `exo-shell` tests: 18 passed.

**Coverage pass.** I didn't get line-coverage numbers: `c8` isn't available in this checkout, so the coverage run printed nothing. The touched packages' test suites pass, and the change didn't leave any dead code behind.

The first background CI wait was stopped at its time limit; a separate run of `ci-wait-merge.sh --no-merge` finished with rc 0 (GREEN). No follow-ups, and the inbox was empty.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1504-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 64 tokens (2152735 cached reads)
- Output: 10314 tokens
- Cost: $1.1833470000000001
- Wall-clock: 2891s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
