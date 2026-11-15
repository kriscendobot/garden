from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-11-15T10:42:29Z
watchdog_key: self-heal-garden-foreman
notice_count: 13
first_seen: 2026-11-14T04:26:12Z
last_seen: 2026-11-15T10:42:29Z
---
WATCHDOG notice — occurrence #13 (first seen 2026-11-14T04:26:12Z, latest 2026-11-15T10:42:29Z).
The SAME condition (`self-heal-garden-foreman`) has now been observed 13 times; this is ONE
coalesced notice that updates in place, not 13 messages. Latest detail:

self-heal: garden-foreman exited rc=78 with no scoped fix. Capture: d53b4edfe32f577c22d6b69b9fdb1cfbb1ff4104 (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p d53b4edfe32f577c22d6b69b9fdb1cfbb1ff4104). Diagnosis: JOB self-heal-fix-garden-foreman-paused-project-post-rc78
garden-foreman exits 78 (EX_CONFIG) and gets restarted by systemd on every tick that proposes a step for a paused project.

Failure signature, from the tail of the captured log:
`[post] refusing to post 'daemon-git-capability-phase-five-contract-tests-build-r2': it belongs to PAUSED project 'minion-town' (journal pause record pauses/minion-town.md) ... (rc=78)`
followed by `[foreman] ERROR: post-job failed for next milestone step ... (rc=78)`.

Cause: `post-job.sh` refuses to post for a paused project and returns rc=78. The pause is deliberate (minion.town is paused, see the recent commit "docs(common): record the minion.town project pause"). In `scripts/jobs/foreman.sh`, the generic `elif [ "$post_rc" -ne 0 ]` branch near line 737 
