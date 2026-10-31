---
orchestration-failed: true
---
orchestration-failed: true

# PR #1117 gauntlet clean stage: CI is red on one check this PR didn't cause

**Result:** the coverage pass is done and a new test commit is pushed, but CI on the current head (`4f7cb6bb8`) is RED. `ci-wait-merge.sh` returned rc=3, and the one failing check is `test-ironhorse-oracle`. It looks like a runner/environment problem, not something in this PR's diff.

**Coverage pass (in an isolated checkout of `kriscendobot/endo-but-for-bots@build/npm-registry-as-directory-tree`):**
- `@endo/exo-npm` source line coverage was about 92% (`type-guards.js` at 100%).
- The only notable gap was in `makeDeprecatedEndoRegistryAdapter`: its `resolve` and `fetch` methods had no tests. It is a public, documented export, so it is not dead code.
- I found no code orphaned by the change. The local `getInfoMethodGuard` in exo-npm and the platform `toSafeNumber` imports both still have callers.
- I pushed commit `4f7cb6bb8` ("test(exo-npm): cover the deprecated registry adapter's fetch and resolve") via `safe-push-pr-head.sh`. It covers four things:
  - `fetch` on a package that exists.
  - `fetch` on a missing package, which raises `RegistryNotFoundError`.
  - `resolve` with no resolver, which refuses.
  - `resolve` passing the call through to a supplied resolver.
- Local checks pass:
  - exo-npm: 74 tests, `tsc`, eslint (no errors) and prettier.
  - daemon `registry-tree` and `registry-endo` tests: 12 pass.

**CI (run 41161499650):**
- `sandbox-drivers` and `test (22.x, ubuntu-latest)` failed on the known bwrap "timeout and repeated cancellation" flake. Both passed on rerun.
- `test-ironhorse-oracle` failed all three attempts, with the same error each time:
  - Test: `ironhorse-262` `corpus_conversion_equivalence`.
  - Files: `stage3-math/054.js` and `055.js`.
  - Error: a last-digit mismatch, «1.300820426840647» vs «1.3008204268406467».
- **Why I don't think this PR caused it:**
  - The PR doesn't touch `rust/engine` or the test262 files.
  - The frozen base `llm-9a14ddf` passed CI on 2026-10-28.
  - Unrelated PR #1501, which has no rust or test262 changes, fails the same way (job 124422390712).
  - On 2026-10-25 (#1504) this failure came and went; now it happens every time. My best guess is a math-library rounding difference on the current Ubuntu runners.

**Follow-ups:**
- I posted the fixer job `endo-ironhorse-oracle-stage3-math-ulp-drift` to make that oracle check give the same result on every runner, with a PR against `llm`.
- Once that lands, re-run this clean stage. No changes to #1117 should be needed.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1117-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s) (1 unmetered)
- Input: 18 tokens (1070349 cached reads)
- Output: 3841 tokens
- Cost: $2.4759767999999998 (1 engagement(s) unpriced)
- Wall-clock: 7609s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
