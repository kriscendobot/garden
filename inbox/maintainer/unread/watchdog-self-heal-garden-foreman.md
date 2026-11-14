from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-11-14T08:52:20Z
watchdog_key: self-heal-garden-foreman
notice_count: 4
first_seen: 2026-11-14T04:26:12Z
last_seen: 2026-11-14T08:52:20Z
---
WATCHDOG notice — occurrence #4 (first seen 2026-11-14T04:26:12Z, latest 2026-11-14T08:52:20Z).
The SAME condition (`self-heal-garden-foreman`) has now been observed 4 times; this is ONE
coalesced notice that updates in place, not 4 messages. Latest detail:

self-heal: garden-foreman exited rc=78 with no scoped fix. Capture: 98645335b47ab9ed40227560045bc9a8e7a08611 (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p 98645335b47ab9ed40227560045bc9a8e7a08611). Diagnosis: JOB self-heal-fix-garden-foreman-paused-project-rc78
`scripts/jobs/foreman.sh` (around line 737) treats any nonzero `post-job.sh` return code as fatal and runs `exit "$post_rc"`. The failing case is rc=78. `post-job.sh` returns 78 when the step belongs to a PAUSED project: "refusing to post 'build-daemon-git-capability-phase-five-contract-tests-build-r2': it belongs to PAUSED project 'minion-town' (journal pause record pauses/minion-town.md)". The foreman proposes a next milestone step for minion.town, which is deliberately paused (commit a0b0f010fcc, "record the minion.town project pause"). The post is refused, the foreman exits 78, and self-heal fires every tick.

Fix:
1. In `foreman.sh`, handle `post_rc == 78` explicitly, as a clean outcome like `post-tempfail`. Call `decide paused-proj
