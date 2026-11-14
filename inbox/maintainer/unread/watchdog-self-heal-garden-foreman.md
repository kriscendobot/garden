from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-11-14T22:36:26Z
watchdog_key: self-heal-garden-foreman
notice_count: 8
first_seen: 2026-11-14T04:26:12Z
last_seen: 2026-11-14T22:36:26Z
---
WATCHDOG notice — occurrence #8 (first seen 2026-11-14T04:26:12Z, latest 2026-11-14T22:36:26Z).
The SAME condition (`self-heal-garden-foreman`) has now been observed 8 times; this is ONE
coalesced notice that updates in place, not 8 messages. Latest detail:

self-heal: garden-foreman exited rc=78 with no scoped fix. Capture: 60c45f39ec119ae48525ab5f821a5d87f2b6a52c (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p 60c45f39ec119ae48525ab5f821a5d87f2b6a52c). Diagnosis: JOB self-heal-fix-garden-foreman-paused-rc78-post-job
The `garden-foreman` service exits 78 (`GARDEN_PAUSED_RC`) whenever `post-job.sh` refuses a job that belongs to a PAUSED project. Foreman then keeps re-proposing the same step and failing the same way every tick.

Failure signature from the log tail:
- `[post] refusing to post 'weave-endojs-endo-but-for-bots-pr1537': it belongs to PAUSED project 'minion-town' (rc=78)`
- `[foreman] ERROR: post-job failed for next milestone step ... (rc=78)`
- Earlier in the same tick: `failed to promote deferred plan job 'kriscendobot-minion.town-pr199-review-...-retro'; stopping deferred promotion this tick`.

The minion.town pause is recorded in `pauses/minion-town.md`.

Changes:
1. In `scripts/jobs/foreman.sh`, in the `post_rc` handling around lines 7
