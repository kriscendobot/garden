from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-09-27T03:24:58Z
watchdog_key: self-heal-garden-ci-watcher-kriscendobot-minion-town
notice_count: 2
first_seen: 2026-09-27T01:58:17Z
last_seen: 2026-09-27T03:24:58Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-09-27T01:58:17Z, latest 2026-09-27T03:24:58Z).
The SAME condition (`self-heal-garden-ci-watcher-kriscendobot-minion-town`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

self-heal: garden-ci-watcher@kriscendobot-minion.town exited rc=1 with no scoped fix. Capture: e7535d1597cabd5588db87ce0407b7008484dee0 (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p e7535d1597cabd5588db87ce0407b7008484dee0). Diagnosis: This is the already-fixed shared-VERIFY-clone-lock contention bug (`ci-watcher@kriscendobot-minion.town` FATAL: cannot acquire `verify.lock` after 3×60s waits) — matches my memory of the fix landed as commits `5620bdbe5f6` + `e6ea1d33fc8`, confirmed present on `origin/main2` (landed 2026-09-27T00:01Z). The deployed root checkout's `HEAD` (`47b41af5a14`, 2026-09-26T12:42Z) predates that fix and is not an ancestor of it — this is deploy lag, not a new bug. No fix job needed; the next `deploy-garden.sh` rolling deploy will pick up the fix. Systemd's restart is sufficient in the meantime.
