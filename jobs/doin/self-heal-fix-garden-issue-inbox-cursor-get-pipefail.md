---
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
issue-inbox-watcher.sh:386 calls `cursor-get.sh` in a bare pipeline (`"$HERE/cursor-get.sh" "$CURSOR_KEY" | sed -n 's/^last_seen:[[:space:]]*//p' | head -1`) under `set -euo pipefail`. cursor-get.sh's sync_clone can `die` with rc=1 (unrecognized fetch-failure stderr) or `exit $GARDEN_OFFLINE_RC` (75, recognized offline signature) on a journal fetch hiccup; pipefail propagates either nonzero rc through the sed/head stages, tripping set -e and hard-killing the whole garden-issue-inbox unit instead of skipping the tick. This is the exact bug class fixed today in triager.sh (commits 73c2432e89, b320648e47): capture the rc via `if cursor_out=$("$HERE/cursor-get.sh" "$CURSOR_KEY"); then rc=0; else rc=$?; fi`, and on any nonzero rc, `log "WARN: cursor read failed for $CURSOR_KEY (rc=$rc); skipping this tick"; exit 0` instead of letting set -e kill the process — a cursor read is best-effort (a missed read just re-triages/re-polls next tick, never loses data). Apply the identical fix to the same unguarded pattern in comment-watcher.sh:423 and mention-watcher.sh:83, which share this exact vulnerable shape and will hit the same failure the next time the journal blips.

<!-- garden-transient-elapsed: kind=signature through=0 values=3 -->

<!-- garden-reaped: 1 -->
<!-- garden-plain-retry-not-before: 2026-09-18T22:23:04Z -->

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-09-18T22:23:37Z
