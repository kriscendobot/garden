from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-11-17T11:04:30Z
watchdog_key: self-heal-garden-foreman
notice_count: 24
first_seen: 2026-11-14T04:26:12Z
last_seen: 2026-11-17T11:04:30Z
---
WATCHDOG notice — occurrence #24 (first seen 2026-11-14T04:26:12Z, latest 2026-11-17T11:04:30Z).
The SAME condition (`self-heal-garden-foreman`) has now been observed 24 times; this is ONE
coalesced notice that updates in place, not 24 messages. Latest detail:

self-heal: garden-foreman exited rc=78 with no scoped fix. Capture: e8f4695b24ab98e9388380a06574c95dc4617581 (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p e8f4695b24ab98e9388380a06574c95dc4617581). Diagnosis: JOB self-heal-fix-garden-foreman-paused-project-post-rc78
The `garden-foreman` service exits 78 and systemd restarts it, over and over. The tail of its log shows the cause:
`[post] refusing to post 'build-daemon-git-remotes-phase-six-interactive-provisioning-retry-20261117': it belongs to PAUSED project 'minion-town' (journal pause record pauses/minion-town.md)... (rc=78)`
`[foreman] ERROR: post-job failed for next milestone step ... (rc=78)`

The minion.town pause is deliberate (see the "record the minion.town project pause" commit, a0b0f010fcc). The foreman proposed a step for that project anyway. `post-job.sh` correctly refused with rc=78. The catch-all branch in `scripts/jobs/foreman.sh` (about line 737, `elif [ "$post_rc" -ne 0 ]`) then does `exit "$post_rc"`, which crashes the unit o
