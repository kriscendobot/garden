from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-11-15T00:07:10Z
watchdog_key: self-heal-garden-foreman
notice_count: 10
first_seen: 2026-11-14T04:26:12Z
last_seen: 2026-11-15T00:07:10Z
---
WATCHDOG notice — occurrence #10 (first seen 2026-11-14T04:26:12Z, latest 2026-11-15T00:07:10Z).
The SAME condition (`self-heal-garden-foreman`) has now been observed 10 times; this is ONE
coalesced notice that updates in place, not 10 messages. Latest detail:

self-heal: garden-foreman exited rc=78 with no scoped fix. Capture: eacc126344192365b2eb2b8c8bbaa34c1414b9bb (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p eacc126344192365b2eb2b8c8bbaa34c1414b9bb). Diagnosis: JOB self-heal-fix-garden-foreman-paused-project-post-rc78
The foreman exits 78 whenever its pumping hits a paused project. That makes systemd mark `garden-foreman` failed and triggers self-heal, even though nothing is broken.

Failure signature, from the captured tail:
- `[post] refusing to post 'build-daemon-git-remotes-transport-timing': it belongs to PAUSED project 'minion-town' (journal pause record pauses/minion-town.md) ... (rc=78)`
- `[foreman] ERROR: post-job failed for next milestone step ... (rc=78)`, then exit 78.

The project is paused deliberately (the minion.town pause, recorded in commit a0b0f010fcc), so the post refusal is expected.

Fix in `scripts/jobs/foreman.sh`, around lines 738-741, in the generic `elif [ "$post_rc" -ne 0 ]` branch after post-job:
- Add a dedicated br
