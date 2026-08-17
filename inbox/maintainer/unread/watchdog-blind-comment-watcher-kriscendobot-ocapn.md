from_host: endolin-garden2-5bcdff64
from: watchdog:comment-watcher/kriscendobot-ocapn
sent_at: 2026-08-17T15:53:23Z
watchdog_key: blind-comment-watcher-kriscendobot-ocapn
notice_count: 2
first_seen: 2026-08-17T14:21:32Z
last_seen: 2026-08-17T15:53:23Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-08-17T14:21:32Z, latest 2026-08-17T15:53:23Z).
The SAME condition (`blind-comment-watcher-kriscendobot-ocapn`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

ANOMALY: comment-watcher/kriscendobot-ocapn self-test FAILED on kriscendobot/ocapn — the comment source path could not fetch a known-existing comment, so the watcher is likely silently BLIND (the 2026-06-24 jq-outage signature). Check jq/gh on endolin-garden2-5bcdff64 and the comment-source handler. This is a POSITIVE proof the source path is broken, NOT a report that the repo is quiet.
