from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-11-16T23:47:37Z
watchdog_key: self-heal-garden-foreman
notice_count: 18
first_seen: 2026-11-14T04:26:12Z
last_seen: 2026-11-16T23:47:37Z
---
WATCHDOG notice — occurrence #18 (first seen 2026-11-14T04:26:12Z, latest 2026-11-16T23:47:37Z).
The SAME condition (`self-heal-garden-foreman`) has now been observed 18 times; this is ONE
coalesced notice that updates in place, not 18 messages. Latest detail:

self-heal: garden-foreman exited rc=78 with no scoped fix. Capture: 393b84b6a0e41338ce79189d8a1e51be54423cde (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p 393b84b6a0e41338ce79189d8a1e51be54423cde). Diagnosis: JOB self-heal-fix-garden-foreman-paused-project-post-rc78
Failure signature: `garden-foreman` exits 78 (EX_CONFIG). The tail ends with `[post] refusing to post 'build-daemon-git-remotes-transport-timing': it belongs to PAUSED project 'minion-town' (rc=78)`, then `[foreman] ERROR: post-job failed for next milestone step ... (rc=78)`.

Cause: the foreman handler proposed a next step for the paused project `minion-town`. `post-job.sh` correctly refused with `$GARDEN_PAUSED_RC` (78). In `scripts/jobs/foreman.sh` (around line 737), the generic `elif [ "$post_rc" -ne 0 ]` branch treats any unknown rc as a fatal tick failure and does `exit "$post_rc"`. Each tick that proposes a paused-project step therefore crashes the unit and triggers self-heal. The pause is deliberate; see commit a0b0f010fcc, 
