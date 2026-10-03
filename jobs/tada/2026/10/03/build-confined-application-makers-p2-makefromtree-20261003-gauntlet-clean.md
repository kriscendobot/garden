---
orchestration-failed: true
---
CI on PR #1419 is red, so this clean stage failed. The cause is in the PR's own code, not the test I added.

**Coverage pass (done).** The only file the PR adds with no direct test was `packages/daemon/src/tree-layout.js`. I added `packages/daemon/test/tree-layout.test.js`, 12 unit tests against a fake tree, which bring that file to 100% statement, branch, function and line coverage under c8. Locally the tests pass, and prettier, eslint and the daemon `tsc` are all clean. I found no dead code left behind by the change. I pushed the test as `f4969510b5` with `safe-push-pr-head.sh`, moving the head on from `19328f0d28`.

**CI.** `ci-wait-merge.sh` returned rc 4 at its 3600s deadline only because the two macOS test legs (Node 22 and 24) were still running. By then `build-xsnap` had already failed for good, at its "Generate XS bootstraps" step (`yarn bundle:xs`):
```
Failed to load module "./src/bus-manager-rust-xs.js" in package .../packages/daemon/
Cannot find external module "@endo/compartment-mapper/archive-lite.js" (and capture-lite.js, node-modules.js, archive-parsers.js, import-parsers.js)
```
- **Cause:** the PR adds a static `import { captureNodeModulesArchive } from './capture-node-modules.js'` to `packages/daemon/src/manager.js`. That file imports `@endo/compartment-mapper/*`, which `packages/daemon/scripts/bundle-bus-daemon-rust-xs.mjs` deliberately leaves out of the XS daemon bundle (`EXCLUDED_PACKAGES`). The XS daemon bundle can no longer be built.
- **Where it started:** this failure was already present at the earlier head `19328f0d`, where the check was queued; my test-only commit does not touch the bundle.
- **Likely fix (for the fix-loop, outside the clean stage's scope):** load `capture-node-modules.js` with a deferred `await import(...)` inside `makeFromTree`'s node_modules branch, the way `worker.js` already defers its compartment-mapper imports. Then re-run `yarn workspace @endo/thixotrope run build:xs-bundles && yarn bundle:xs` locally before pushing.

I'm reporting this as a failure rather than `still-pending` because a re-run would only wait for the macOS legs and then find the same red check. No clean marker is emitted, as the stage protocol requires for red CI.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-confined-application-makers-p2-makefromtree-20261003-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 56 tokens (1968370 cached reads)
- Output: 11690 tokens
- Cost: $1.226842
- Wall-clock: 3802s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
