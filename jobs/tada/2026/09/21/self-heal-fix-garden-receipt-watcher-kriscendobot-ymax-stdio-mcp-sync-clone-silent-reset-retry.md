Fixed and pushed to `main2` (commit `85ae2f878c`).

## Completion report

**What the job asked:** In `scripts/jobs/common.sh`'s `sync_clone()`, the fallback retry `git -C "$dir" reset -q --hard "origin/$JOURNAL_BRANCH"` was a bare command under `set -e`. On failure it propagated as a raw, silent `set -e` exit with no `die()`/`log()` — contradicting the adjacent comment ("the retry below dies") and producing the observed `FATAL: receipt journal prerequisite failed … rc=1` with *empty* prerequisite stderr in garden-receipt-watcher@kriscendobot-ymax-stdio-mcp.

**What I did:**
- Located the offending line at `common.sh:6381` (the unguarded second reset inside the `if ! git … reset …; then` block starting ~6371).
- Wrapped it with `|| die "hard reset of $dir to origin/$JOURNAL_BRANCH failed after retry"`, mirroring the `die "fetch failed in $dir after bounded retries"` pattern in the same function. `die()` (line 492) runs `log "FATAL: $*"; exit 1`, so any future failure there now emits a diagnosable message instead of silently killing the subshell — the comment's promise is now honored.
- Verified `bash -n` passes and `die()` is defined in the file.

**What changed:** one file, `scripts/jobs/common.sh` (one 2-line guarded retry).

**Follow-ups:** none. This is a self-healing diagnostic fix; it doesn't change the success path, only ensures the previously-silent failure now logs. The next occurrence in the receipt-watcher (if the underlying reset genuinely fails) will now surface a concrete FATAL line instead of empty stderr.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/self-heal-fix-garden-receipt-watcher-kriscendobot-ymax-stdio-mcp-sync-clone-silent-reset-retry.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 14 tokens (264119 cached reads)
- Output: 2289 tokens
- Cost: $0.8680315000000001
- Wall-clock: 39s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
