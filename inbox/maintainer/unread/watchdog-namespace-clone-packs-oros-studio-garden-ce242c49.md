from_host: oros-studio-garden-ce242c49
from: watchdog:self-heal
sent_at: 2026-10-12T00:44:22Z
watchdog_key: namespace-clone-packs-oros-studio-garden-ce242c49
notice_count: 4
first_seen: 2026-10-10T02:43:50Z
last_seen: 2026-10-12T00:44:22Z
---
WATCHDOG notice — occurrence #4 (first seen 2026-10-10T02:43:50Z, latest 2026-10-12T00:44:22Z).
The SAME condition (`namespace-clone-packs-oros-studio-garden-ce242c49`) has now been observed 4 times; this is ONE
coalesced notice that updates in place, not 4 messages. Latest detail:

Per-namespace journal clones on oros-studio-garden-ce242c49 are still over the 50-pack threshold after maintenance:
  /Users/dom/garden/.garden-state/leader/journal: 66 packs

A pack/tmp_pack buildup makes every git read slow (2026-10-08: 57 s leader read wedged ~100 leader-gated units). Inspect by hand: `nice ionice -c3 git -C <clone> repack -a -d`.
