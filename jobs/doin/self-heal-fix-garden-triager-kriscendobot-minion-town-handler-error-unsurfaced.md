scripts/jobs/handlers/triager-claude.sh
The default triage handler swallows the reason for its own failures. At line 50, `out="$(claude -p --dangerously-skip-permissions "$prompt")"` runs under `set -euo pipefail`, so a non-zero `claude` exit aborts the handler while its stdout (where `claude -p` writes API/transport error text) is captured into `$out` and discarded, and stderr in the observed failure was empty. The result: triager.sh's `die "triage handler failed for $slug…"` (triager.sh:62) is the ONLY thing in the journal — the actual cause (quota, auth, api.anthropic.com DNS/network blip, or a post-job.sh error) is invisible, making self-heal diagnosis impossible and every distinct failure look identical.

Fix: capture `claude`'s exit status and output explicitly instead of letting `set -e` abort silently. Something like:

  if ! out="$(claude -p --dangerously-skip-permissions "$prompt" 2>&1)"; then
    log "claude -p failed (exit $?) for $slug; tail follows:"
    printf '%s\n' "$out" | tail -n 20 | while IFS= read -r l; do log "  claude: $l"; done
    die "triage via claude failed for $slug"
  fi

Preserve current behavior otherwise: still return non-zero so triager.sh leaves the cursor unadvanced and the change re-triages on the next timer tick (this is the desired retry path for a transient API/network failure). The goal is purely to surface the failure reason so a recurring failure can be told apart from a one-off blip — do not add retries or swallow the error. Keep it a scoped edit to this one handler; triager.sh's cursor/retry logic is already correct.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 7
  claimed_at: 2026-07-10T02:11:19Z
