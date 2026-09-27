from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-09-27T08:06:50Z
watchdog_key: self-heal-garden-ci-watcher-kriscendobot-moddable
notice_count: 8
first_seen: 2026-09-27T02:26:27Z
last_seen: 2026-09-27T08:06:50Z
---
WATCHDOG notice — occurrence #8 (first seen 2026-09-27T02:26:27Z, latest 2026-09-27T08:06:50Z).
The SAME condition (`self-heal-garden-ci-watcher-kriscendobot-moddable`) has now been observed 8 times; this is ONE
coalesced notice that updates in place, not 8 messages. Latest detail:

self-heal: garden-ci-watcher@kriscendobot-moddable exited rc=1 with no scoped fix. Capture: 4f1e59b7151fbe9ac1c5e7a52cf463b0ca254e41 (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p 4f1e59b7151fbe9ac1c5e7a52cf463b0ca254e41). Diagnosis: This is the same known deploy-lag pattern already tracked in memory, not a new defect. `garden-ci-watcher@kriscendobot-moddable`'s FATAL "cannot acquire clone lock verify.lock after 3 waits ... 0 reclaim attempt(s)" matches a signature already fixed on `origin/main2` (the `5620bdbe5f6`/`e6ea1d33fc8` clone-lock-contention fix plus follow-on hardening commits like `ab66fece68f`, `ad55dea66f9`, `1570aa85a47`), but the deployed root checkout (HEAD `47b41af5a14`) is 31 commits behind `origin/main2` and hasn't picked those up yet. There's a stuck-canary marker (`endolin-garden2-5bcdff64`) blocking the rolling deploy, but it's only ~20 minutes stuck — well under the watchdog's escalation threshold, so no manual intervention needed there either.

No JOB block — this will self-resolve once the 
