Implemented and pushed commit `339344d7f27` to `main2`.

- Stale subscription snapshots now trigger one deduplicated refresh request to the owning host.
- Added the host-scoped `refresh-budget-snapshot` sysop operation.
- Pools remain non-increasable until a fresh snapshot is accepted.
- Added remediation, recovery, ownership, and sysop tests.

Verification: snapshot-remediation test passed; sysop test passed 61/61; proportional leveling passed 10/10; syntax and diff checks passed. The broader live-budget suite retains four unrelated stale test assertions.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-refresh-stale-budget-snapshot.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 943s

<!-- garden-usage-end -->
