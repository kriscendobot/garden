from_host: endolin-garden-ece02cb4
from: watchdog:deadline-nudge
sent_at: 2026-11-04T10:28:38Z
watchdog_key: deadline-nudge-push-rejected:endolin-garden-ece02cb4
notice_count: 3
first_seen: 2026-11-04T10:00:43Z
last_seen: 2026-11-04T10:28:38Z
---
WATCHDOG notice — occurrence #3 (first seen 2026-11-04T10:00:43Z, latest 2026-11-04T10:28:38Z).
The SAME condition (`deadline-nudge-push-rejected:endolin-garden-ece02cb4`) has now been observed 3 times; this is ONE
coalesced notice that updates in place, not 3 messages. Latest detail:

deadline-nudge on endolin-garden-ece02cb4 cannot push to journal2: definite-fail rejection (git@github.com: Permission denied (publickey). fatal: Could not read from remote repository.  Please make sure you have the correct access rights and the repository exists.). Deadline warnings are not being delivered; this needs repair (credentials, upstream, or a receive-side policy), not a retry.
