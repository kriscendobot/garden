---
gate: deferred
priority: normal
tier: minion
token-budget: 100000
doomed: true
doom_signature: requeue-exhausted
doom_count: 1
split_eligible: true
split_reason: repeated-plain-exit
failure_classification: transient
requeue_cycles: 2
deadline_overruns: 0
elapsed_constancy_confirmations: 0
doomed_at: 2026-09-18T21:53:07Z
doomed_on: endolin-garden-ece02cb4
posted_by: reaper:endolin-garden-ece02cb4
posted_at: 2026-09-18T21:53:07Z
---

---
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
scripts/jobs/comment-watcher.sh (set -euo pipefail) died with rc=1 mid-tick on 2026-09-18 21:18Z, right after logging "posted endojs-endo-but-for-bots-pr1306-review-2a0fedcf (review on #1306) + acked" (line ~2020), never reaching either terminal cursor-advance log line at EOF (~lines 2082-2088: "advanced comment cursor ..." / "cursor unchanged ..."). No FATAL/WARN/error text appears anywhere in the captured stdout+stderr — the failing command produced zero diagnostic output, so the root cause is unrecoverable from the capture.

Add a diagnostic ERR trap next to the existing `trap 'cleanup' EXIT` / TERM / INT traps (~line 1476) so any future set -e abort in this script logs what failed before exiting, e.g.:

  trap 'log "FATAL: rc=$? at line $LINENO: $BASH_COMMAND"' ERR

Place it so it fires before cleanup's EXIT trap runs (both fire; ERR first, then EXIT), and confirm with bash -n plus a synthetic forced-failure smoke test (temporarily insert a `false` after the mint_retro call, run under bash -x, confirm the FATAL log line appears with the right line/command and rc is preserved through cleanup). Diagnostic-only — must not change happy-path behavior or the retry/CAS semantics of any other function in the script.
