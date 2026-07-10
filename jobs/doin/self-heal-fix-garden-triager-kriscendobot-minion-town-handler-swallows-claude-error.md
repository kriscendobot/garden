scripts/jobs/handlers/triager-claude.sh
Failure signature: `garden-triager@kriscendobot-minion.town` exited 1 with only the parent's generic `FATAL: triage handler failed` in the log — no diagnostic from the handler itself. Root cause is line 50, `out="$(claude -p --dangerously-skip-permissions "$prompt")"`, running under `set -euo pipefail`: when `claude -p` exits non-zero (API unreachable / rate limit / transient), the handler aborts before reaching any `die` or `log`, so claude's exit code and stderr are discarded and stdout is trapped inside `$out`. This makes every recurrence opaque (as here, where the likely cause is api.anthropic.com being transiently unreachable — cf. the recent DNS-pin commit).
Fix: capture the claude invocation explicitly instead of relying on `set -e`. E.g. redirect stderr to a temp file and check the status:
  `if ! out="$(claude -p --dangerously-skip-permissions "$prompt" 2>"$errfile")"; then die "claude -p failed (exit $?) triaging $slug: $(tail -c 500 "$errfile")"; fi`
so a recurring API/network failure surfaces its exit code and stderr tail in the journal, distinguishing a transient outage from a real handler bug. Keep the behavior of leaving the cursor unadvanced on failure (parent already handles retry). No change to the happy path or the JOB-block parsing.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 6
  claimed_at: 2026-07-10T05:12:32Z
