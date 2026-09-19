---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Apply the same rc-capture-and-fail-open pattern that df83fca235 just landed for cursor-get.sh reads to the cursor-set.sh WRITE at the tail of each watcher's tick — the symmetric gap that fix left open. Failure signature: garden-comment-watcher@endojs-endo-but-for-bots ran a clean tick (posted two directives on #1305 at 06:02:33/06:03:59), then went silent for ~4 minutes and exited rc=1 with zero WARN/FATAL log output anywhere (verified against journalctl, not just the capture). The preceding tick (05:58:38) already hit `WARN: cursor read failed ... (rc=1)`, proving this host has live journal-clone flakiness right now.

Affected call sites, all identical bare pipes under `set -euo pipefail`:
- scripts/jobs/comment-watcher.sh:2097-2098
- scripts/jobs/mention-watcher.sh:491-492
- scripts/jobs/issue-inbox-watcher.sh:676-677

Each does `printf 'last_seen: ...\n' | "$HERE/cursor-set.sh" "$CURSOR_KEY"`. cursor-set.sh's internal retry loop (up to 50 attempts via commit_and_push/backoff) logs nothing per failed attempt — only on final success or the terminal `die` — so sustained push contention or a connectivity blip produces minutes of silence followed by a bare nonzero exit, which under the caller's `set -e`/`pipefail` kills the whole tick with no diagnostic trail (exactly the shape captured here).

Fix: capture the rc via `if printf ... | "$HERE/cursor-set.sh" "$CURSOR_KEY"; then rc=0; else rc=$?; fi` and on nonzero rc `log "WARN: cursor advance failed for $CURSOR_KEY (rc=$rc); will re-advance next tick"` then fall through past the `if [ -n "$hw" ] ...` block cleanly (exit 0) — mirroring the cursor-get.sh fix's rationale: a lost cursor advance is best-effort (posts are idempotent by base, so the next tick just re-detects and DEDUPs rather than losing data), never worth a hard crash. Do this in all three watchers for consistency with df83fca235's scope.

<!-- garden-transient-elapsed: kind=signature through=0 values=4 -->
---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-09-19T06:11:54Z
