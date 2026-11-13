from_host: endolin-garden-ece02cb4
from: reaper:endolin-garden-ece02cb4
sent_at: 2026-11-06T03:04:50Z
doom_base: design-daemon-git-remotes-ssh-transport-r2
doom_signature: requeue-exhausted
notice_count: 1
first_seen: 2026-11-06T03:04:50Z
last_seen: 2026-11-06T03:04:50Z
---
SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
The work is preserved at jobs/plan/design-daemon-git-remotes-ssh-transport-r2; it stays HELD until a human promotes it
(promote-plan.sh design-daemon-git-remotes-ssh-transport-r2) or removes it, so nothing is lost.
Original job base: design-daemon-git-remotes-ssh-transport-r2

--- original job body ---
---
role: designer
tier: mentor
arc: minion-town-git-remote
posted_at: 2026-11-06T02:09:03Z
token-budget: 250000
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-11-06T02:10:50Z cleared=none -->

---
role: designer
tier: mentor
token-budget: 250000
arc: minion-town-git-remote
fallback-tier: minion
dispatch: automatic
---
Design the Phase 7 SSH transport and credential-capability slice for `endojs/endo-but-for-bots`, extending `designs/daemon-git-remotes.md` on `llm` with host-key policy, key-use authority, and bounded command restrictions.
