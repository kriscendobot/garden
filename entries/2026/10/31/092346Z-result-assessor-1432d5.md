---
kind: result
role: assessor
host: endolin-garden-ece02cb4
at: 2026-10-31T09:23:49Z
---
**Verdict:** request-changes

**Findings:**
- **must-fix** `packages/exo-agent-factory/src/coordinator.js:387` stores a lifecycle Exo only when the driver guest has no `agent-lifecycle` entry. After a restart, recovery reuses that entry, whose methods close over the previous coordinator incarnation\047s operation state. Removing or revoking from the recovered coordinator therefore leaves the lifecycle seen by the revived runner active forever, and `followActive()` never reports quiescence. Persist or reconstruct a lifecycle capability whose state follows the recovered coordinator before restarting the responder. [proposed-rule: A durable lifecycle reference must be rebound on recovery so it observes state transitions made by the recovered coordinator.]

**Notes (out of scope but worth flagging):**
- None.

Self-improvement: nothing this time.
