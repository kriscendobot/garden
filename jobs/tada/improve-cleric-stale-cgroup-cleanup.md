Implemented and pushed commit `71388d02c9` to `main2`.

- Workers now reap stale detached processes from their exact systemd cgroup before claiming jobs, while preserving the current wrapper process tree.
- Added TERM-to-KILL escalation, late-child rescanning, safety guards, and regression coverage.
- Passed startup cleanup tests (5/5), orphan-reaping tests (15/15), worker-spine tests (249/249), syntax checks, and `git diff --check`.
- Repository-wide checks had one unrelated existing failure: `roles/scholar/AGENT.md` is missing from an information-hiding allowlist.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-cleric-stale-cgroup-cleanup.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 463s

<!-- garden-usage-end -->
