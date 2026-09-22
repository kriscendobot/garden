---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/receipt-watcher.sh

receipt-watcher.sh died at line 91 with "FATAL: receipt journal prerequisite failed for endojs/endo-but-for-bots (rc=1; see prerequisite stderr above)" but the captured PREREQ_ERR (line 78-90) was completely empty — no line preceded the FATAL in the self-heal capture blob 24818db046b65aec4bee068285a29102d719ce59. Every intentional failure path inside ensure_clone/sync_clone/journal_fetch/clone_lock (common.sh) calls die()/log(), which always writes to stderr, so an empty PREREQ_ERR with prereq_rc=1 means some other command inside the `( ensure_clone "$DIR"; sync_clone "$DIR" )` subshell (receipt-watcher.sh:83) failed under `set -e` without going through any diagnostic path. This is not diagnosable after the fact as written, and it just happened for real.

Likely trigger (not certain, hence no fix to the race itself): GARDEN_RECEIPT_WATCH_CLONE ($GARDEN_STATE/receipt-watcher/journal) is not slug-keyed and is shared by every garden-receipt-watcher@<repo> instance (both endojs-endo-but-for-bots and kriskowal-garden currently exist). The clone's journal.lock was stamped by a different pid (1967229) at 01:05:21Z, ~2 minutes after this failure, consistent with contention from the sibling instance.

Fix (diagnostics only, no behavior change on success): wrap the prerequisite subshell with an ERR trap that records the failing command into PREREQ_ERR, e.g.:

  ( trap 'echo "  [prereq] line $LINENO: $BASH_COMMAND (rc=$?)" >&2' ERR
    ensure_clone "$DIR"; sync_clone "$DIR" ) 2>"$PREREQ_ERR" || prereq_rc=$?

so the next occurrence of this failure signature actually shows which command/line failed instead of an empty capture.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 3
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-22T01:17:27Z
