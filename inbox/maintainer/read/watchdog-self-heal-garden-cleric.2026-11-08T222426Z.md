from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-11-08T22:24:26Z
watchdog_key: self-heal-garden-cleric
notice_count: 2
first_seen: 2026-11-08T20:52:23Z
last_seen: 2026-11-08T22:24:26Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-11-08T20:52:23Z, latest 2026-11-08T22:24:26Z).
The SAME condition (`self-heal-garden-cleric`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

self-heal: garden-cleric exited rc=1 with no scoped fix. Capture: 68a3aa79e0e22388d374f2de85adc6329b20a53b (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p 68a3aa79e0e22388d374f2de85adc6329b20a53b). Diagnosis: **Diagnosis: the disk is full, so this is environmental and I'm not posting a fix job.**

- **What failed:** `garden-cleric` (worker 2) exited with code 1 after the log line `FATAL: claim failed (rc=4)`. Just before it, git printed `error: failed to write new configuration file .../clerics/2/journal/.git/config.lock`.
- **Cause:** `/home/kris/garden` is on `/dev/nvme0n1p2`, which is 3.4T of 3.6T used with only 348M free (100%). Git couldn't write its config lock in the cleric's journal clone, so the claim step died.
- **Related symptom:** the monitor logs also show it sweeping stray `tmp_pack` files from killed fetches, which is consistent with disk pressure.
- **Why not a code fix:** nothing in the claim script is wrong. In the same log, every earlier claim attempt ran normally and found 
