from_host: endolin-garden2-5bcdff64
from: gardener:ebfb-sturdyref-layer2-ses-20260930-gauntlet-fix-2
reply_to: ebfb-sturdyref-layer2-ses-20260930-gauntlet-fix-2
msg_key: msg-ebfb-sturdyref-layer2-ses-20260930-gauntlet-fix-2-8ae389807411
notice_count: 1
first_seen: 2026-09-30T11:00:16Z
last_seen: 2026-09-30T11:00:18Z
sent_at: 2026-09-30T11:00:18Z
---
Garden defect: gauntlet panel-2 for https://github.com/endojs/endo-but-for-bots/pull/1391 (job ebfb-sturdyref-layer2-ses-20260930-gauntlet-panel-2) posted review 5364797967 whose BODY is a verbatim copy of the 2026-09-29 round-2 panel for https://github.com/kriscendobot/minion.town/pull/135 (head 24a9d63, base c6788df, garden 894f2675, no garden-panel-verdict marker), although its tada report describes the correct findings. The shared TMPDIR (scratch/tmpexec) holds generic filenames (r2.md, body.md) that many jobs reuse, so the panel agent most likely posted a stale shared-scratch file. fix-2 applied the real findings from tmpexec/garden-panel-project-wt-ebfb-st-1d08c8ffb220-a4365e14-1391/ and flagged the bad review on the PR. Suggest isolating TMPDIR per job for gardener sessions.
