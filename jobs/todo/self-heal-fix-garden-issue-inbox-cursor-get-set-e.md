---
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
scripts/jobs/issue-inbox-watcher.sh:386 calls cursor-get.sh in a bare, unguarded command-substitution pipeline under `set -euo pipefail`. cursor-get.sh's sync_clone can `die` (or exit GARDEN_OFFLINE_RC) on a journal-fetch failure, and since the call isn't wrapped in an `if cmd; then rc=0; else rc=$?; fi` guard, `set -e` propagates that nonzero rc straight into a fatal exit of the whole watcher — the exact hazard just fixed twice today in scripts/jobs/triager.sh (commits 73c2432e89 and b320648e47) for its own cursor-get.sh call sites, but never ported to issue-inbox-watcher.sh. A cursor read is inherently best-effort (a stale/unreadable cursor just re-polls next tick, never loses data), so this should fail open exactly like triager.sh now does: replace the bare assignment at line 386 with the guarded form used in triager.sh — `if cursor_out="$("$HERE/cursor-get.sh" "$CURSOR_KEY")"; then rc=0; else rc=$?; fi; if [ "$rc" -ne 0 ]; then log "WARN: cursor read failed for $CURSOR_KEY (rc=$rc); skipping this tick"; exit 0; fi; last_seen="$(printf '%s\n' "$cursor_out" | sed -n 's/^last_seen:[[:space:]]*//p' | head -1)"`. Add/update the unit test covering this watcher's cursor-read path to exercise a failing cursor-get.sh and assert a clean exit 0 rather than a fatal.

<!-- garden-transient-elapsed: kind=signature through=0 values=12 -->

<!-- garden-reaped: 1 -->
<!-- garden-plain-retry-not-before: 2026-09-18T23:24:08Z -->
