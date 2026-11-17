from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-11-17T01:46:19Z
watchdog_key: self-heal-garden-foreman
notice_count: 20
first_seen: 2026-11-14T04:26:12Z
last_seen: 2026-11-17T01:46:19Z
---
WATCHDOG notice — occurrence #20 (first seen 2026-11-14T04:26:12Z, latest 2026-11-17T01:46:19Z).
The SAME condition (`self-heal-garden-foreman`) has now been observed 20 times; this is ONE
coalesced notice that updates in place, not 20 messages. Latest detail:

self-heal: garden-foreman exited rc=78 with no scoped fix. Capture: f8d31d1ff59a6ff0252b5e9c43d176ba35a2515b (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p f8d31d1ff59a6ff0252b5e9c43d176ba35a2515b). Diagnosis: The foreman exited 78 because `post-job.sh` refused a post under the minion-town project pause, and the foreman treats any non-zero post result as fatal. I haven't tested the fix below.

- **Failure:** the foreman tried to post its next milestone step, `shepherd-endojs-endo-but-for-bots-pr1347-20261117`. `project_pause_hit` matched the body against the `minion\.town` pause record (`pauses/minion-town.md`, in force since 2026-11-10). `post-job.sh` returned `GARDEN_PAUSED_RC` (78). `scripts/jobs/foreman.sh` (around line 737) handles only the transient and completed-collision codes specially. Every other non-zero code goes to `exit "$post_rc"`. A deliberate pause refusal therefore kills the tick, and systemd restarts the service each time. An earlier tick also failed to promote a deferred pla
