---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
`issue-inbox-watcher.sh` failed with exit code 1 and no error message logged: the last output before the crash was the 06:04:55 "dropped (not triaged)" line, then ~3 minutes of silence before self-heal observed rc=1 — consistent with `cursor-set.sh` exhausting its 50-attempt journal-push CAS retry loop (`scripts/jobs/cursor-set.sh`) under push contention and either dying past the capture window or the pipeline's nonzero exit tripping `set -euo pipefail` before any WARN could log.

Fix: guard the `cursor-set.sh` invocation at the cursor-advance step in `scripts/jobs/issue-inbox-watcher.sh` (~line 675-677), `scripts/jobs/comment-watcher.sh` (~line 2097-2098), and `scripts/jobs/mention-watcher.sh` (~line 492-493) the same way `issue-inbox-watcher.sh` line 394 already guards `cursor-get.sh`: capture the exit code via `if ... ; then rc=0; else rc=$?; fi` instead of a bare piped command, and on nonzero rc log `WARN: cursor advance failed for $CURSOR_KEY (rc=$rc); will re-advance next tick` then `exit 0` (or fall through) rather than letting `set -e`/`pipefail` crash the whole tick. This mirrors the fail-open fix just landed for the read side in commit df83fca235 (which also touched all three watchers), and is safe because these watchers are already designed so a stalled cursor never loses data — a subsequent tick re-derives and re-advances it, since dispatch is idempotent by spine (issues) or GitHub comment id (comments/mentions).

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-19T06:12:19Z
