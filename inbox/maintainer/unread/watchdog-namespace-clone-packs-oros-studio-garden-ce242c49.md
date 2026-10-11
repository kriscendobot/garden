from_host: oros-studio-garden-ce242c49
from: watchdog:self-heal
sent_at: 2026-10-11T00:43:41Z
watchdog_key: namespace-clone-packs-oros-studio-garden-ce242c49
notice_count: 2
first_seen: 2026-10-10T02:43:50Z
last_seen: 2026-10-11T00:43:41Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-10-10T02:43:50Z, latest 2026-10-11T00:43:41Z).
The SAME condition (`namespace-clone-packs-oros-studio-garden-ce242c49`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

Per-namespace journal clones on oros-studio-garden-ce242c49 are still over the 50-pack threshold after maintenance:
  /Users/dom/garden/.garden-state/leader/journal: 77 packs

A pack/tmp_pack buildup makes every git read slow (2026-10-08: 57 s leader read wedged ~100 leader-gated units). Inspect by hand: `nice ionice -c3 git -C <clone> repack -a -d`.
