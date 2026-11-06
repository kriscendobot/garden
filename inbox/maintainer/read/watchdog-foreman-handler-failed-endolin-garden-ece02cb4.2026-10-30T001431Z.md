from_host: endolin-garden-ece02cb4
from: watchdog:foreman
sent_at: 2026-10-30T00:14:31Z
watchdog_key: foreman-handler-failed-endolin-garden-ece02cb4
notice_count: 12
first_seen: 2026-09-28T08:35:57Z
last_seen: 2026-10-30T00:14:31Z
---
WATCHDOG notice — occurrence #12 (first seen 2026-09-28T08:35:57Z, latest 2026-10-30T00:14:31Z).
The SAME condition (`foreman-handler-failed-endolin-garden-ece02cb4`) has now been observed 12 times; this is ONE
coalesced notice that updates in place, not 12 messages. Latest detail:

garden-foreman's pump handler (/home/kris/garden/scripts/jobs/handlers/foreman-claude.sh) failed rc=1 on endolin-garden-ece02cb4; the board pump is starving. stderr tail: ened-text-codecs-shim after endojs/endo-but-for-bots#1349 closed unmerged. Decide whether to reopen/rebuild it and whether #1582 must land in its frozen base before proceeding.  …  MAINTAINER M2 is blocked on completing hardened-text-codecs-shim after endojs/endo-but-for-bots#1349 closed unmerged. Decide whether to reopen/rebuild it and whether #1582 mu
<3>00:14:31 [foreman-claude] FATAL: foreman provider 'openai' returned malformed semantic output; refusing fallback to avoid multiplying work
