from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-09-27T08:13:46Z
watchdog_key: self-heal-garden-ci-watcher-kriscendobot-cosgov
notice_count: 9
first_seen: 2026-09-27T01:56:24Z
last_seen: 2026-09-27T08:13:46Z
---
WATCHDOG notice — occurrence #9 (first seen 2026-09-27T01:56:24Z, latest 2026-09-27T08:13:46Z).
The SAME condition (`self-heal-garden-ci-watcher-kriscendobot-cosgov`) has now been observed 9 times; this is ONE
coalesced notice that updates in place, not 9 messages. Latest detail:

self-heal: garden-ci-watcher@kriscendobot-cosgov exited rc=1 with no scoped fix. Capture: b6c298962fc49a5a2fa28d8e0a98b7dc413bb037 (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p b6c298962fc49a5a2fa28d8e0a98b7dc413bb037). Diagnosis: This confirms exactly the known deploy-lag pattern from memory: the fix for this FATAL (clone-lock contention on the shared `verify.lock`) already exists on `origin/main2` — commits `5620bdbe5f6` (isolate CI watcher clones per slug) and `e6ea1d33fc8` (skip quietly on live-holder contention) plus several follow-on hardening commits — but the root checkout (`HEAD`) is 34 commits behind `origin/main2` and hasn't picked them up yet.

This is not a new bug requiring a new fix job; it's the same already-fixed issue recurring purely because of deploy lag. Per my memory of this exact recurring pattern, I should not post a duplicate `self-heal-fix-*` job — the correct remedy is deploying the root checkout, which is a separate deliberate/drained operation, not something this diagnosis step sho
