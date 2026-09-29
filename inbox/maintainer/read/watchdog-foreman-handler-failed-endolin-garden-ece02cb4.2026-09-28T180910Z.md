from_host: endolin-garden-ece02cb4
from: watchdog:foreman
sent_at: 2026-09-28T18:09:10Z
watchdog_key: foreman-handler-failed-endolin-garden-ece02cb4
notice_count: 94
first_seen: 2026-09-28T08:35:57Z
last_seen: 2026-09-28T18:09:10Z
---
WATCHDOG notice — occurrence #94 (first seen 2026-09-28T08:35:57Z, latest 2026-09-28T18:09:10Z).
The SAME condition (`foreman-handler-failed-endolin-garden-ece02cb4`) has now been observed 94 times; this is ONE
coalesced notice that updates in place, not 94 messages. Latest detail:

garden-foreman's pump handler (/home/kris/garden/scripts/jobs/handlers/foreman-claude.sh) failed rc=1 on endolin-garden-ece02cb4; the board pump is starving. stderr tail: <3>18:09:04 [foreman-claude] FATAL: GARDEN_FOREMAN_PROVIDER_ORDER provider 'local' is retired (local-qwen hermit lane dropped 2026-09-13, job retire-local-qwen-hermit-lane); remove it from the garden-foreman drop-in (allowed: openai, anthropic)
<3>18:09:04 [foreman-claude] FATAL: no configured foreman inference provider was available
