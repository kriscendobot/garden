scripts/jobs/handlers/triager-claude.sh
The triage handler runs `out="$(claude -p --dangerously-skip-permissions "$prompt")"` at line 50 under `set -euo pipefail`. When `claude` exits nonzero (API/quota outage, or DNS failure resolving api.anthropic.com), the handler aborts via `set -e` with NO log line and NO captured stderr — the only visible symptom is `triager.sh`'s generic `FATAL: triage handler failed` (triager.sh:62). Observed on `garden-triager@kriscendobot-minion.town`: the whole failure blob was two `triager/`-tagged lines with zero `triage-claude` output, making the root cause undiagnosable.

Harden line 50 to capture and report the failure before returning nonzero. Concretely: run `claude` with stderr captured to a temp file and check its exit status explicitly instead of relying on bare `set -e`, e.g.

    err="$(mktemp)"
    if ! out="$(claude -p --dangerously-skip-permissions "$prompt" 2>"$err")"; then
      rc=$?
      log "claude -p failed (exit $rc) triaging $slug; stderr: $(head -c 500 "$err")"
      rm -f "$err"
      exit "$rc"
    fi
    rm -f "$err"

so a recurring `claude -p` failure emits a distinct signature (exit code + stderr head) that a future self-heal/mentor tick can classify as environmental-vs-code rather than a blank FATAL. Keep the non-zero exit so triager.sh still leaves the cursor to retry. Do not change the retry/cursor semantics — only add the diagnostic.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 10
  claimed_at: 2026-07-10T00:09:56Z
