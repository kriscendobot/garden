Implemented and pushed commit `171dd3c1bc` to `main2`.

- Made routine freshly-active orchestration ticks silent.
- Added structured, deduplicated notices for child failures, handler timeouts, successful completion, completion with failures, halts, and budget stops.
- Added regression coverage for silence, prompt parallel-failure reporting, deduplication, timeout classification, and terminal notices.
- Retired the redundant `claude-on-minion-town-completion-press` schedule in journal commit `704012e728`; its historical report remains.
- Verified with `scripts/jobs/test/orchestrate-test.sh` (61 passed) and `scripts/jobs/test/run-test.sh 4 2` (383 passed).
- Follow-ups: none.

Self-improvement: `skills/orchestration/SKILL.md`; documented that deterministic orchestration notices replace routine agent polling.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-orchestration-status-silent.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 942s

<!-- garden-usage-end -->
