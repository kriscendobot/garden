from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-11-15T15:12:03Z
watchdog_key: self-heal-garden-foreman
notice_count: 14
first_seen: 2026-11-14T04:26:12Z
last_seen: 2026-11-15T15:12:03Z
---
WATCHDOG notice — occurrence #14 (first seen 2026-11-14T04:26:12Z, latest 2026-11-15T15:12:03Z).
The SAME condition (`self-heal-garden-foreman`) has now been observed 14 times; this is ONE
coalesced notice that updates in place, not 14 messages. Latest detail:

self-heal: garden-foreman exited rc=78 with no scoped fix. Capture: 86d255d5acc6d8b1b36b83893991aae261f5f210 (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p 86d255d5acc6d8b1b36b83893991aae261f5f210). Diagnosis: JOB self-heal-fix-garden-foreman-paused-project-post-rc78
The foreman exits 78 and the unit fails whenever it picks a milestone step that belongs to a paused project.

Failure signature, from the 2026-11-15 15:11:46 log tail:
- `[post] refusing to post 'build-daemon-git-remotes-transport-timing-r2': it belongs to PAUSED project 'minion-town' (journal pause record pauses/minion-town.md) (rc=78)`.
- `[foreman] ERROR: post-job failed for next milestone step ... (rc=78)`.
- The foreman then exits with `exit "$post_rc"`.
- The log also shows a related symptom: "failed to promote deferred plan job ... kriscendobot-minion.town-pr199-review-4460eb00-retro; stopping deferred promotion this tick".

Cause: the post-job failure branch in `scripts/jobs/foreman.sh` (around lines 737-740) treats every no
