Clean stage for endojs/endo-but-for-bots PR #1530 (host `attachDebugger`/`detachDebugger`, XS worker debugger Phase 7): nothing needed changing, and CI is green at head `df5ac6d2cf`.

**What I checked**
- **Coverage on the new module:** I ran the c8 coverage tool over `packages/daemon/src/debug-attach.js` with its 10 tests in `test/debug-attach.test.js`. All tests pass and every statement, branch, function and line is covered.
- **Host and manager changes:**
  - **`host.js`:** the two new tests in `test/endo.test.js` exercise `identifyWorker` (unknown pet name, a name that isn't a worker) and the attach/detach paths.
  - **`manager.js`:** the same tests cover the "requires a platform with an XS worker supervisor" refusals.
  - **Not covered on Node:** the `manager.js` path that actually attaches, and `bus-manager-rust-xs.js`, only run under the Rust/XS supervisor. Node coverage can't reach them, so I wrote no contrived tests for them.
- **Dead code:** the refactor removed `pendingDebugAttach` and the old `makeDebugSession`/`makeDebugger` imports from `bus-manager-rust-xs.js`, and nothing references them any more. `makePromiseKit` is still used there.
- **One judgement call:** the default "not supported" fallbacks for `attachDebugger`/`detachDebugger` in `makeHostMaker` can't currently be reached, because its only caller (`manager.js`) always passes real ones. I kept them because they follow the file's existing pattern for `debugWorker`.

**CI:** with nothing to push, `ci-wait-merge.sh --no-merge` returned rc=0: 35 checks, 0 failed.

**Follow-ups:** none. The gauntlet moves on to the panel stage.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1530-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (888844 cached reads)
- Output: 4564 tokens
- Cost: $0.6898648000000001
- Wall-clock: 280s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
