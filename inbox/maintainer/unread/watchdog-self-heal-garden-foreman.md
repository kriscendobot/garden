from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-11-15T16:12:55Z
watchdog_key: self-heal-garden-foreman
notice_count: 15
first_seen: 2026-11-14T04:26:12Z
last_seen: 2026-11-15T16:12:55Z
---
WATCHDOG notice — occurrence #15 (first seen 2026-11-14T04:26:12Z, latest 2026-11-15T16:12:55Z).
The SAME condition (`self-heal-garden-foreman`) has now been observed 15 times; this is ONE
coalesced notice that updates in place, not 15 messages. Latest detail:

self-heal: garden-foreman exited rc=78 with no scoped fix. Capture: 19e267ee07c1213c407eaff53c7cdcf20a911353 (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p 19e267ee07c1213c407eaff53c7cdcf20a911353). Diagnosis: The foreman exited 78 because `post-job.sh` refused a post, and the foreman treats any refusal as fatal.

**Cause.** `post-job.sh` refused to post `shepherd-endojs-endo-but-for-bots-pr1476`. It reported that the base belongs to PAUSED project `minion-town` (record `pauses/minion-town.md`) and returned rc=78 (`EX_CONFIG`). In `scripts/jobs/foreman.sh`, the `elif [ "$post_rc" -ne 0 ]` branch near line 737 logs "ERROR: post-job failed" and runs `exit "$post_rc"`. It only special-cases the completed-collision rc and the tempfail rc 75. So a deliberate pause refusal crashes the unit on every tick and systemd restarts it. The foreman will re-propose the same step each tick until the pause is lifted or the code changes.

The refusal is intended behavior (see the recent docs commit "record the min
