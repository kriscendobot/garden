from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-09-27T08:30:08Z
watchdog_key: self-heal-garden-ci-watcher-kriscendobot-finbot
notice_count: 8
first_seen: 2026-09-27T02:28:18Z
last_seen: 2026-09-27T08:30:08Z
---
WATCHDOG notice — occurrence #8 (first seen 2026-09-27T02:28:18Z, latest 2026-09-27T08:30:08Z).
The SAME condition (`self-heal-garden-ci-watcher-kriscendobot-finbot`) has now been observed 8 times; this is ONE
coalesced notice that updates in place, not 8 messages. Latest detail:

self-heal: garden-ci-watcher@kriscendobot-finbot exited rc=1 with no scoped fix. Capture: 1dd7e4beab962ff726b0da3e74c37561a3c2a39a (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p 1dd7e4beab962ff726b0da3e74c37561a3c2a39a). Diagnosis: This is the already-known clone-lock contention bug — `garden-ci-watcher@kriscendobot-finbot` timed out after 3×60s backoff waiting on `/home/kris/garden/.garden-state/ci-watcher/verify.lock`, held by a live (not crashed) peer holder. I confirmed the fix for exactly this failure signature (per-slug clone isolation + quiet-skip on live-holder contention) is already merged to `origin/main2` as `5620bdbe5f6` (isolate CI watcher clones per slug) and `e6ea1d33fc8` (skip quietly on live-holder clone-lock contention), but the **deployed root checkout on this host is 36 commits behind `origin/main2`** and does not yet contain either commit — this is deliberate-deploy lag, not a missing fix.

No new job needed: posting another `self-heal-fix-*` job would just duplicate work already done and si
