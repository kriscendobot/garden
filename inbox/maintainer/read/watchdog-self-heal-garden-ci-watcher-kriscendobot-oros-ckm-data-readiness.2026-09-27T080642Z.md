from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-09-27T08:06:42Z
watchdog_key: self-heal-garden-ci-watcher-kriscendobot-oros-ckm-data-readiness
notice_count: 7
first_seen: 2026-09-27T03:10:57Z
last_seen: 2026-09-27T08:06:42Z
---
WATCHDOG notice — occurrence #7 (first seen 2026-09-27T03:10:57Z, latest 2026-09-27T08:06:42Z).
The SAME condition (`self-heal-garden-ci-watcher-kriscendobot-oros-ckm-data-readiness`) has now been observed 7 times; this is ONE
coalesced notice that updates in place, not 7 messages. Latest detail:

self-heal: garden-ci-watcher@kriscendobot-oros-ckm-data-readiness exited rc=1 with no scoped fix. Capture: 3ab22ab8be6cfd75c29a285d91ef182b9c479c82 (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p 3ab22ab8be6cfd75c29a285d91ef182b9c479c82). Diagnosis: This is exactly the known, already-fixed shared-VERIFY-clone-lock-contention bug documented in memory. HEAD (`47b41af5a14`) is 32 commits behind `origin/main2` and does not yet contain `5620bdbe5f6` ("fix: isolate CI watcher clones per slug") or the follow-on hardening commits (`e6ea1d33fc8`, `5b48813cd0b`, and many more through `5b0a95ac0b3`). This is deploy-lag on this host, not a new defect — the rolling deploy just hasn't advanced this root checkout past the fix yet.

No JOB block warranted. This is the same recurring deploy-lag pattern already tracked across many hosts today (endo-but-for-bots, proposal-compartments, cosgov, vattr97, finbot, test262, moddable, minion.town, list) — `kriscendobot-oros-ckm-data-readiness` is simply another host still running the pre-fix root. Once it
