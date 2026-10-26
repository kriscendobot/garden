I added three tests and pushed them to the PR head, but CI didn't settle within the hour: the bounded wait timed out with rc 4 and one check still running. So this stage reports **still-pending**, not done.

**Coverage pass (`packages/exo-agent-factory`)**
- **Starting point:** coverage was already high: `coordinator.js` 98.35% of lines and 90.8% of branches, `policy.js` 100% of lines. The main untested code was the fail-closed fault paths.
- **Tests added:** commit `8c4a87e9da`, pushed with `safe-push-pr-head.sh`, which moved the head from `4bfa9d576b` to `8c4a87e9da`:
  - an extra name in the child's directory raises a fault ("expected exactly"), and the operation stays at `GuestCreated`;
  - a responder made with the wrong powers raises a fault ("other powers") on replay after a crash, stays at `DriverCreated`, and nothing gets deleted;
  - a stale value left at a retained-endowment name is replaced before the operation starts.
- **Result:** `coordinator.js` is now 99.45% of lines and 92.2% of branches. 23 of 23 tests pass, `yarn lint` passes, and the root `tsc -p tsconfig.json` shows no errors in this package.
- **Dead code:** I found none.
- **Still uncovered:** the follower iterator's "done after Removed" return (lines 272–273) and the "namespace revoked during creation" boot path (lines 628–630).

**CI at the deadline: 7 red checks, 1 pending.** None of the red checks fail in `exo-agent-factory`; each traces to another package or the runner:
- **`build` (depcheck):** fails with `tred: command not found` on the Ubuntu 26.04 runner. This also fails on other PRs, and open PR #1546 is the fix.
- **`sandbox-drivers`, `cover (22.x)`, `cover (24.x)`, `test (22.x, ubuntu)`, `test (24.x, ubuntu)`:** two `packages/sandbox` bwrap tests fail with `ulimit: Illegal option -u` (Ubuntu 26.04). This is a failure other PRs hit too, and open PR #1542 is the fix.
- **`test (24.x, macos-15)`:** `@endo/floot#test` failed after its log showed the tool loop reaching `maxToolRounds` (1024). That package is unrelated to this PR.
- **`test (22.x, macos-15)`:** still running at the deadline.

When this stage is re-posted, it will most likely come back red unless #1546 and #1542 land first or those checks are treated as not caused by this PR.

<!-- gauntlet-stage-result: clean=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1560-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 88 tokens (3357404 cached reads)
- Output: 15253 tokens
- Cost: $1.6915967999999997
- Wall-clock: 3899s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
