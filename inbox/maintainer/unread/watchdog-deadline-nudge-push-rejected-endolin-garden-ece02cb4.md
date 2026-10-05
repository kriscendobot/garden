from_host: endolin-garden-ece02cb4
from: watchdog:deadline-nudge
sent_at: 2026-10-05T20:18:32Z
watchdog_key: deadline-nudge-push-rejected:endolin-garden-ece02cb4
notice_count: 2
first_seen: 2026-10-04T21:48:21Z
last_seen: 2026-10-05T20:18:32Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-10-04T21:48:21Z, latest 2026-10-05T20:18:32Z).
The SAME condition (`deadline-nudge-push-rejected:endolin-garden-ece02cb4`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

deadline-nudge on endolin-garden-ece02cb4 cannot push to journal2: server-reject rejection (To github.com:kriscendobot/garden.git  ! [remote rejected]       HEAD -> journal2 (cannot lock ref 'refs/heads/journal2': is at 13794d0a3e18e1ecaa40487b1a3a6acc5bfec809 but expected 9d1e6f0d8da33e79f4e21fb3f1dafea9226ba066) error: failed...). Deadline warnings are not being delivered; this needs repair (credentials, upstream, or a receive-side policy), not a retry.
