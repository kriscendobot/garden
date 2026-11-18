from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-11-18T00:00:56Z
watchdog_key: self-heal-garden-foreman
notice_count: 26
first_seen: 2026-11-14T04:26:12Z
last_seen: 2026-11-18T00:00:56Z
---
WATCHDOG notice — occurrence #26 (first seen 2026-11-14T04:26:12Z, latest 2026-11-18T00:00:56Z).
The SAME condition (`self-heal-garden-foreman`) has now been observed 26 times; this is ONE
coalesced notice that updates in place, not 26 messages. Latest detail:

self-heal: garden-foreman exited rc=78 with no scoped fix. Capture: 7afed44518eaa6372dce2807f1b7a08905dfe395 (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p 7afed44518eaa6372dce2807f1b7a08905dfe395). Diagnosis: The foreman exited 78 because `post-job.sh` refused a job, not because the foreman crashed. The foreman proposed the next step `shepherd-endojs-endo-but-for-bots-pr1542-20261118`. The `minion-town` pause record (`pauses/minion-town.md`) has `match: minion\.town`, and it matched that job, so `post-job.sh` returned `GARDEN_PAUSED_RC=78`. At `scripts/jobs/foreman.sh:738` any non-zero post result other than the completed-collision and tempfail cases is fatal, so the foreman exits 78. That repeats every tick, and each tick the handler most likely proposes the same step again. The pause itself is working as intended. The bug is that the foreman has no handling for a paused-project refusal.

JOB self-heal-fix-garden-foreman-paused-project-post-refusal
In `scripts/jobs/foreman.sh`, in the post-job
