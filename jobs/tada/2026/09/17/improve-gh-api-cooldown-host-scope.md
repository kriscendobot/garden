Implemented and pushed commit `33254d01db` to `main2`.

- Anchored the GitHub API cooldown at `$GARDEN_ROOT/.garden-state/gh-api-cooldown`, independent of invocation-specific `GARDEN_STATE`.
- Added concurrent-tick coverage proving one atomic cooldown transition, persistent shared state, and next-tick suppression.
- Added the regression test to deploy gates and isolated watcher tests from live host state.
- Tests passed: API cooldown 6/6, CI watcher 74/74, deploy 133/133, dependabot 50/50, approval 18/18, issue inbox 43/43, receipt 8/8.
- Follow-up: the broader comment-watcher suite passed 356/357; its unrelated stale assertion expects initial gauntlet stage `clean`, while current production behavior starts at `viability`.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-gh-api-cooldown-host-scope.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 593s

<!-- garden-usage-end -->
