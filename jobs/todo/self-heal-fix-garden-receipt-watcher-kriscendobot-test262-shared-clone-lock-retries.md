---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/receipt-watcher.sh shares ONE journal clone (`$GARDEN_STATE/receipt-watcher/journal`, unparameterized by repo slug) across every `garden-receipt-watcher@<slug>` template instance — currently 16 armed repos. Confirmed live: at failure time and after, 14 instances were "activating start" simultaneously (`systemctl --user list-units 'garden-receipt-watcher@*'`), all serializing on the sibling lock `$GARDEN_STATE/receipt-watcher/journal.lock` via `clone_lock` in scripts/jobs/common.sh. A `flock -n` probe against that lock file found it actively held/re-acquired by rotating peer PIDs seconds apart, proving real thundering-herd contention, not a hung holder.

`clone_lock`'s default budget (GARDEN_LOCK_WAIT=60s × GARDEN_LOCK_RETRIES=3, ~180s total + backoff, common.sh:388-399) is sized for "per-service clones with no concurrent users" per its own comment (common.sh:3645) — an assumption this watcher now violates with 16 concurrent per-repo instances. The queued-out loser dies loudly: `FATAL: receipt journal prerequisite failed for <repo> (rc=1; see prerequisite stderr above)` (receipt-watcher.sh:91), which is what fired for kriscendobot-test262 at 00:33:48.

Fix: in scripts/jobs/receipt-watcher.sh, export a higher lock patience (e.g. `GARDEN_LOCK_RETRIES=8` and/or a larger `GARDEN_LOCK_WAIT`) BEFORE `source "$HERE/common.sh"` (line 38), scoped to this script only via env-var override (common.sh's `: "${VAR:=default}"` pattern respects a pre-set export), so a queued instance outlasts its 15 peers' turns instead of dying loudly on ordinary fan-out contention. Do not change the global common.sh defaults — those are shared by every other producer and this contention is specific to receipt-watcher's now-large per-repo fan-out sharing one clone.
