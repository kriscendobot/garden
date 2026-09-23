from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-09-22T02:12:06Z
watchdog_key: self-heal-garden-receipt-watcher-kriscendobot-minion-town
notice_count: 1
first_seen: 2026-09-22T02:12:06Z
last_seen: 2026-09-22T02:12:06Z
---
self-heal: garden-receipt-watcher@kriscendobot-minion.town exited rc=1 with no scoped fix. Capture: c1660d7447599781ac22c9267181d837b88ea9fc (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p c1660d7447599781ac22c9267181d837b88ea9fc). Diagnosis: This failure is not a new bug — it's the already-diagnosed "silent prereq stderr" class in `scripts/jobs/receipt-watcher.sh`: `( ensure_clone; sync_clone ) 2>"$PREREQ_ERR" || prereq_rc=$?` can fail via a bare `set -e` exit inside the sourced helpers without ever writing to `$PREREQ_ERR`, so `die` prints "see prerequisite stderr above" with nothing above it — exactly what the captured blob shows (a single FATAL line, zero `  prerequisite: ...` lines). This exact signature was already fixed on `main2` today: commit `06690f63fa` (guard `[ -s "$PREREQ_ERR" ]` + distinct empty-stderr message) and `3002969de5` (ERR trap to capture the failing command/line), closing two earlier self-heal jobs (`self-heal-fix-garden-receipt-watcher-kriscendobot-proposal-compartments-silent-prereq-stderr` and t
