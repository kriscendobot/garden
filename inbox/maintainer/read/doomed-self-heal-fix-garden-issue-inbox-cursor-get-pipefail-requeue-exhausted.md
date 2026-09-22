from_host: endolin-garden-ece02cb4
from: reaper:endolin-garden-ece02cb4
sent_at: 2026-09-18T22:33:25Z
doom_base: self-heal-fix-garden-issue-inbox-cursor-get-pipefail
doom_signature: requeue-exhausted
notice_count: 1
first_seen: 2026-09-18T22:33:25Z
last_seen: 2026-09-18T22:33:25Z
---
SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
The work is preserved at jobs/plan/self-heal-fix-garden-issue-inbox-cursor-get-pipefail; it stays HELD until a human promotes it
(promote-plan.sh self-heal-fix-garden-issue-inbox-cursor-get-pipefail) or removes it, so nothing is lost.
Original job base: self-heal-fix-garden-issue-inbox-cursor-get-pipefail

--- original job body ---
---
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
issue-inbox-watcher.sh:386 calls `cursor-get.sh` in a bare pipeline (`"$HERE/cursor-get.sh" "$CURSOR_KEY" | sed -n 's/^last_seen:[[:space:]]*//p' | head -1`) under `set -euo pipefail`. cursor-get.sh's sync_clone can `die` with rc=1 (unrecognized fetch-failure stderr) or `exit $GARDEN_OFFLINE_RC` (75, recognized offline signature) on a journal fetch hiccup; pipefail propagates either nonzero rc through the sed/head stages, tripping set -e and hard-killing the whole garden-issue-inbox unit instead of skipping the tick. This is the exact bug class fixed today in triager.sh (commits 73c2432e89, b320648e47): capture the rc via `if cursor_out=$("$HERE/cursor-get.sh" "$CURSOR_KEY"); then rc=0; else rc=$?; fi`, and on any nonzero rc, `log "WARN: cursor read failed for $CURSOR_KEY (rc=$rc); skipping this tick"; exit 0` instead of letting set -e kill the process — a cursor read is best-effort (a missed read just re-triages/re-polls next tick, never loses data). Apply the identical fix to the same unguarded pattern in comment-watcher.sh:423 and mention-watcher.sh:83, which share this exact vulnerable shape and will hit the same failure the next time the journal blips.
