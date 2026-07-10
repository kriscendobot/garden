In `scripts/jobs/handlers/triager-claude.sh`, the `changes=` command substitution (currently line 27) fails on the first triage of any repo, wedging `garden-triager@<slug>` into a ~2-minute self-heal restart loop with no diagnostic output.

Failure signature: triager logs `change on <slug>:<ref>: <none> → <sha>; triaging` then `FATAL: triage handler failed ... leaving cursor at <none> to retry`, with no claude/handler stderr captured. Reproduced: with empty `old`, `git --git-dir="$bare" log --no-merges --stat "${old:+$old..$new}"` runs `git log ""` → `fatal: ambiguous argument ''` (exit 128); `2>/dev/null` swallows the message and the handler's `set -euo pipefail` aborts silently.

Fix:
1. Change the revision expression from `"${old:+$old..$new}"` to `"${old:+$old..}$new"` so an empty `old` logs from `$new` alone — identical to the correct `range="${old:+$old..}$new"` construction on the preceding line. This is the deterministic cause of the loop.
2. Harden the `| head -400` pipe: when the range exceeds 400 log lines, `head` closes early and git dies of SIGPIPE, making the pipeline exit 141 under `pipefail` and again aborting the handler via `set -e`. Guard it (e.g. capture with pipefail relaxed for this line: `changes="$( { git ... || true; } | head -400 )"`, or drop `set -o pipefail` locally, or read then truncate) so a large first-triage diff cannot re-trigger the same silent abort.
3. Optional but recommended: on handler failure, surface why. The triager's `die "triage handler failed"` gives no cause; consider having the handler not suppress git's stderr for this diagnostic step, or log a bounded reason, so a future recurrence lands a real signature in the self-heal blob instead of an empty one.

Add/adjust a test alongside the existing handler tests covering the empty-`old` (first-triage) path so this regression is caught: assert the handler succeeds and produces a non-empty change summary when `old` is empty.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 7
  claimed_at: 2026-07-10T03:12:08Z
