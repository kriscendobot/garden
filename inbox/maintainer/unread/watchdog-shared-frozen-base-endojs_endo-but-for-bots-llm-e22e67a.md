from_host: endolin-garden2-5bcdff64
from: watchdog:ci-wait-merge
sent_at: 2026-08-27T10:56:26Z
watchdog_key: shared-frozen-base-endojs_endo-but-for-bots-llm-e22e67a
notice_count: 2
first_seen: 2026-08-22T07:14:36Z
last_seen: 2026-08-27T10:56:26Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-08-22T07:14:36Z, latest 2026-08-27T10:56:26Z).
The SAME condition (`shared-frozen-base-endojs_endo-but-for-bots-llm-e22e67a`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

conductor unfreeze BLOCKED for endojs/endo-but-for-bots#1046: frozen base 'llm-e22e67a' is shared by open PRs (#1046, #475). Forwarding #1046 to live 'llm' alone would fork the stack off the shared base. Weave the stack forward together, or merge them in dependency order — do not let me do it unilaterally. (#1046 left on the snapshot: not stranded silently, not force-forked.)
