from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-09-22T02:04:26Z
watchdog_key: self-heal-garden-receipt-watcher-kriscendobot-oros-ckm-data-readiness
notice_count: 1
first_seen: 2026-09-22T02:04:17Z
last_seen: 2026-09-22T02:04:26Z
---
self-heal: garden-receipt-watcher@kriscendobot-oros-ckm-data-readiness exited rc=1 with no scoped fix. Capture: a2de302ad9c8ab01f98293638ba517ac50a0942d (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p a2de302ad9c8ab01f98293638ba517ac50a0942d). Diagnosis: This host's deployed root checkout is 31 commits behind `origin/main2` — 3 days stale. Critically, `origin/main2` already contains three separate fixes for exactly this failure signature (empty `PREREQ_ERR`, rc=1, no diagnostic captured): `06690f63fa` (empty-stderr guard), `3002969de52` (ERR trap to capture the failing command), and `eee600976bb` (syslog-priority-prefix fix). Journal history shows this exact class of failure has already triggered several self-heal fix jobs, one of which (`self-heal-fix-garden-receipt-watcher-silent-prereq-rc1`) explicitly found "already fixed... no new commit needed" and made no change.

Posting another fix job here would just repeat that no-op — the code fix already exists and is merged. The actual defect is deploy lag: this host hasn't run `deploy-ga
