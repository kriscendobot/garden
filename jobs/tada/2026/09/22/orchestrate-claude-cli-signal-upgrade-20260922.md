---
handed-off: finish-claude-cli-signal-rollout-20260922
deliverable-complete: false
---
Implemented and landed commit `e43c28386f` on `main2`.

- Item 1: Structured Claude termination fields now authoritatively classify completion candidates, transient failures, quota cuts, policy refusals, API errors, and budget stops. Fields are retained in the usage ledger. The completion marker remains required as proof the model reached its instructed final act.
- Item 2: The worker spine now consumes validated `stream-json`, rejects truncated/missing-result streams, records rate-limit telemetry, and uses true seven-day utilization for budget snapshots, leveling, and admission. Hand-calibrated token ceilings remain fallback. Verified live against installed Claude CLI 2.1.251; observed the documented rate-limit event shape.
- Item 3: Tier-based `$4/$10/$20/$40` per-call ceilings scale with remaining seven-day headroom. Budget exhaustion requeues as a bounded stop rather than dooming. Nested panel calls inherit the ceiling, and panel disposition now uses `--json-schema`.

Validation passed:

- New structured-stream suite: 12/12.
- Worker integration: 49/49.
- Provider cooldown: 24/24.
- Deploy harness: 149/149.
- Relevant panel suites: 39/39.
- All 12 configured candidate-gate suites passed individually, including the new stream suite.
- The leader’s real candidate gate passed without override at 06:48 UTC.

Canary deployment succeeded on `endolin-garden2-5bcdff64`: deployed `e43c28386f`, reported zero unit failures, claimed real work after deployment, and completed the pinned round-trip probe at 06:46:41Z. Offline `oros-studio-garden-ce242c49` was not treated as validation evidence.

The leader’s final deployment correctly deferred because this originating cleric remained beyond the long-job busy threshold. Durable successor `finish-claude-cli-signal-rollout-20260922` is already claimed and owns leader-last deployment plus post-deploy health and fresh-claim verification.

Self-improvement: nothing this time.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/orchestrate-claude-cli-signal-upgrade-20260922.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 3137s

<!-- garden-usage-end -->
