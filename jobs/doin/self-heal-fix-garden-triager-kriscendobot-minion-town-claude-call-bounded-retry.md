In `scripts/jobs/handlers/triager-claude.sh`, the single triage invocation at line 50 — `out="$(claude -p --dangerously-skip-permissions "$prompt")"` — runs under `set -euo pipefail` with no retry and does not capture claude's stderr. A transient non-zero exit from `claude -p` (API blip, rate-limit, momentary kill) therefore hard-fails the handler with zero diagnostic, marking `garden-triager@kriscendobot-minion.town` Failed and burning a self-heal responder, even though `triager.sh`'s unadvanced-cursor design already re-triages on the next ~2-minute timer tick (confirmed: re-running the identical prompt for commit 35e9b4a5 now succeeds and emits zero jobs).

Failure signature: capture blob contains only triager.sh's two lines ("change on kriscendobot-minion.town:main … triaging" then "FATAL: triage handler failed … leaving cursor at <none> to retry"), with no claude output — the tell of a silent `set -e` death at the `claude` command substitution.

Fix: wrap the claude call in a bounded retry (~3 attempts with a short backoff, e.g. 3s/9s) and capture its stderr to a temp file, so (a) a transient blip self-recovers within the same tick instead of failing the unit, and (b) a genuinely persistent failure only `die`s after retries are exhausted and emits claude's stderr into the failure path, giving future self-heal diagnoses a real signature instead of a blank 2-line capture. Keep the existing parse/post logic unchanged; this only hardens the acquisition of `$out`. Mirror the change into any sibling triage handler that shells out to `claude -p` the same way if one exists.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 3
  claimed_at: 2026-07-09T23:40:16Z
