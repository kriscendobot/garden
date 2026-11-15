from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-11-15T18:37:38Z
watchdog_key: self-heal-garden-foreman
notice_count: 17
first_seen: 2026-11-14T04:26:12Z
last_seen: 2026-11-15T18:37:38Z
---
WATCHDOG notice — occurrence #17 (first seen 2026-11-14T04:26:12Z, latest 2026-11-15T18:37:38Z).
The SAME condition (`self-heal-garden-foreman`) has now been observed 17 times; this is ONE
coalesced notice that updates in place, not 17 messages. Latest detail:

self-heal: garden-foreman exited rc=78 with no scoped fix. Capture: b26d349f516d21edb4f5fcb6ed231dd4f90797b9 (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p b26d349f516d21edb4f5fcb6ed231dd4f90797b9). Diagnosis: JOB self-heal-fix-garden-foreman-paused-project-rc78
In `scripts/jobs/foreman.sh`, around lines 737-740, the "next milestone step" post path treats every non-zero `post-job.sh` rc as fatal. It logs `ERROR: post-job failed ... (rc=$post_rc)` and runs `exit "$post_rc"`. `post-job.sh` deliberately refuses a base that belongs to a PAUSED project (here `minion-town`, journal record `pauses/minion-town.md`) and exits 78. That is a policy refusal, not a broken tick. The foreman therefore exits 78 on every tick, systemd marks `garden-foreman` failed, and self-heal fires repeatedly.

Failure signature: `[post] refusing to post '<base>': it belongs to PAUSED project 'minion-town' (rc=78)`, followed by `[foreman] ERROR: post-job failed for next milestone step ... (rc=78)`.

Fix, modeled on the existi
