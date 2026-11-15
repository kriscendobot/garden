from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-11-15T09:02:07Z
watchdog_key: self-heal-garden-foreman
notice_count: 12
first_seen: 2026-11-14T04:26:12Z
last_seen: 2026-11-15T09:02:07Z
---
WATCHDOG notice — occurrence #12 (first seen 2026-11-14T04:26:12Z, latest 2026-11-15T09:02:07Z).
The SAME condition (`self-heal-garden-foreman`) has now been observed 12 times; this is ONE
coalesced notice that updates in place, not 12 messages. Latest detail:

self-heal: garden-foreman exited rc=78 with no scoped fix. Capture: caa5af6cc9cd0a66289a32f0773cfeb61725058f (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p caa5af6cc9cd0a66289a32f0773cfeb61725058f). Diagnosis: JOB self-heal-fix-garden-foreman-paused-project-rc78
The `garden-foreman` unit exits 78 on every tick that proposes a job for a paused project. The service tail ends with `[post] refusing to post 'weave-endojs-endo-but-for-bots-pr1542': it belongs to PAUSED project 'minion-town' (journal pause record pauses/minion-town.md) (rc=78)`. The next line is `[foreman] ERROR: post-job failed for next milestone step ... (rc=78)`.

In `scripts/jobs/foreman.sh`, in the next-milestone-step pump block near lines 700-745, only the completed-collision rc and the transient rc 75 are handled. Any other nonzero rc falls into the generic `elif [ "$post_rc" -ne 0 ]` branch, which does `exit "$post_rc"`. So a deliberate paused-project refusal (rc 78, a config error that systemd won't retry) is treated as a brok
