scripts/jobs/handlers/triager-claude.sh
Line 50, `out="$(claude -p --dangerously-skip-permissions "$prompt")"`, runs under `set -euo pipefail`, so when `claude` exits non-zero the handler aborts inside the command substitution and emits no diagnostic. The result is the opaque failure signature seen on garden-triager@kriscendobot-minion.town: triager.sh reports the generic "triage handler failed … leaving cursor at <none> to retry" with zero detail about WHY claude failed (network/DNS to api.anthropic.com, quota, or a malformed prompt). Harden the handler to capture claude's exit status and stderr and log them before failing: e.g. capture stderr to a temp file, run `if ! out="$(claude -p --dangerously-skip-permissions "$prompt" 2>"$errfile")"; then rc=$?; die "claude -p exited $rc while triaging $slug: $(tail -c 500 "$errfile")"; fi`. This makes recurring triage failures diagnosable and lets a future self-heal responder distinguish a transient API/DNS blip (leave to retry) from a deterministic error (post a fix), without changing the success path or the non-advancing-cursor retry semantics.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 12
  claimed_at: 2026-07-09T23:08:25Z
