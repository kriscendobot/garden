from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-11-17T05:02:24Z
watchdog_key: self-heal-garden-foreman
notice_count: 22
first_seen: 2026-11-14T04:26:12Z
last_seen: 2026-11-17T05:02:24Z
---
WATCHDOG notice — occurrence #22 (first seen 2026-11-14T04:26:12Z, latest 2026-11-17T05:02:24Z).
The SAME condition (`self-heal-garden-foreman`) has now been observed 22 times; this is ONE
coalesced notice that updates in place, not 22 messages. Latest detail:

self-heal: garden-foreman exited rc=78 with no scoped fix. Capture: a1eba59099f49dbefa96e5cd3f7e7d0f05af417c (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p a1eba59099f49dbefa96e5cd3f7e7d0f05af417c). Diagnosis: The foreman exited 78 because `post-job.sh` refused to post a job for a deliberately paused project, and the foreman treats any nonzero return code as fatal. I found no code defect in the pause itself.

- **What failed:** At 05:02:05 the foreman proposed the next milestone step `fix-endojs-endo-but-for-bots-pr1595`. `post-job.sh` refused it because it "belongs to PAUSED project 'minion-town'" (pause record `pauses/minion-town.md`, rc=78).
- **Why it exits:** At `scripts/jobs/foreman.sh` around line 737, every nonzero return code other than the completed-collision and tempfail codes goes to the generic `ERROR: post-job failed` branch, which runs `exit "$post_rc"`. A pause refusal is expected, not a broken tick, so the foreman crash-loops under systemd for as long as it keeps proposing pause
