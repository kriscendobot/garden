from_host: endolin-garden-ece02cb4
from: watchdog:triager/kriscendobot-test262
sent_at: 2026-08-21T13:55:22Z
watchdog_key: triager-fetch-failed-kriscendobot-test262
notice_count: 2
first_seen: 2026-08-19T00:19:09Z
last_seen: 2026-08-21T13:55:22Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-08-19T00:19:09Z, latest 2026-08-21T13:55:22Z).
The SAME condition (`triager-fetch-failed-kriscendobot-test262`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

triager: fetch for kriscendobot-test262 at /home/kris/garden/worktrees/kriscendobot-test262.git failed (rc=128). git said: Connection to github.com closed by remote host. fatal: expected flush after ref listing
Retrying next tick; if this persists, the upstream is unreachable and kriscendobot-test262 cannot be triaged until it is restored.
