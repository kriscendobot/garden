I applied all three blocking style findings from the pre-pass to PR #1504 and pushed them, but CI had not finished when the hour-long wait ran out. It returned rc 4 (still pending), so I'm reporting the fix stage as still pending.

**What changed** (commit `47c245c6eb` on `build/daemon-agent-tools-sandbox-shell`, pushed `93e411a4e5..47c245c6eb` with `safe-push-pr-head.sh`):
- **Inline import type:** `packages/sandbox/test/shell-engine.test.js` now declares `AddressInfo` in an `@import` tag at the top of the file and uses the bare type name (Prettier reformatted that line).
- **Plain re-export:** `packages/sandbox/src/spawner.js` is now marked `@deprecated` and points importers at `@endo/host-spawner/src/sandbox-spawner.js`. I did not move its existing importers over:
  - `packages/hosted-agent/setup-environments.js` and `packages/hosted-agent/src/environment-runner.js` predate this PR, and `hosted-agent` doesn't depend on `@endo/host-spawner`. Moving them would add a dependency and a `yarn.lock` change outside this PR's scope.
  - The sandbox package's own `test/spawner.test.js` still imports the shim.
- **Abbreviated names:**
  - In `packages/sandbox/src/drivers/child-process.js`, `err` is now `error` in both catch blocks.
  - `numRuns` can't be renamed because it is fast-check's own option name. I added the probe's escape-hatch line (`// spell-out-exempt: …`) to `packages/sandbox/test/shell-engine.test.js` and `packages/host-spawner/test/sandbox-spawner.test.js`. This turns off the abbreviation check for those two whole files.
- **Not acted on:** the non-blocking warning about the 11-line comment in `packages/daemon/scripts/bundle-bus-daemon-rust-xs.mjs`.

**Local checks:** all three probes pass on my changes. Type check and eslint on the sandbox package are clean, and `test/spawner.test.js` passes (11 tests).

**CI at the deadline** (34 of 36 checks finished):
- Everything that finished passed except `test (24.x, macos-15)`. It failed in `test/http-content-plane.test.js`. Every test in that file passed, but the file then exited with an unhandled rejection: `TypeError: Cannot assign to read only property 'message' of object 'ClientDestroyedError'`. That looks like the known cross-PR macOS `ClientDestroyedError` flake, and this commit doesn't touch that package.
- `test (22.x, macos-15)` and `test (22.x, ubuntu-latest)` were still running.

**Follow-up:** once the run (41251470208) finishes, rerun the failed macOS leg with `gh run rerun 41251470208 --failed -R endojs/endo-but-for-bots`. It can't be rerun while the run is still in progress. If it fails the same way twice, it should be looked at rather than retried again.

<!-- gauntlet-stage-result: fix=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1504-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 66 tokens (2230475 cached reads)
- Output: 9231 tokens
- Cost: $1.1679950000000003
- Wall-clock: 3813s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
