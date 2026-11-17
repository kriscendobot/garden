from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-11-17T21:01:40Z
watchdog_key: self-heal-garden-foreman
notice_count: 25
first_seen: 2026-11-14T04:26:12Z
last_seen: 2026-11-17T21:01:40Z
---
WATCHDOG notice — occurrence #25 (first seen 2026-11-14T04:26:12Z, latest 2026-11-17T21:01:40Z).
The SAME condition (`self-heal-garden-foreman`) has now been observed 25 times; this is ONE
coalesced notice that updates in place, not 25 messages. Latest detail:

self-heal: garden-foreman exited rc=78 with no scoped fix. Capture: 2b31fa440f2dffa5c5069d94988db6160e651f94 (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p 2b31fa440f2dffa5c5069d94988db6160e651f94). Diagnosis: JOB self-heal-fix-garden-foreman-paused-project-rc78
The foreman exits 78 because it proposes a next-milestone step for a paused project, and `post-job.sh` refuses it. Failure signature from the log: `[post] refusing to post 'build-daemon-git-remotes-phase-six-interactive-provisioning-r2': it belongs to PAUSED project 'minion-town' (journal pause record pauses/minion-town.md) (rc=78)`, followed by `[foreman] ERROR: post-job failed for next milestone step ... (rc=78)`. The `minion-town` pause was recorded by commit a0b0f010fcc. In `scripts/jobs/foreman.sh`, the `elif [ "$post_rc" -ne 0 ]` branch around line 737 treats every non-zero rc other than 75 and the completed-collision rc as fatal and runs `exit "$post_rc"`. That puts the unit in failed state and triggers self-heal on every tick whi
