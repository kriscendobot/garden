Diagnosed the culprit as `garden-worktree-sweeper`: its 22:42 run queried every historical tada report via GraphQL, continued across the 22:44 quota reset, and consumed exactly 2,136 points by completion at 22:59.

Landed commit `7105ca64e6` on `main2`. The sweeper now:

- Checks for actual checkout residue before querying GitHub.
- Uses the REST pull endpoint instead of `gh pr view` GraphQL.
- Caches duplicate PR dispositions within each sweep.

Added regression coverage for residue gating, REST-only reads, duplicate caching, project-only residue, and fail-safe open-PR handling.

Verified: worktree teardown 11/11, CI watcher 75/75, API cooldown 19/19; ShellCheck and diff checks passed.

Self-improvement: nothing this time.

Follow-up: post-deploy quota behavior was not observed; the deliberate deployment workflow must advance the host to `7105ca64e6`.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/diagnose-hourly-graphql-quota-exhaustion-20260923.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 513s

<!-- garden-usage-end -->
