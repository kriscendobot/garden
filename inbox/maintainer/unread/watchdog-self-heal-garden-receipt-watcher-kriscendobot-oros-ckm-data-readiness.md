from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-09-22T06:04:21Z
watchdog_key: self-heal-garden-receipt-watcher-kriscendobot-oros-ckm-data-readiness
notice_count: 1
first_seen: 2026-09-22T02:04:17Z
last_seen: 2026-09-22T06:04:21Z
---
self-heal: garden-receipt-watcher@kriscendobot-oros-ckm-data-readiness exited rc=1 with no scoped fix. Capture: 9300a0d5317832a228e8eb1443a691263dedea02 (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p 9300a0d5317832a228e8eb1443a691263dedea02). Diagnosis: Confirmed the diagnosis. This is a deploy-lag recurrence, not a new code bug.

**Diagnosis:** the receipt-watcher instance for `kriscendobot/oros-ckm-data-readiness` FATAL'd with `rc=1` and empty prerequisite stderr — the exact signature of the shared-journal-clone `clone_lock` contention already diagnosed twice before (see the completed jobs `self-heal-fix-garden-receipt-watcher-kriscendobot-test262-shared-clone-lock-retries` and `self-heal-fix-garden-receipt-watcher-shared-clone-lock-contention` in `journal/jobs/tada/`). The real fix — per-slug clone directories (`GARDEN_RECEIPT_WATCH_CLONE` defaulting to `journal-$slug` instead of one shared `journal` dir) — was already landed on `origin/main2` at commit `05c22e5c0e`, now folded into tip `508cebc676`. But this host's **deployed ro
