# Fix round 6 for endojs/endo-but-for-bots#1403: done, CI green

I fixed every must-fix item from the round-6 panel and pushed five follow-up commits to the PR head, which moved from `6be2a3cb` to `7cc7cc3fe7`. CI is green: the gate script returned 0 with 0 of 33 checks failed, but only after one re-run of the two macOS legs (details below).

**Must-fix items:**
- **Shape table snapshot (spec-keeper and saboteur), commit `ed53a95571`:** `makeShapeClassifier` now reads each row once. It copies every entry into a frozen plain-data record, checks that copy, and keeps only the copies. Before this, an entry with a getter, or a list whose iterator returned different items on a second pass, could get an `ok` result past the check. Two new tests cover those two cases.
- **#1102 (integrator):** the PR body now says #1102 was narrowed to special names and closed, and that phase 1 does not depend on it. The phrase "next child of this orchestration" now reads "the next PR in this stack (phase 2, `@endo/claude`)".
- **PR body length:** cut from 463 words to about 250 (the limit is 300). The template headings and the garden markers are unchanged.

**Should-fix items I also fixed:**
- **Types export (surfacer), commit `8594a1819b`:** the `./types.js` export now has a `default` entry pointing at a one-line `types-index.js` file, the same pattern `agentry` uses.
- **Limit enforcer setup (breaker and saboteur), commit `80a72ae0c2`:** if the timer fails to start during setup, the enforcer now cancels its listener for cancellation, so a later cancel can't kill a process for a turn that never got an enforcer. Added a test.
- **Usage recorder clock (breaker, saboteur and spec-keeper), commit `e2db9760eb`:** if the clock throws or returns a non-finite value after the turn, only the usage record is lost. That is reported through `reportSinkError`, and the turn's result still comes back. Added a test.
- **Timer comment (spec-keeper), commit `7cc7cc3fe7`:** the `MAX_TIMER_DELAY_MS` comment now describes Node and HTML timer behavior correctly, with links to the specs.

**Not addressed this round** (should-fix or comment-only items, listed in the PR comment):
- purist: freezing provider SDK objects during classification, typing `buildMcpServer` as near-only, and the duplicated `turns` / overloaded `detail` fields on `UsageRecord`.
- spec-keeper: counts limited to safe integers, and `-0` getting through as a retry delay.
- Removing the stale #1102 references from the design document.

**Local checks:** the inference tests pass (66), and the package `tsc`, `eslint` (0 errors) and the repo-root `tsc -p tsconfig.json` pass are all clean. I posted a summary of the round on the PR: https://github.com/endojs/endo-but-for-bots/pull/1403#issuecomment-5966737425

**CI:** the first run ended red on both macOS legs, with failures only in packages this PR doesn't touch:
- `@endo/hosted-agent`: the provider-worker test timed out.
- `@endo/daemon`: the orphaned-daemon teardown test failed.

Each leg failed a different test, which looks like timing flakes, so I re-ran the two failed jobs once. Both passed, and the gate script then reported green. Nothing new arrived in my inbox.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1403-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 104 tokens (4537981 cached reads)
- Output: 19570 tokens
- Cost: $2.1307962000000007
- Wall-clock: 5178s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
