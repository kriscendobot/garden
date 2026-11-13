from_host: endolin-garden-ece02cb4
from: reaper:endolin-garden-ece02cb4
sent_at: 2026-11-06T04:04:08Z
doom_base: design-daemon-git-remotes-extended-transports-r2
doom_signature: requeue-exhausted
notice_count: 1
first_seen: 2026-11-06T04:04:08Z
last_seen: 2026-11-06T04:04:08Z
---
SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
The work is preserved at jobs/plan/design-daemon-git-remotes-extended-transports-r2; it stays HELD until a human promotes it
(promote-plan.sh design-daemon-git-remotes-extended-transports-r2) or removes it, so nothing is lost.
Original job base: design-daemon-git-remotes-extended-transports-r2

--- original job body ---
---
role: designer
tier: mentor
arc: minion-town-git-remote
posted_at: 2026-11-06T02:09:03Z
token-budget: 250000
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-11-06T03:39:50Z cleared=none -->

---
role: designer
tier: mentor
token-budget: 250000
arc: minion-town-git-remote
fallback-tier: minion
dispatch: automatic
---
Design Phase 7’s bounded SSH and Noise transport extension for `endojs/endo-but-for-bots` from `designs/daemon-git-remotes.md` on `llm`, specifying authority, credential, and GitRemote contracts before implementation.
