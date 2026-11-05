Implemented and pushed commit `d1453f822b8` to `main2`.

- Added no-LLM `gauntlet.sh --status-probe` mode with durable terminal reports.
- Active probes now re-post themselves behind a bounded delay, releasing worker sessions immediately.
- Added provider-neutral probe claiming, priority handling, drain-safe execution, and fail-closed orchestration outcomes.
- Documented gauntlet waiter usage in `skills/job-board/SKILL.md`.
- Verified syntax, defer/re-post CAS behavior, claim priority/replay tests, and new active/terminal probe assertions. The broader gauntlet suite passed all observed checks through subtest 18 before its 600-second cap.
- Self-improvement: `skills/job-board/SKILL.md`; replaced foreground gauntlet polling guidance with deterministic deferred probes.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-gauntlet-wait-status-probe.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 1310s

<!-- garden-usage-end -->
