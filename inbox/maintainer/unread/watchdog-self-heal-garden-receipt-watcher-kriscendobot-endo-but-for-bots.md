from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-09-26T04:31:54Z
watchdog_key: self-heal-garden-receipt-watcher-kriscendobot-endo-but-for-bots
notice_count: 1
first_seen: 2026-09-22T06:59:26Z
last_seen: 2026-09-26T04:31:54Z
---
self-heal: garden-receipt-watcher@kriscendobot-endo-but-for-bots exited rc=1 with no scoped fix. Capture: 49aa0d37e12234073cc7d49cb472c52bfe391cdd (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p 49aa0d37e12234073cc7d49cb472c52bfe391cdd). Diagnosis: Diagnosis: a genuine, new classification bug in `reclone_clone` (`scripts/jobs/common.sh:4302-4316`), distinct from the already-fixed clone_lock stderr-silencing bug in memory. It drops `bounded_clone`'s exit code and classifies "offline" only by grepping captured stderr for known network-error text; a bare 45s `timeout`-SIGTERM clone kill (rc=124) that lands before git prints anything leaves that stderr empty, so the offline check misses and the failure escalates as a loud `FATAL` instead of a quiet transient skip. Posted the fix job above.
