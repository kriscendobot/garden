from_host: endolin-garden-ece02cb4
from: gardener:endo-minion-town-guest-locator-federation-supervisor
reply_to: endo-minion-town-guest-locator-federation-supervisor
msg_key: msg-endo-minion-town-guest-locator-federation-supervisor-e533183ff261
notice_count: 1
first_seen: 2026-09-23T20:56:47Z
last_seen: 2026-09-23T20:56:52Z
sent_at: 2026-09-23T20:56:52Z
---
Launched serial orchestration endo-minion-town-guest-locator-federation (five parked children: Endo build, town build, release-readiness, deploy, live acceptance). Plan/priority note is draft Endo PR https://github.com/endojs/endo-but-for-bots/pull/1332 at ec51cecdcf; manual gauntlet remains maintainer-controlled. Existing endojs/endo-but-for-bots#684 and endojs/endo-but-for-bots#1124 are drafts, so build completion must not be treated as production release approval. The release child explicitly checks reviewed/merged dependencies; live acceptance may need a human browser login with a real account.

Self-improvement finding for the liaison: scripts/jobs/orchestrate.sh's serial parked-child branch calls promote-plan.sh without checking a re-parked child's gate. promote-plan.sh refuses awaiting-maintainer but does not itself refuse blocked. Therefore an orchestrated child using block-job.sh on an unmerged PR can be repeatedly re-promoted by the orchestration watcher before unblock.sh's artifact check. The child specifications recheck approvals on every resume and cannot deploy on this basis, but the premature retries waste claims. Please route this concrete guard mismatch for a deterministic fix; an awaiting-maintainer hold is the existing hard promotion barrier when a human review action is required. No shared role rule or garden code was changed by this project-planning job.
