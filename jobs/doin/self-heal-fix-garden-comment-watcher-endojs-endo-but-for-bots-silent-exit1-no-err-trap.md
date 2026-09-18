---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/comment-watcher.sh (set -euo pipefail) died with rc=1 mid-tick on 2026-09-18 21:18Z, right after logging "posted endojs-endo-but-for-bots-pr1306-review-2a0fedcf (review on #1306) + acked" (line ~2020), never reaching either terminal cursor-advance log line at EOF (~lines 2082-2088: "advanced comment cursor ..." / "cursor unchanged ..."). No FATAL/WARN/error text appears anywhere in the captured stdout+stderr — the failing command produced zero diagnostic output, so the root cause is unrecoverable from the capture.

Add a diagnostic ERR trap next to the existing `trap 'cleanup' EXIT` / TERM / INT traps (~line 1476) so any future set -e abort in this script logs what failed before exiting, e.g.:

  trap 'log "FATAL: rc=$? at line $LINENO: $BASH_COMMAND"' ERR

Place it so it fires before cleanup's EXIT trap runs (both fire; ERR first, then EXIT), and confirm with bash -n plus a synthetic forced-failure smoke test (temporarily insert a `false` after the mint_retro call, run under bash -x, confirm the FATAL log line appears with the right line/command and rc is preserved through cleanup). Diagnostic-only — must not change happy-path behavior or the retry/CAS semantics of any other function in the script.

<!-- garden-transient-elapsed: kind=signature through=0 values=3 -->
---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-09-18T21:27:26Z
