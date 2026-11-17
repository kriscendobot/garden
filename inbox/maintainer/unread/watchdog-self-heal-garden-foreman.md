from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-11-17T03:41:50Z
watchdog_key: self-heal-garden-foreman
notice_count: 21
first_seen: 2026-11-14T04:26:12Z
last_seen: 2026-11-17T03:41:50Z
---
WATCHDOG notice — occurrence #21 (first seen 2026-11-14T04:26:12Z, latest 2026-11-17T03:41:50Z).
The SAME condition (`self-heal-garden-foreman`) has now been observed 21 times; this is ONE
coalesced notice that updates in place, not 21 messages. Latest detail:

self-heal: garden-foreman exited rc=78 with no scoped fix. Capture: c76d63c93511b5058dc8715a7a594b49b6aae351 (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p c76d63c93511b5058dc8715a7a594b49b6aae351). Diagnosis: The foreman exited 78 because it treated a deliberate refusal as a crash. It is a scoped code fix, not a transient failure.

`post-job.sh` refused to post `weave-endojs-endo-but-for-bots-pr1542` with rc=78 (`EX_CONFIG`). The journal pause record `pauses/minion-town.md` pauses project `minion-town`, and the refusal says the job belongs to it. The generic `post_rc -ne 0` branch in `scripts/jobs/foreman.sh` (about line 737) then logged `ERROR: post-job failed ... (rc=78)` and ran `exit 78`. systemd marks that as a failed unit, which triggers self-heal. The unit will keep failing each tick for as long as the foreman proposes a paused-project step.

Two things are worth a look from the maintainer. The foreman's proposal was an endo PR weave attributed to the paused `minion-town` project, so the
