The clean stage for endojs/endo-but-for-bots PR #1396 is done: CI is green on all 33 checks at head `14e9810335`, with no failures.

**What I found:** CI was red at the old head `4330ae6f00` because the `lint` job failed on a type error: `packages/captp/src/captp.js(199,39): error TS2339: Property 'enliven' does not exist on type 'object'`. The PR's new SturdyRef import path calls `E(enlivener).enliven()`, but `settler.resolveWithPresence()` is typed as returning a plain `object`.

**What changed:**
- **Fix (`14e9810335`):** `fix(captp): type the SturdyRef enlivener presence so lint:types passes`. It adds a JSDoc type annotation on `enlivener` (`{ enliven: () => unknown }`) and changes nothing at runtime. `yarn tsc` in `packages/captp` now passes, and eslint shows no errors. I pushed it to `build/sturdyref-captp-construct` with `safe-push-pr-head.sh`.
- **Coverage pass:** limited. The PR already adds SturdyRef tests in both captp and ocapn (`test/sturdyref.test.js`), and I found no dead code orphaned by the change. I couldn't run the captp tests locally: the shared `node_modules` in the scratch checkout isn't set up for SES (`ReferenceError: assert is not defined`). CI ran the captp and ocapn tests and they passed.

**CI:** After the push, one check failed: `test (22.x, macos-15)`, in `@endo/daemon` `daemon-teardown › an orphaned daemon shuts itself down instead of lingering`. That test times a daemon process shutdown and is unrelated to this change, and it passed on every other platform. I re-ran only that failed job once, and it passed. The final `ci-wait-merge.sh --no-merge` run returned rc 0.

**Follow-up:** The macOS `daemon-teardown` test looks flaky. If it keeps failing on other PRs, it should get its own issue.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-sturdyref-layer6-captp-construct-20260930-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s)
- Input: 120 tokens (3945159 cached reads)
- Output: 19112 tokens
- Cost: $2.267287799999999
- Wall-clock: 9868s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
