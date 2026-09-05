---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
`scripts/jobs/transcript-capture.sh` aborts a whole capture tick (exit 1) when a live session `.jsonl` is deleted between the `find` enumeration and the `stage` stdin redirect. Failure signature: `transcript-capture.sh: line 273: <…>/.claude/projects/<enc>/<sid>.jsonl: No such file or directory`, service `garden-transcript-capture` exit 1. Root cause is a benign, expected race with `scripts/jobs/handlers/monk-claude.sh:355`, which spools then `rm -f`s the session transcript at job completion; under `set -euo pipefail` the failed redirection kills the script before the commit/CAS push, discarding every session staged in that tick.

Fix in the § 4b live sweep of `scripts/jobs/transcript-capture.sh` (around lines 255–277), matching the tolerance the § 4a spool drain already has at lines 228–232:
- Make the vanished-file case non-fatal: `stage … < "$redact_in" || { log "WARN: live sweep: $jsonl vanished mid-tick (job completion race); skipping"; continue; }`. The `continue` is required, not optional — if `stage` never ran, `n` was not incremented and the following `ST_LEDGERKEY[$((n-1))]` / `ST_LEDGERVAL[$((n-1))]` writes would clobber the *previous* entry's ledger key with this session's, corrupting the ledger for an unrelated session.
- Tighten the fail-open gates so a deleted file is skipped early rather than riding through: have the `stat -c %Y` / `stat -c %s` calls `continue` on failure instead of defaulting to `0` (an mtime of `0` currently guarantees the idle gate passes).
- Keep the tick's exit status 0 for this case; it is expected steady-state behavior on a host running gardeners, and the session was already captured by `transcript_spool` on the monk-claude side, so nothing is lost.

Add a regression scenario to `scripts/jobs/test/transcript-capture-test.sh` (it already has `mk_session`/`spool_hook`/`run_capture` and an rm-after-spool case at line 152): create two live idle sessions, delete one after arming but in a way that reaches the sweep, and assert the capture still exits 0, archives the surviving session, and writes an index row for it only.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 2
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-09-05T03:24:03Z
