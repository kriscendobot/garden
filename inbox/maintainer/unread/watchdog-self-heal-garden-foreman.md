from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-11-15T07:01:17Z
watchdog_key: self-heal-garden-foreman
notice_count: 11
first_seen: 2026-11-14T04:26:12Z
last_seen: 2026-11-15T07:01:17Z
---
WATCHDOG notice — occurrence #11 (first seen 2026-11-14T04:26:12Z, latest 2026-11-15T07:01:17Z).
The SAME condition (`self-heal-garden-foreman`) has now been observed 11 times; this is ONE
coalesced notice that updates in place, not 11 messages. Latest detail:

self-heal: garden-foreman exited rc=78 with no scoped fix. Capture: 94485d470884f64586a3b26ce09ca3e05a5d553b (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p 94485d470884f64586a3b26ce09ca3e05a5d553b). Diagnosis: Cause: the foreman proposed the milestone step `fix-endojs-endo-but-for-bots-pr1661`. `post-job.sh` refused it with rc=78, because the job maps to the paused project `minion-town`. The foreman's generic `post_rc -ne 0` branch (`scripts/jobs/foreman.sh`, about line 737) then runs `exit "$post_rc"`. That exit fails the unit. systemd restarts it, the same proposal comes back, and the unit fails again.

The foreman already handles the completed-collision refusal with a re-prompt, so a paused-project refusal needs the same handling.

JOB self-heal-fix-garden-foreman-paused-project-rc78
In `scripts/jobs/foreman.sh`, around lines 712-740, `post-job.sh` can refuse a proposed milestone step with rc=78 (EX_CONFIG). The log line reads "refusing to post '<base>': it belongs to PAUSED project '<p>' (jo
