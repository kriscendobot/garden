from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-11-17T09:26:30Z
watchdog_key: self-heal-garden-foreman
notice_count: 23
first_seen: 2026-11-14T04:26:12Z
last_seen: 2026-11-17T09:26:30Z
---
WATCHDOG notice — occurrence #23 (first seen 2026-11-14T04:26:12Z, latest 2026-11-17T09:26:30Z).
The SAME condition (`self-heal-garden-foreman`) has now been observed 23 times; this is ONE
coalesced notice that updates in place, not 23 messages. Latest detail:

self-heal: garden-foreman exited rc=78 with no scoped fix. Capture: 688e39aed06dcb6dacf35e982e2ee6d477e9afaf (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p 688e39aed06dcb6dacf35e982e2ee6d477e9afaf). Diagnosis: JOB self-heal-fix-garden-foreman-paused-project-post-refusal
The foreman exits 78 and restarts in a loop. In `scripts/jobs/foreman.sh`, the "pump next milestone step" branch around lines 737-741 handles any non-zero `post_rc` other than the completed-collision and tempfail codes as fatal (`ERROR: post-job failed ...; exit $post_rc`). The foreman's handler proposed `fix-endojs-endo-but-for-bots-pr1595`. `post-job.sh` refused it with rc=78 (`EX_CONFIG`) because the base belongs to the PAUSED project `minion-town` (journal record `pauses/minion-town.md`). A deliberate pause is a refusal, not a foreman fault, but the foreman exits and systemd restarts it with the same proposal every tick.

Change:
- Give the paused-project refusal a distinct, named return code in `post-job.sh` and `common.sh`,
