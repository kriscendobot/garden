In `scripts/jobs/handlers/triager-claude.sh`, the `claude -p` invocation on line 50 (`out="$(claude -p --dangerously-skip-permissions "$prompt")"`) runs under `set -euo pipefail`, so any non-zero exit from `claude` aborts the handler *silently*: claude's error text is written to stdout, captured into `$out`, and discarded on the `set -e` abort. Observed failure signature (garden-triager@kriscendobot-minion.town, exit 1): the log shows only the `triager/…` "triaging" line and its FATAL "triage handler failed" — with NO `[triage-claude]` line at all, proving the handler died at the claude call before any of its own logging, making the root cause (DNS/API-connectivity to api.anthropic.com, quota, rate-limit, or oversized first-triage prompt) undiagnosable.

Fix: capture claude's exit status and output explicitly and surface it before dying, e.g. replace line 50 with something like:
```sh
if ! out="$(claude -p --dangerously-skip-permissions "$prompt" 2>&1)"; then
  rc=$?
  die "claude -p failed (exit $rc) for $slug; first 2KB of output: ${out:0:2048}"
fi
```
This turns the silent `set -e` abort into a tagged `[triage-claude] FATAL: …` line that names the real reason, so the next occurrence is diagnosable and a transient API/DNS blip is distinguishable from a deterministic (e.g. prompt-too-large) failure. Keep the retry-on-failure semantics (cursor still not advanced) — this change is diagnostic surfacing only, not a behavior change to the retry loop. Note the recent DNS-pinning commit dbd6b324a may already have resolved the underlying api.anthropic.com connectivity on the minion.town host; this fix ensures the *next* such failure leaves a readable signature instead of two opaque lines.
