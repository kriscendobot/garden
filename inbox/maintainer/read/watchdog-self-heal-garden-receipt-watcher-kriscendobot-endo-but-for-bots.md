from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-09-22T06:59:26Z
watchdog_key: self-heal-garden-receipt-watcher-kriscendobot-endo-but-for-bots
notice_count: 1
first_seen: 2026-09-22T06:59:26Z
last_seen: 2026-09-22T06:59:26Z
---
self-heal: garden-receipt-watcher@kriscendobot-endo-but-for-bots exited rc=1 with no scoped fix. Capture: 62a740261ce67f0dd332301ecd3f8838777f9d72 (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p 62a740261ce67f0dd332301ecd3f8838777f9d72). Diagnosis: This confirms the memory exactly: the fix (`06690f63fa`) is already landed on `origin/main2` (41 commits ahead), but this host's deployed root checkout (HEAD) hasn't rolled forward yet — the `clone_lock` bug (permanent stderr-silencing `exec {fd}>&- 2>/dev/null`) is still live in the deployed `scripts/jobs/common.sh:3785`. This is pure deploy lag, not a new bug.

Per the memory's guidance, I will not post another `self-heal-fix-garden-receipt-watcher-*` job — it would just rediscover the already-landed fix. No JOB block.

This is a known, already-fixed failure: `garden-receipt-watcher@kriscendobot-endo-but-for-bots` hit the `clone_lock` permanent-stderr-silencing bug (an `exec {fd}>&- 2>/dev/null || true` on the flock-timeout retry branch of `clone_lock` in `scripts/jobs/common.sh`, wh
