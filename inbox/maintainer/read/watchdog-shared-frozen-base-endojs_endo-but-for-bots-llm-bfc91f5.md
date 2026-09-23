from_host: endolin-garden-ece02cb4
from: watchdog:ci-wait-merge
sent_at: 2026-08-06T16:06:39Z
watchdog_key: shared-frozen-base-endojs_endo-but-for-bots-llm-bfc91f5
notice_count: 1
first_seen: 2026-08-06T16:06:39Z
last_seen: 2026-08-06T16:06:39Z
---
conductor unfreeze BLOCKED for endojs/endo-but-for-bots#943: frozen base 'llm-bfc91f5' is shared by open PRs (#943, #888). Forwarding #943 to live 'llm' alone would fork the stack off the shared base. Weave the stack forward together, or merge them in dependency order — do not let me do it unilaterally. (#943 left on the snapshot: not stranded silently, not force-forked.)
