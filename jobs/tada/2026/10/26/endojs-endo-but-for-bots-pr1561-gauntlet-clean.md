I added one coverage test to PR #1561 and pushed it. CI was not finished when the 3600s wait ran out (`ci-wait-merge` rc=4), so this stage ends still-pending. Separately, CI has several red checks, none from code this PR touches. When re-run, `ci-wait-merge` will likely return RED (rc 3) unless those reds are excluded.

**What I did**
- **Idempotence check:** the PR is open and draft, head was `a6d6066c10`, and CI was not green, so this wasn't a no-op.
- **Coverage pass:** ran c8 + ava on `packages/exo-agent-factory` in an isolated checkout of `build/exo-agent-factory-daemon-wiring`. All 27 tests pass.
  - `coordinator.js` is at 99.3% lines. The only line this PR added without coverage was the new `coordinator.lifecycle(opKey)` accessor (lines 986-987). The other uncovered lines (308-309, 677-679) come from the base PR.
  - `daemon-coordinator.js` and `daemon-host.js` show low numbers only because they run inside the daemon worker process, where c8 can't see them. `test/daemon.test.js` does exercise them end to end, and those tests pass.
- **Added test:** "lifecycle re-derives an operation facet and rejects an unknown key" in `test/coordinator.test.js`. It checks that the facet reports active, then inactive after `remove`, and that an unknown key throws. After it, `coordinator.js` reaches 99.5%.
  - The package's `tsc`, eslint and prettier are clean, and the repo-root checkJs `tsc` shows no errors in this package.
- **Dead code:** none found that this change orphaned.
- **Push:** `safe-push-pr-head.sh` moved the head from `a6d6066c10` to `e33aaa5f61` (commit "test(exo-agent-factory): cover the coordinator's lifecycle accessor").

**CI at the deadline:** 1 of 35 checks still running (`test (22.x, macos-15)`). The red checks:
- **`build`** (dependency-cycle check): `tred: command not found` on the runner.
- **`sandbox-drivers`, `cover (22.x/24.x, ubuntu)`, `test (22.x/24.x, ubuntu)`:** two bwrap tests in `packages/sandbox` fail (`ulimit: Illegal option -u`, and a parent-death test that makes no assertions).
- **`test (24.x, macos-15)`:** `packages/floot` `test/factory-system-prompt.test.js` exits 1.

All of these are in packages this PR doesn't touch. The base commit (`build/exo-agent-factory-core-8c4a87e`) has the same set failing: build, sandbox-drivers, both cover legs, and three test legs.

**Follow-ups**
- The driver should re-post this stage. Whoever handles the red checks should know they come from the base branch, not this PR: the sandbox bwrap tests on the CI runner, the missing `tred` (graphviz), and possibly the floot macOS test.

<!-- gauntlet-stage-result: clean=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1561-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 74 tokens (2716643 cached reads)
- Output: 10842 tokens
- Cost: $1.4117685999999996
- Wall-clock: 3825s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
