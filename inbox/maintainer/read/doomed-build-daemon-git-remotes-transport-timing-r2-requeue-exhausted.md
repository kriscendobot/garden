from_host: endolin-garden-ece02cb4
from: reaper:endolin-garden-ece02cb4
sent_at: 2026-11-06T04:43:49Z
doom_base: build-daemon-git-remotes-transport-timing-r2
doom_signature: requeue-exhausted
notice_count: 1
first_seen: 2026-11-06T04:43:49Z
last_seen: 2026-11-06T04:43:49Z
---
SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
The work is preserved at jobs/plan/build-daemon-git-remotes-transport-timing-r2; it stays HELD until a human promotes it
(promote-plan.sh build-daemon-git-remotes-transport-timing-r2) or removes it, so nothing is lost.
Original job base: build-daemon-git-remotes-transport-timing-r2

--- original job body ---
---
role: builder
tier: mentor
arc: minion-town-git-remote
posted_at: 2026-11-06T02:09:04Z
token-budget: 250000
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-11-06T04:07:26Z cleared=none -->

---
role: builder
tier: mentor
token-budget: 250000
arc: minion-town-git-remote
fallback-tier: minion
dispatch: automatic
---
Build the Phase 2 transport-timing slice from `daemon-git-remotes` in endojs/endo-but-for-bots on `llm`: add structured CapTP and transport timing to Git fetch/push results with contract tests.
