from_host: endolin-garden-ece02cb4
from: reaper:endolin-garden-ece02cb4
sent_at: 2026-09-18T21:53:44Z
doom_base: self-heal-fix-garden-comment-watcher-endojs-endo-but-for-bots-silent-exit1-no-err-trap
doom_signature: requeue-exhausted
notice_count: 1
first_seen: 2026-09-18T21:53:44Z
last_seen: 2026-09-18T21:53:44Z
---
SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
The work is preserved at jobs/plan/self-heal-fix-garden-comment-watcher-endojs-endo-but-for-bots-silent-exit1-no-err-trap; it stays HELD until a human promotes it
(promote-plan.sh self-heal-fix-garden-comment-watcher-endojs-endo-but-for-bots-silent-exit1-no-err-trap) or removes it, so nothing is lost.
Original job base: self-heal-fix-garden-comment-watcher-endojs-endo-but-for-bots-silent-exit1-no-err-trap

--- original job body ---
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
