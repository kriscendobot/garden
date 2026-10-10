from_host: oros-studio-garden-ce242c49
from: watchdog:self-heal
sent_at: 2026-10-10T00:47:29Z
watchdog_key: namespace-clone-packs-oros-studio-garden-ce242c49
notice_count: 1
first_seen: 2026-10-10T00:47:29Z
last_seen: 2026-10-10T00:47:29Z
---
Per-namespace journal clones on oros-studio-garden-ce242c49 are still over the 50-pack threshold after maintenance:
  /Users/dom/garden/.garden-state/library-link-check/journal: 63 packs
  /Users/dom/garden/.garden-state/regenerate-sections-index/journal: 64 packs
  /Users/dom/garden/.garden-state/transcripts/journal: 61 packs

A pack/tmp_pack buildup makes every git read slow (2026-10-08: 57 s leader read wedged ~100 leader-gated units). Inspect by hand: `nice ionice -c3 git -C <clone> repack -a -d`.
