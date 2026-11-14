from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-11-14T20:41:58Z
watchdog_key: self-heal-garden-foreman
notice_count: 7
first_seen: 2026-11-14T04:26:12Z
last_seen: 2026-11-14T20:41:58Z
---
WATCHDOG notice — occurrence #7 (first seen 2026-11-14T04:26:12Z, latest 2026-11-14T20:41:58Z).
The SAME condition (`self-heal-garden-foreman`) has now been observed 7 times; this is ONE
coalesced notice that updates in place, not 7 messages. Latest detail:

self-heal: garden-foreman exited rc=78 with no scoped fix. Capture: b0cadad01a747d61b92cc0ad032d77222ff1f96d (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p b0cadad01a747d61b92cc0ad032d77222ff1f96d). Diagnosis: The foreman is failing because it doesn't handle a deliberate pause. The fix is a small scoped change, so I'm posting a job for it.

JOB self-heal-fix-garden-foreman-paused-project-rc78
`garden-foreman` exits 78 on every tick that proposes a step for a paused project. The log signature is `[post] refusing to post 'design-daemon-git-remotes-server-half': it belongs to PAUSED project 'minion-town' (rc=78)`, followed by `[foreman] ERROR: post-job failed for next milestone step ... (rc=78)`. The pause itself is intended: `pauses/minion-town.md` exists, and the minion.town pause was recorded in the recent docs commit. The defect is in `scripts/jobs/foreman.sh`. Near line 737, the generic `elif [ "$post_rc" -ne 0 ]` branch logs an ERROR and does `exit "$post_rc"`, so a paused-project refusal fai
