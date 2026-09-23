from_host: endolin-garden-ece02cb4
from: reaper:endolin-garden-ece02cb4
sent_at: 2026-09-19T00:04:43Z
doom_base: self-heal-fix-garden-issue-inbox-cursor-read-fail-open
doom_signature: requeue-exhausted
notice_count: 1
first_seen: 2026-09-19T00:04:43Z
last_seen: 2026-09-19T00:04:43Z
---
SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
The work is preserved at jobs/plan/self-heal-fix-garden-issue-inbox-cursor-read-fail-open; it stays HELD until a human promotes it
(promote-plan.sh self-heal-fix-garden-issue-inbox-cursor-read-fail-open) or removes it, so nothing is lost.
Original job base: self-heal-fix-garden-issue-inbox-cursor-read-fail-open

--- original job body ---
---
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
`scripts/jobs/issue-inbox-watcher.sh:386` reads the poll cursor with a bare command substitution under `set -euo pipefail`:
`last_seen="$("$HERE/cursor-get.sh" "$CURSOR_KEY" | sed -n 's/^last_seen:[[:space:]]*//p' | head -1)"`.
`cursor-get.sh`'s `sync_clone` can `exit` non-zero on a journal fetch failure (offline `GARDEN_OFFLINE_RC`, or a plain `rc=1` when the failure's stderr misses the offline-signature heuristic — confirmed happening 2026-09-18 per `b320648e47`), and `pipefail` propagates that through the pipe, tripping `set -e` and hard-killing the unit with zero diagnostic output. This matches this incident's captured log exactly: the tick logs `loaded 8 maintainer(s) from journal:maintainers/allowlist` and then dies with exit 1, nothing else — no error line reaches stdout/stderr because the death happens inside the command-substitution pipe itself.

This exact bug class was found and fixed **twice** today in `triager.sh` (`73c2432e89`, then `b320648e47` when the first, narrower fix proved incomplete): capture the rc explicitly (`if out=$(cmd); then rc=0; else rc=$?; fi`) and fail open — WARN + `exit 0` — on ANY nonzero rc, since a cursor read is inherently best-effort (a stale/unreadable cursor just re-polls next tick, never loses data). Apply the same `if …; then rc=0; else rc=$?; fi` / WARN-and-exit-0 pattern to `issue-inbox-watcher.sh:386`.

While in there, apply the identical fix to the two sibling watchers with the same unguarded pattern (same bug, not yet triggered but latent): `scripts/jobs/comment-watcher.sh:423` and `scripts/jobs/mention-watcher.sh:83`.
