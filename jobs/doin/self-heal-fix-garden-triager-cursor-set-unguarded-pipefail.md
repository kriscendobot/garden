---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
In scripts/jobs/triager.sh around line 537-538, the post-success cursor advance
(`printf ... | "$HERE/cursor-set.sh" "$CURSOR_KEY"`) is a bare piped command under
`set -euo pipefail` with no rc guard, unlike every other cursor-set.sh call site in
the codebase. When cursor-set.sh returns nonzero (journal push contention or an
outage `exit 75`), the whole tick dies silently — no "triaged $slug:$ref up to
$new_sha" log line, no diagnostic, unit marked Failed — even though the triage
handler already succeeded and posted its job. Observed on
garden-triager@kriscendobot-minion.town (exit 1, log tail ends right after
"posted 1 job(s)..." with no follow-up). Fix: capture the rc the same way
comment-watcher.sh (~line 2183), issue-inbox-watcher.sh (~line 690), and
mention-watcher.sh (~line 506) already do — `if printf ... | cursor-set.sh
"$CURSOR_KEY"; then rc=0; else rc=$?; fi` — and on nonzero rc, `log "WARN: cursor
advance failed for $CURSOR_KEY (rc=$rc); will re-advance next tick"; exit 0`
instead of letting set -e crash the unit. A stalled cursor is safe to leave behind:
the next tick re-triages the same old→new range, and post-job.sh's deterministic
basename makes the re-post idempotent.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-22T03:45:04Z
