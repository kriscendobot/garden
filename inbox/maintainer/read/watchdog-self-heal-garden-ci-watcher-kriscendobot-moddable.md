from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-09-27T02:26:27Z
watchdog_key: self-heal-garden-ci-watcher-kriscendobot-moddable
notice_count: 1
first_seen: 2026-09-27T02:26:27Z
last_seen: 2026-09-27T02:26:27Z
---
self-heal: garden-ci-watcher@kriscendobot-moddable exited rc=1 with no scoped fix. Capture: d148a8335e3c5c9149b9ddcc36de8269a98c9a56 (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p d148a8335e3c5c9149b9ddcc36de8269a98c9a56). Diagnosis: This matches the known, already-fixed clone-lock contention bug: `ci-watcher@kriscendobot-moddable` hit `FATAL: cannot acquire clone lock .../verify.lock` after 3 backoff waits, the same signature recorded in memory (`ci-watcher-clonelock-contention-fixed`). The fix (isolating CI-watcher clones per slug, plus softer lock handling — `5620bdbe5f6`, `e6ea1d33fc8`, and further hardening through `ad55dea66f9`/`ab66fece68f`) is already merged on `origin/main2`, but this host's deployed root checkout (`HEAD` at `47b41af5a14`) is **16 commits behind** main2 — a strict ancestor, not diverged. This is deploy lag, not a new defect.

No JOB block — posting `self-heal-fix-*` again would just duplicate a fix that already exists upstream and is waiting on the normal deploy pipeline. The right remed
