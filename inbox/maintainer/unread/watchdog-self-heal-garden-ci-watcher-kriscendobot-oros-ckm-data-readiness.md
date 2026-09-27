from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-09-27T05:31:40Z
watchdog_key: self-heal-garden-ci-watcher-kriscendobot-oros-ckm-data-readiness
notice_count: 3
first_seen: 2026-09-27T03:10:57Z
last_seen: 2026-09-27T05:31:40Z
---
WATCHDOG notice — occurrence #3 (first seen 2026-09-27T03:10:57Z, latest 2026-09-27T05:31:40Z).
The SAME condition (`self-heal-garden-ci-watcher-kriscendobot-oros-ckm-data-readiness`) has now been observed 3 times; this is ONE
coalesced notice that updates in place, not 3 messages. Latest detail:

self-heal: garden-ci-watcher@kriscendobot-oros-ckm-data-readiness exited rc=1 with no scoped fix. Capture: 643823dc5f078bdc71d859e53aed6e0b2d037ade (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p 643823dc5f078bdc71d859e53aed6e0b2d037ade). Diagnosis: This is deploy-lag, not a new bug. The failure is the shared-clone-lock contention pattern (`FATAL: cannot acquire clone lock .../verify.lock after 3 waits`), which was already fixed on `main2` yesterday by commits `5620bdbe5f6` ("isolate CI watcher clones per slug") and `e6ea1d33fc8` ("skip quietly on live-holder clone-lock contention"), both landed 2026-09-27T00:01Z. The root checkout (`<garden-root>`, deployed via the deliberate `deploy-garden.sh` process) is still pinned at `47b41af5a14` from 2026-09-26T12:42Z — 19 commits behind `origin/main2` — so this instance hasn't picked up the fix yet. Posting another `self-heal-fix` job would duplicate work already merged; the correct remedy is simply for the next rolling deploy to advance the root checkout past `e6ea1d33fc8`. No JOB block.
