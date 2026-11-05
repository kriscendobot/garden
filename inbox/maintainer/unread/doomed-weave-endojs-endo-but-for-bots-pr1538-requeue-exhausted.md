from_host: endolin-garden-ece02cb4
from: reaper:endolin-garden-ece02cb4
sent_at: 2026-11-05T19:03:33Z
doom_base: weave-endojs-endo-but-for-bots-pr1538
doom_signature: requeue-exhausted
notice_count: 1
first_seen: 2026-11-05T19:03:33Z
last_seen: 2026-11-05T19:03:33Z
---
SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
The work is preserved at jobs/plan/weave-endojs-endo-but-for-bots-pr1538; it stays HELD until a human promotes it
(promote-plan.sh weave-endojs-endo-but-for-bots-pr1538) or removes it, so nothing is lost.
Original job base: weave-endojs-endo-but-for-bots-pr1538

--- original job body ---
---
posted_at: 2026-11-05T18:36:51Z
arc: minion-town-git-remote
role: weaver
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
Weave endojs/endo-but-for-bots PR #1538 (`build/daemon-git-clone`) onto the current `llm` base, resolving conflicts so its halted Git-remote provisioning gauntlet can resume on a current base.
