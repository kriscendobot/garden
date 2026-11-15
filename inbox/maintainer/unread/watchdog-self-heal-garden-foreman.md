from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-11-15T17:17:05Z
watchdog_key: self-heal-garden-foreman
notice_count: 16
first_seen: 2026-11-14T04:26:12Z
last_seen: 2026-11-15T17:17:05Z
---
WATCHDOG notice — occurrence #16 (first seen 2026-11-14T04:26:12Z, latest 2026-11-15T17:17:05Z).
The SAME condition (`self-heal-garden-foreman`) has now been observed 16 times; this is ONE
coalesced notice that updates in place, not 16 messages. Latest detail:

self-heal: garden-foreman exited rc=78 with no scoped fix. Capture: cbdf6f261fbe576f06bbfa50b6d1e1c9f8af92a3 (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p cbdf6f261fbe576f06bbfa50b6d1e1c9f8af92a3). Diagnosis: JOB self-heal-fix-garden-foreman-paused-project-post-rc78
The foreman exits 78 and the unit fails whenever it proposes a milestone step for a paused project.

**Failure signature:** `scripts/jobs/foreman.sh` logs `[post] refusing to post 'daemon-git-capability-phase-five-contract-tests-build-r2': it belongs to PAUSED project 'minion-town' (journal pause record pauses/minion-town.md) ... (rc=78)`, then `ERROR: post-job failed for next milestone step ... (rc=78)`. The `elif [ "$post_rc" -ne 0 ]` branch near line 737 then does `exit "$post_rc"`.

**Cause:** `post-job.sh` deliberately refuses paused-project posts with rc=78. The foreman treats that as a fatal tick error, so the unit fails and restarts every tick. The same tick also logged a failed deferred-plan promotion for `kriscendobot-mini
