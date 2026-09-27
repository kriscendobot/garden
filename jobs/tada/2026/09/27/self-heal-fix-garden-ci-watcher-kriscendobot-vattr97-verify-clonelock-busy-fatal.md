Implemented and pushed commit `ab66fece68f` to `main2`.

- Busy live-holder clone-lock failures now latch the cooldown and exit quietly with `GARDEN_OFFLINE_RC` (75).
- Authentication, corruption, local-state, and missing-upstream failures remain loud.
- Updated regression coverage for the latch behavior.
- Verification: targeted suite passed 61/61; Bash syntax, ShellCheck warning gate, all 8 pre-push probes, and local verification passed.
- Follow-ups: none.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/self-heal-fix-garden-ci-watcher-kriscendobot-vattr97-verify-clonelock-busy-fatal.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 220s

<!-- garden-usage-end -->
