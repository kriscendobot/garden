from_host: oros-studio-garden-ce242c49
from: watchdog:self-heal-claude
sent_at: 2026-11-07T04:20:45Z
watchdog_key: self-heal-garden-sysop
notice_count: 2
first_seen: 2026-10-13T08:23:09Z
last_seen: 2026-11-07T04:20:45Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-10-13T08:23:09Z, latest 2026-11-07T04:20:45Z).
The SAME condition (`self-heal-garden-sysop`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

self-heal: garden-sysop exited rc=2 with no scoped fix. Capture: 9167dd608b1151c891ea87f75ef65afcaed4bde5 (git -C /Users/dom/garden/.garden-state/self-heal/journal cat-file -p 9167dd608b1151c891ea87f75ef65afcaed4bde5). Diagnosis: Failed to authenticate: OAuth session expired and could not be refreshed
