from_host: endolin-garden-ece02cb4
from: reaper:endolin-garden-ece02cb4
sent_at: 2026-09-18T23:35:09Z
doom_base: self-heal-fix-garden-issue-inbox-cursor-get-set-e
doom_signature: requeue-exhausted
notice_count: 1
first_seen: 2026-09-18T23:35:09Z
last_seen: 2026-09-18T23:35:09Z
---
SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
The work is preserved at jobs/plan/self-heal-fix-garden-issue-inbox-cursor-get-set-e; it stays HELD until a human promotes it
(promote-plan.sh self-heal-fix-garden-issue-inbox-cursor-get-set-e) or removes it, so nothing is lost.
Original job base: self-heal-fix-garden-issue-inbox-cursor-get-set-e

--- original job body ---
---
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
scripts/jobs/issue-inbox-watcher.sh:386 calls cursor-get.sh in a bare, unguarded command-substitution pipeline under `set -euo pipefail`. cursor-get.sh's sync_clone can `die` (or exit GARDEN_OFFLINE_RC) on a journal-fetch failure, and since the call isn't wrapped in an `if cmd; then rc=0; else rc=$?; fi` guard, `set -e` propagates that nonzero rc straight into a fatal exit of the whole watcher — the exact hazard just fixed twice today in scripts/jobs/triager.sh (commits 73c2432e89 and b320648e47) for its own cursor-get.sh call sites, but never ported to issue-inbox-watcher.sh. A cursor read is inherently best-effort (a stale/unreadable cursor just re-polls next tick, never loses data), so this should fail open exactly like triager.sh now does: replace the bare assignment at line 386 with the guarded form used in triager.sh — `if cursor_out="$("$HERE/cursor-get.sh" "$CURSOR_KEY")"; then rc=0; else rc=$?; fi; if [ "$rc" -ne 0 ]; then log "WARN: cursor read failed for $CURSOR_KEY (rc=$rc); skipping this tick"; exit 0; fi; last_seen="$(printf '%s\n' "$cursor_out" | sed -n 's/^last_seen:[[:space:]]*//p' | head -1)"`. Add/update the unit test covering this watcher's cursor-read path to exercise a failing cursor-get.sh and assert a clean exit 0 rather than a fatal.
