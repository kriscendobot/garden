from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-11-14T15:12:37Z
watchdog_key: self-heal-garden-foreman
notice_count: 6
first_seen: 2026-11-14T04:26:12Z
last_seen: 2026-11-14T15:12:37Z
---
WATCHDOG notice — occurrence #6 (first seen 2026-11-14T04:26:12Z, latest 2026-11-14T15:12:37Z).
The SAME condition (`self-heal-garden-foreman`) has now been observed 6 times; this is ONE
coalesced notice that updates in place, not 6 messages. Latest detail:

self-heal: garden-foreman exited rc=78 with no scoped fix. Capture: 4a188f54cc7b8512ab1aff57f7e6ccca0ace057c (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p 4a188f54cc7b8512ab1aff57f7e6ccca0ace057c). Diagnosis: The foreman exited 78 because its post of `design-daemon-git-remotes-server-half-r2` was refused. That job belongs to the paused project `minion-town`. It exits with the post-job return code, so it fails again on every tick.

JOB self-heal-fix-garden-foreman-paused-project-rc78
Failure: `garden-foreman` exits 78 (EX_CONFIG). Last log lines: `[post] refusing to post 'design-daemon-git-remotes-server-half-r2': it belongs to PAUSED project 'minion-town' (journal pause record pauses/minion-town.md) (rc=78)`, then `[foreman] ERROR: post-job failed for next milestone step ... (rc=78)`.
Cause: in `scripts/jobs/foreman.sh`, around line 737, the generic `post_rc -ne 0` branch runs `exit "$post_rc"` for any non-zero rc. Post-job returns 78 as a deliberate refusal when the project is paused (the mini
