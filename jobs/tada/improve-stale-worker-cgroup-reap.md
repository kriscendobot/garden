Implemented and pushed commit `d142186f2b` to `main2`.

- Classifies stale cgroup members as live processes or zombies.
- Signals each live PID once while allowing parent/systemd to reap zombies.
- Persists PID/start-time identities to rate-limit repeated cleanup attempts.
- Coalesces persistent-residue alerts and clears them after recovery.
- Expanded regression coverage for zombies, state changes, PID reuse, cooldowns, escalation, and recovery.
- Verified targeted test: 12 passed.
- Verified full job-system suite: 383 passed, 0 failed.
- Self-improvement: nothing this time.
- Follow-ups: none.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-stale-worker-cgroup-reap.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 616s

<!-- garden-usage-end -->
