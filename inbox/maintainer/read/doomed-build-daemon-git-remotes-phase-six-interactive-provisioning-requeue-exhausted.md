from_host: endolin-garden-ece02cb4
from: reaper:endolin-garden-ece02cb4
sent_at: 2026-11-05T16:14:09Z
doom_base: build-daemon-git-remotes-phase-six-interactive-provisioning
doom_signature: requeue-exhausted
notice_count: 1
first_seen: 2026-11-05T16:14:09Z
last_seen: 2026-11-05T16:14:09Z
---
SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
The work is preserved at jobs/plan/build-daemon-git-remotes-phase-six-interactive-provisioning; it stays HELD until a human promotes it
(promote-plan.sh build-daemon-git-remotes-phase-six-interactive-provisioning) or removes it, so nothing is lost.
Original job base: build-daemon-git-remotes-phase-six-interactive-provisioning

--- original job body ---
---
posted_at: 2026-11-05T15:45:41Z
arc: minion-town-git-remote
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Build Phase 6 interactive Git-clone provisioning in endojs/endo-but-for-bots from `daemon-git-remotes`: compose mount creation, endpoint policy, and sealed credentials into `provideGitClone`, with contract tests.
