from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-11-14T05:51:54Z
watchdog_key: self-heal-garden-foreman
notice_count: 2
first_seen: 2026-11-14T04:26:12Z
last_seen: 2026-11-14T05:51:54Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-11-14T04:26:12Z, latest 2026-11-14T05:51:54Z).
The SAME condition (`self-heal-garden-foreman`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

self-heal: garden-foreman exited rc=78 with no scoped fix. Capture: bf7f100d25f8f297bacaba2d13b3e39379f9c141 (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p bf7f100d25f8f297bacaba2d13b3e39379f9c141). Diagnosis: Exit 78 is `GARDEN_PAUSED_RC`, a refusal and not a crash. The foreman proposed the next milestone step `weave-endojs-endo-but-for-bots-pr1565`. `post-job.sh` refused it because the body matched the pause record's regex `minion\.town`, from the minion-town pause of 2026-11-10 (`journal/pauses/minion-town.md`). The foreman only special-cases the completed-collision and transient return codes (`scripts/jobs/foreman.sh:712-740`). Any other nonzero code, including this deliberate pause refusal, goes through `exit "$post_rc"`, which fails the unit. This is the same pause that blocked the deferred promotion of `…minion.town-pr199-review…-retro` earlier in the tick. systemd restarts the foreman, it proposes the same step, and it fails again.

JOB self-heal-fix-garden-foreman-paused-rc78-soft-s
