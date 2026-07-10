In `scripts/jobs/handlers/triager-claude.sh` line 50, the call `out="$(claude -p --dangerously-skip-permissions "$prompt")"` runs under `set -euo pipefail`, so when `claude` exits non-zero the whole handler aborts via `set -e` with NO diagnostic — command substitution swallows claude's stderr and no log line is emitted. The result is the opaque failure seen on garden-triager@kriscendobot-minion.town: triager.sh reports only the generic "triage handler failed" with an empty captured log, making a transient API blip indistinguishable from a real auth/prompt error.

Fix: capture claude's exit status and stderr explicitly and surface the reason before dying, instead of letting `set -e` kill the handler silently. E.g. redirect stderr to a temp file (or `2>&1` into a var), check `$?`, and on failure `die "claude -p failed for $slug (exit N): <first lines of stderr>"`. Keep the success path (parse JOB..ENDJOB blocks) unchanged. This does not change triage behavior — the cursor still stays put and re-triages — it only makes the next occurrence diagnosable so an operator can tell an API/quota outage apart from a persistent fault.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 17
  claimed_at: 2026-07-10T03:42:16Z
