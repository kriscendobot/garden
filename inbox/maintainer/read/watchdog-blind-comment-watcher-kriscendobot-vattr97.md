from_host: endolin-garden2-5bcdff64
from: watchdog:comment-watcher/kriscendobot-vattr97
sent_at: 2026-08-17T15:25:42Z
watchdog_key: blind-comment-watcher-kriscendobot-vattr97
notice_count: 2
first_seen: 2026-08-17T14:22:24Z
last_seen: 2026-08-17T15:25:42Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-08-17T14:22:24Z, latest 2026-08-17T15:25:42Z).
The SAME condition (`blind-comment-watcher-kriscendobot-vattr97`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

ANOMALY: comment-watcher/kriscendobot-vattr97 self-test FAILED on kriscendobot/vattr97 — the comment source path could not fetch a known-existing comment, so the watcher is likely silently BLIND (the 2026-06-24 jq-outage signature). Check jq/gh on endolin-garden2-5bcdff64 and the comment-source handler. This is a POSITIVE proof the source path is broken, NOT a report that the repo is quiet.
