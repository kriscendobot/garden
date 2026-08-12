Implemented and pushed to `main2` at `3120d2c8b2`.

- Added and indexed the design, resolving the approval trap by requiring fresh approval after any rebase.
- Wired `safe-rebase.sh` into the merge spine with lease-safe pushes, fail-closed conflicts, post-rebase CI validation, and a final live-base recheck.
- Preserved review vetoes, frozen/shared-stack guards, branch retention, and merge verification.
- Updated conductor, botanist, and state-machine doctrine.
- Added regression coverage for clean/conflicting rebases, stale approvals, rebased red CI, and base movement during CI.
- Verified relevant suites pass and the full job-system suite reports 368 passed, 0 failed.
- Follow-up: deploy `main2` for the new spine to become active.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/conductor-rebase-and-shepherd-before-merge.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 865s

<!-- garden-usage-end -->
