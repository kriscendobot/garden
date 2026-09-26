Implemented and pushed commit `5259cae328` to `main2`.

Startup cgroup cleanup now discards members whose `/proc/<pid>/status` vanished during the cgroup/proc race, preventing them from being classified, signalled, persisted, or alerted as unknown residue. Added regression coverage for vanished-only and mixed residue cases.

Verification: targeted test passed 13/13; full job-system suite passed 383/383; Bash syntax and diff checks passed.

Self-improvement: nothing this time.

Follow-ups: none.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-ignore-vanished-cgroup-members.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 324s

<!-- garden-usage-end -->
