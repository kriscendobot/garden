from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-09-27T05:33:12Z
watchdog_key: self-heal-garden-ci-watcher-kriscendobot-vattr97
notice_count: 4
first_seen: 2026-09-27T02:48:19Z
last_seen: 2026-09-27T05:33:12Z
---
WATCHDOG notice — occurrence #4 (first seen 2026-09-27T02:48:19Z, latest 2026-09-27T05:33:12Z).
The SAME condition (`self-heal-garden-ci-watcher-kriscendobot-vattr97`) has now been observed 4 times; this is ONE
coalesced notice that updates in place, not 4 messages. Latest detail:

self-heal: garden-ci-watcher@kriscendobot-vattr97 exited rc=1 with no scoped fix. Capture: 95858320db0f595c04e5194e721b1504f2a8d751 (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p 95858320db0f595c04e5194e721b1504f2a8d751). Diagnosis: The failure blob is the whole log (only 5 lines) — no more context needed.

**Diagnosis:** `garden-ci-watcher@kriscendobot-vattr97` hit the shared `verify.lock` clone-lock contention bug (`ci-watcher@<repo> FATAL "cannot acquire clone lock .../verify.lock"`), already fixed on `origin/main2` by commits `5620bdbe5f6` (isolate CI watcher clones per slug) and `e6ea1d33fc8` (skip quietly on live-holder contention), both landed 2026-09-27T00:01. The root checkout (`<garden-root>`, currently deployed at `47b41af5a14`, 2026-09-26) hasn't picked up that fix yet — it's a deploy-lag recurrence of an already-closed bug, not a new defect. This matches the existing memory `ci-watcher-clone-lock-contention-fix-queued-not-deployed.md`.

No job posted — per that memory's guidance, always diff `HEAD..
