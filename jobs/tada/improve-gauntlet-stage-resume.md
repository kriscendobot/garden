Implemented and pushed commit `9f479905d7` to `main2`.

- Added `gauntlet.sh --resume-from-stage <base> <stage> [--iteration N]`.
- Added CAS-safe terminal-to-pending and pending-to-running transitions, stale artifact replacement, idempotency, conflict rejection, and active `doin/` protection.
- Halt reports now retain metadata required for safe resumption.
- Added documentation and CI coverage.
- Verification: new hermetic suite passed 8/8; targeted ShellCheck, syntax checks, and diff checks passed.
- Follow-up: the pre-existing general gauntlet test still expects CLEAN before the newer VIABILITY stage and fails independently of this change.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-gauntlet-stage-resume.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 442s

<!-- garden-usage-end -->
