Implemented and pushed commit `74f3d84471` to `main2`.

- Added CAS-level predecessor checks: serial child N cannot move to `todo/` unless every predecessor is unambiguously in `tada/` in the promotion primitive’s freshly synced snapshot.
- Fail-safe behavior now also applies to `continue`: vanished children cannot release downstream stages; declared failures with a `tada/` report can.
- Added deterministic SUBTEST 22 covering the stale pending-to-running race. It fails on old code and passes with the fix.
- Investigation found the reported incident was a stale-reader false alarm: authoritative history shows stage 1 reached `tada/` at 22:06:39Z and stage 2 was promoted at 22:07:04Z. This was not caused by `df2226c2b8` or `9393c3ce6d`; the hardened CAS check closes an independent pre-existing TOCTOU gap.
- Verification: orchestration suite passed 43/43 after rebase; repository-wide Bash syntax checks passed. The promotion reset suite’s existing unrelated baseline remains 29/32.

Self-improvement: `skills/orchestration/SKILL.md`, `roles/orchestrator/AGENT.md`; documented CAS-enforced serial ordering and safe `continue` semantics.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/garden-orchestrate-serial-order-violation.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 631s

<!-- garden-usage-end -->
