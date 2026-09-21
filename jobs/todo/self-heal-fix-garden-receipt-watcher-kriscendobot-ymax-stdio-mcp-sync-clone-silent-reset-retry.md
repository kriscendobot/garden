---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
In scripts/jobs/common.sh's sync_clone(), the fallback retry `git -C "$dir" reset -q --hard "origin/$JOURNAL_BRANCH"` (around line 6023, the unguarded second call inside the `if ! git ... reset ...; then` block starting ~line 6013) is a bare command under `set -e`. Its failure propagates as a raw, silent `set -e` exit with no die()/log() call, contradicting the adjacent comment ("the retry below dies"). This produces exactly the symptom seen in garden-receipt-watcher@kriscendobot-ymax-stdio-mcp: repeated `FATAL: receipt journal prerequisite failed ... rc=1; see prerequisite stderr above` with truly empty prerequisite stderr (observed 3x: 2026-09-21 21:57:16, 22:05:26, 23:26:51). Fix: wrap that final reset with `|| die "hard reset of $dir to origin/$JOURNAL_BRANCH failed after retry"` (mirroring the `die "fetch failed in $dir after bounded retries"` pattern used elsewhere in the same function) so any future failure there actually logs a diagnosable message instead of silently killing the subshell.
