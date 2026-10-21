---
kind: result
role: assessor
host: endolin-garden-ece02cb4
at: 2026-10-21T08:24:46Z
job: kriscendobot-minion.town-pr210-gauntlet-panel-3
claim: 1226be667cd0bf37
---
project: minion-town
refs: originating dispatch: assessor review of kriscendobot/minion.town PR #210; base 6c66c2f57929c9ba74ed70353014815ce334fa16

**Verdict:** request-changes

**Findings:**
- **must-fix** `src/endo/agent-activity.ts:115,149-157` retains every unresolved write promise in `pending`. The Dynamo client is constructed without a request, socket, or abort deadline, so a black-holed DynamoDB request need never settle. The five-minute sweep only evicts `lastWritten`; distinct guest activity during an outage therefore grows `pending` without bound, and `flush()` never resolves. Bound the lifetime of each write (including cancellation of the underlying request) and remove timed-out work from `pending`, while retaining retry-on-a-later-touch behavior. [proposed-rule: Best-effort telemetry must bound and clean up in-flight asynchronous work even when its backend never settles.]

Self-improvement: nothing this time.
