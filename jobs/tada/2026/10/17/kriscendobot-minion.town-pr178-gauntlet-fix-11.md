Fix round 11 for PR #178 (kriscendobot/minion.town, `git-remote-push-caps`) is pushed, and CI is green on the new head `991f49a`: `ci-wait-merge.sh` returned rc 0 with all 3 checks passing.

**Applied (4 follow-up commits on top of `d1e89c9`):**
- **assessor (must-fix), `29d0208`:** the request body now passes through a counting filter on its way into `http-backend`. The chunk that crosses the size cap is dropped, and the input is never closed after it, so `receive-pack` never sees a complete pack that ran over. The new test sends a valid pack that is under the pack-size limit but one byte over the body cap once framing is added. Without the fix it moved `refs/heads/main` in 3 of 3 runs; with it, the ref stays put.
- **integrator (must-fix), `29d0208`:** the timing-dependent stock-git chunked test no longer expects one particular client message. It now checks only that the push fails, no ref moves and no pack is kept.
- **corner-prober, `8c2798b` and `e29ab5b`:** a new `assertPushLimits` check refuses any injected limit that is not a positive whole number before the router is built. It is tested with 0, -1, 1.5, NaN and Infinity for each limit. A new test confirms `directorySize` counts nothing for symlinks.
- **engine-realist, `8c2798b`:** idle rate-limit entries are now cleared by a once-per-window timer that doesn't keep the process alive and stops when nothing is tracked. The test checks the cleanup with no later push.
- **stylist, fast-checker, transplanter, `e29ab5b`:** renamed `fc` to `fastCheck`, added a property test for `directorySize` over generated directory trees (50 runs), and skipped the unreadable-directory suite on Windows.
- **archivist, `991f49a`:** the design doc's deferred list now names only what is still open: metering, billing, and the size bounds the caps don't cover.

**Declined, with reasons in the PR comment:**
- **benchmarker:** the per-check cleanup it asked me to benchmark is gone, replaced by the timer, so there is no performance claim left to measure.
- **releaser:** the repo has no changesets setup and its root package is private. The upgrade note is the Phase 14 entry in `DEPLOYMENT.md`.
- **pruner:** the flagged comment explains why a push is counted before it waits for its turn, which the code alone doesn't show, so I kept it.

The follow-up comment mapping each finding to its commit is https://github.com/kriscendobot/minion.town/pull/178#issuecomment-6229266998. Locally, type-checking is clean and `vitest run test/git-remote/` passes 115 of 115.

**Local test pitfall:** on garden hosts, the garden's `git` wrapper (`scripts/jobs/bin/git`) on PATH runs `git http-backend` calls one at a time. That makes the concurrency tests time out even on the unchanged code. They pass once that directory is removed from PATH, and CI is unaffected. Anyone running these tests on a garden host needs to strip it from PATH first.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr178-gauntlet-fix-11.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 78 tokens (3876155 cached reads)
- Output: 26624 tokens
- Cost: $2.230422999999999
- Wall-clock: 2697s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
