from_host: endolin-garden-ece02cb4
from: reaper:endolin-garden-ece02cb4
sent_at: 2026-09-19T00:44:47Z
doom_base: self-heal-fix-garden-issue-inbox-cursor-get-failopen
doom_signature: requeue-exhausted
notice_count: 1
first_seen: 2026-09-19T00:44:47Z
last_seen: 2026-09-19T00:44:47Z
---
SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
The work is preserved at jobs/plan/self-heal-fix-garden-issue-inbox-cursor-get-failopen; it stays HELD until a human promotes it
(promote-plan.sh self-heal-fix-garden-issue-inbox-cursor-get-failopen) or removes it, so nothing is lost.
Original job base: self-heal-fix-garden-issue-inbox-cursor-get-failopen

--- original job body ---
---
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
In scripts/jobs/issue-inbox-watcher.sh, line 386 reads the cursor with a bare command substitution:
  last_seen="$("$HERE/cursor-get.sh" "$CURSOR_KEY" | sed -n 's/^last_seen:[[:space:]]*//p' | head -1)"
under `set -euo pipefail` (line 85). cursor-get.sh's sync_clone `exit`s nonzero on a journal-connectivity failure, which trips this script's `set -e` and kills the unit with no error text logged — matching the observed failure signature exactly: the last log line is "loaded N maintainer(s) from journal:maintainers/allowlist" (the statement right before line 386) and then exit 1 with nothing after it.

This is the identical bug class fixed twice in scripts/jobs/triager.sh (commits 73c2432e89 and b320648e47): a cursor read is inherently best-effort — a stale/unreadable cursor just re-polls next tick, never loses data — so treat ANY nonzero rc from cursor-get.sh as fail-open. Apply the same pattern here: capture the rc with `if cursor_out=$("$HERE/cursor-get.sh" "$CURSOR_KEY"); then rc=0; else rc=$?; fi`, and on nonzero rc, `log "WARN: journal unreachable reading cursor $CURSOR_KEY (rc=$rc); skipping this tick"` then `exit 0` instead of falling through to `die`/set -e. Then parse `last_seen` from `$cursor_out` instead of the pipeline.
