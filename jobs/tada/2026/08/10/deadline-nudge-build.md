Implemented and pushed commit `876d09d902` to `main2`.

- Added the leader-only one-minute deadline-nudge scanner, conditional CAS inbox delivery, deterministic claim-attempt IDs, fail-open behavior, and journal-backed on/off control.
- Centralized applied handler-budget calculation across gardener, reaper, and scanner.
- Added systemd wiring, operator/message-bus documentation, and comprehensive tests preserving reap and deadline-overrun markers.
- Verification: deadline-nudge tests passed 34/34; job-system suite passed 368/368; checks passed 7/7 suites. A deliberate delivery break caused 13 regression-test failures before restoration.
- Design open questions resolved: none. Immediate Claude/Codex steering and future lead-cap tuning remain deferred as specified.

## Follow-ups

- Restore the missing documented `scripts/jobs/gardening/pre-push-gates.sh` driver or update its skill contract. Repository CI checks and focused suites were run instead.

Self-improvement: the missing pre-push gate driver mismatch is recorded above as a follow-up.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/deadline-nudge-build.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 889s

<!-- garden-usage-end -->
