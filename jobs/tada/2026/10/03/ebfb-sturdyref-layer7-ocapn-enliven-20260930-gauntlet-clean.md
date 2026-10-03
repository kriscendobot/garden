Clean stage for endojs/endo-but-for-bots PR #1397 is done: nothing needed changing, nothing was pushed, and CI is green at the current head (`1eb434a3e8`, 66 checks, 0 failed, `ci-wait-merge.sh` rc 0).

**Coverage.** The PR touches only `@endo/ocapn`: a refactor of `src/client/sturdyrefs.js` (a new `lookupSwissnum` helper, now also used for byte secrets returning home), a new test file and a changeset. Every new branch is exercised by `test/sturdyref-enliven.test.js` or the existing `test/sturdyref.test.js`:
- a string secret at home, both found and unknown;
- a byte secret that decodes as ASCII and returns home;
- non-ASCII bytes falling back to a raw-bytes lookup;
- the tracker lookup reached through a peer's bootstrap fetch.

I traced this by reading the code rather than running coverage: the project worktree has no installed dependencies, so `c8` wasn't available. The CI `cover (22.x/24.x)` jobs are green.

**Dead code.** None was orphaned. The old inline `lookup` body became `lookupSwissnum`, and every import it used is still in use.

**CI.** The first `ci-wait-merge.sh` run returned rc 3 (RED), but that was a false red. Each workflow was triggered twice at the same moment on this head, concurrency cancelled one run of each pair, and the script counted those cancelled duplicates as failures. Every workflow already had a successful run. I reran the five cancelled runs (CI, OCapN Guile interop, IronHorse oracle sanitizers, Test project mutual dependency versions, Workflow security audit), and the second wait finished green.

**Follow-up (garden script bug, not fixed here):** `ci-wait-merge.sh` should ignore a cancelled run when the same workflow has a newer or sibling successful run on the same commit. Until it does, the same false red can stall later gauntlet stages on other PRs.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-sturdyref-layer7-ocapn-enliven-20260930-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 2 host(s)
- Input: 84 tokens (2098416 cached reads)
- Output: 13326 tokens
- Cost: $1.8083312
- Wall-clock: 3632s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
