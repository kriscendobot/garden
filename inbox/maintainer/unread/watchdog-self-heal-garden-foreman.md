from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-11-14T04:26:12Z
watchdog_key: self-heal-garden-foreman
notice_count: 1
first_seen: 2026-11-14T04:26:12Z
last_seen: 2026-11-14T04:26:12Z
---
self-heal: garden-foreman exited rc=78 with no scoped fix. Capture: 303fca30c54e1f87b4d38b9bf45a85ace65ca2df (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p 303fca30c54e1f87b4d38b9bf45a85ace65ca2df). Diagnosis: JOB self-heal-fix-garden-foreman-paused-project-rc78
**Failure signature.** `garden-foreman` exits 78 on a tick. The log tail ends with: `[post] refusing to post 'fixer-endojs-endo-but-for-bots-pr1595': it belongs to PAUSED project 'minion-town' (rc=78)`, then `[foreman] ERROR: post-job failed for next milestone step ... (rc=78)`.

**Cause.**
- The minion-town pause record (`journal/pauses/minion-town.md`, 2026-11-10) is working as designed.
- `project_pause_hit` in `scripts/jobs/common.sh` matches the slug or `minion\.town` against the job base and body.
- The foreman's proposed body for the endo fixer step mentions minion-town (`arc: minion-town-git-remote`). So `post-job.sh` refuses it with `GARDEN_PAUSED_RC` (78).

**Defect.** `scripts/jobs/foreman.sh` (about lines 697-740) treats ever
