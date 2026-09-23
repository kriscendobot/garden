Implemented and pushed commit `bd808ab286` to `main2`.

- Added the dedicated `GARDEN_HANDOFF_UNVERIFIED_RC`.
- Unverified handoffs now leave the job in `doin`, clean temporary files, log the TTL requeue, and continue the worker loop.
- Other completion failures remain fatal.
- Expanded regression coverage for custom exit codes, worker survival, retained claims, exact logging, and cleanup.
- Tests passed: `completion-signal-test.sh` (28/28), CI shellcheck, syntax checks, and grep-gate suites.
- Follow-ups: none.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/self-heal-fix-garden-cleric-handoff-unposted-nonfatal.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 248s

<!-- garden-usage-end -->
