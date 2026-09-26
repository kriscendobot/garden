Implemented and pushed commit `946c8b99f8` to `main2`.

- Handoff successors are now checked unconditionally, even without a `## Follow-ups` section.
- Added `GARDEN_HANDOFF_UNPOSTED_RC=76`; unposted handoffs now leave jobs in `doin` without killing workers.
- Added regression coverage for both the primary gate and fallback soft-RC path.
- Focused suites passed: 41 tests. Full suite: 378 passed, 1 unrelated issue-inbox test failed.
- Posted `investigate-ironhorse-repair-gauntlet-handoff-nonpost` to investigate the underlying repair-handler failure affecting fourteen currently live repair jobs.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/self-heal-fix-garden-cleric-complete-job-unposted-handoff-hard-die.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 385s

<!-- garden-usage-end -->
