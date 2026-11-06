from_host: endolin-garden-ece02cb4
from: reaper:endolin-garden-ece02cb4
sent_at: 2026-11-05T16:14:19Z
doom_base: design-daemon-git-remotes-ssh-transport
doom_signature: requeue-exhausted
notice_count: 1
first_seen: 2026-11-05T16:14:19Z
last_seen: 2026-11-05T16:14:19Z
---
SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
The work is preserved at jobs/plan/design-daemon-git-remotes-ssh-transport; it stays HELD until a human promotes it
(promote-plan.sh design-daemon-git-remotes-ssh-transport) or removes it, so nothing is lost.
Original job base: design-daemon-git-remotes-ssh-transport

--- original job body ---
---
posted_at: 2026-11-05T15:51:15Z
arc: minion-town-git-remote
role: designer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Design the Phase 7 SSH transport and credential-capability slice for `endojs/endo-but-for-bots`, extending `designs/daemon-git-remotes.md` on `llm` with host-key policy, key-use authority, and bounded command restrictions.
