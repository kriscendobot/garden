from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-09-22T00:22:40Z
watchdog_key: self-heal-garden-receipt-watcher-kriscendobot-ocapn
notice_count: 1
first_seen: 2026-09-22T00:22:39Z
last_seen: 2026-09-22T00:22:40Z
---
self-heal: garden-receipt-watcher@kriscendobot-ocapn exited rc=1 with no scoped fix. Capture: b117297ea8bbf3f5d8443900ec7f167dd16c6046 (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p b117297ea8bbf3f5d8443900ec7f167dd16c6046). Diagnosis: The failure is already root-caused and fixed upstream — no new job needed.

This host's `garden-receipt-watcher@kriscendobot-ocapn` failed with `FATAL: receipt journal prerequisite failed for kriscendobot/ocapn (rc=1; see prerequisite stderr above)` and a **truly empty** prerequisite-stderr section, which is the exact signature already diagnosed and fixed on `origin/main2` in two commits this root checkout hasn't picked up yet: `85ae2f878c` (`fix(common): die() on sync_clone final reset failure` — the fallback `git reset --hard origin/$JOURNAL_BRANCH` in `sync_clone()` was a bare command under `set -e`, so its failure silently killed the subshell with no `log()`/`die()` output, leaving the outer watcher's "see prerequisite stderr above" pointing at nothing) and `eee600976b` (`fix(watch
