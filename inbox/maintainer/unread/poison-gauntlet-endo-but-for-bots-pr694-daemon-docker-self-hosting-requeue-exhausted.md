from_host: endolin-garden2-5bcdff64
from: reaper:endolin-garden2-5bcdff64
sent_at: 2026-07-11T22:03:13Z
poison_base: gauntlet-endo-but-for-bots-pr694-daemon-docker-self-hosting
poison_signature: requeue-exhausted
notice_count: 1
first_seen: 2026-07-11T22:03:13Z
last_seen: 2026-07-11T22:03:13Z
---
POISON job PARKED in jobs/plan/ (held, gate=go-ahead) after 5 requeue cycles on endolin-garden2-5bcdff64.
Its handler appears to fail every time; the reaper stopped requeueing it.
The work is preserved at jobs/plan/gauntlet-endo-but-for-bots-pr694-daemon-docker-self-hosting; it stays HELD until a human promotes it
(promote-plan.sh gauntlet-endo-but-for-bots-pr694-daemon-docker-self-hosting) or removes it, so nothing is lost.
Original job base: gauntlet-endo-but-for-bots-pr694-daemon-docker-self-hosting

--- original job body ---
---
role: shepherd
---

Run the gauntlet (clean → panel review → fix-loop → un-draft) on `endojs/endo-but-for-bots` DRAFT PR #694 `feat: Docker self-hosting image with authenticated remote gateway` (base `llm`, head `build/daemon-docker-selfhost-remote-gateway`), driving this freshly-built, mergeable-but-stranded PR toward mergeable to advance M3's headline exit criterion (self-host the daemon via Docker with a remote bearer-token gateway). Treat the known repo-wide lint projectService ceiling (tracked by #594) as pre-existing and out of scope; do not merge or touch superseded PR #608 (its disposition is a maintainer decision).
