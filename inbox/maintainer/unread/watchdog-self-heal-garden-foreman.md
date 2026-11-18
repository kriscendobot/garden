from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-11-18T02:14:41Z
watchdog_key: self-heal-garden-foreman
notice_count: 27
first_seen: 2026-11-14T04:26:12Z
last_seen: 2026-11-18T02:14:41Z
---
WATCHDOG notice — occurrence #27 (first seen 2026-11-14T04:26:12Z, latest 2026-11-18T02:14:41Z).
The SAME condition (`self-heal-garden-foreman`) has now been observed 27 times; this is ONE
coalesced notice that updates in place, not 27 messages. Latest detail:

self-heal: garden-foreman exited rc=78 with no scoped fix. Capture: 0f483bd3a23966521bf0e069581f84e0b4d56abb (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p 0f483bd3a23966521bf0e069581f84e0b4d56abb). Diagnosis: The foreman exited 78 because the milestone step it proposed belongs to a paused project, so `post-job.sh` refused it on purpose. The foreman then treated that refusal as a fatal error.

JOB self-heal-fix-garden-foreman-paused-project-rc78
`scripts/jobs/foreman.sh` (around line 737, the `elif [ "$post_rc" -ne 0 ]` branch after the post-job retry loop) exits with the raw `post_rc` whenever `post-job.sh` fails. When the proposed milestone step belongs to a paused project, `post-job.sh` deliberately refuses with rc=78. That refusal is a policy outcome, not a defect.
- Failure signature: `[post] refusing to post 'build-endopi-extension-package-manifest': it belongs to PAUSED project 'minion-town' (journal pause record pauses/minion-town.md) (rc=78)`, then `[foreman] ERROR: post-job failed for 
