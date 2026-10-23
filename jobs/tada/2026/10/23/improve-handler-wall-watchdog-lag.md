Implemented and pushed commit `8576a7c015f` to `main2`.

- Replaced relative watchdog timing with auditable absolute deadlines.
- Added parent-side detection for late or vanished watchdogs, with immediate fail-closed process-tree reaping.
- Enforced the advertised handler budget plus kill-after bound.
- Extended regression coverage for over-budget handlers, stopped watchdogs, vanished watchdogs, and detached descendants.
- Verified: watchdog tests 18/18, orphan-reap tests 17/17, timeout-classifier tests 42/42, handler-budget tests 35/35.
- Follow-up: `monk-claude-tree-reap-test.sh` integration remains blocked by its fixture omitting `scripts/jobs/bin`; its process-tree unit checks passed.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-handler-wall-watchdog-lag.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 562s

<!-- garden-usage-end -->
