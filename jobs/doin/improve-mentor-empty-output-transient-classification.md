scripts/jobs/mentor.sh
The improve-handler branch (lines 99–111) classifies a failure as transient only when the captured output matches `is_transient_claude_signature` or `_fetch_stderr_is_offline`. An empty-output non-zero exit — a `claude -p` handler SIGKILLed/OOM-killed (rc=137/143) or cut mid-call by a quota/network blip — produces an EMPTY `$out` that matches neither, so it falls through to `die` (exit 1). That marks garden-mentor.service Failed and fires self-heal-run.sh into a diagnosis that fails identically in the same outage. This is the observed 30-minute FATAL loop on endolinbot (2026-07-05 18:20/18:50/19:20, journalctl shows the bare "FATAL: improve handler failed" with no preceding `$out` diagnostic → the output was empty). Fix: capture the handler's exit code immediately (`"$GARDEN_MENTOR_HANDLER" ... >"$capture" 2>&1; rc=$?` instead of the bare `if` — `$?` is clobbered by the later `out="$(...)"`), and add an empty-capture-transient branch mirroring gardener.sh:659–667: when the capture is empty (`[ ! -s "$capture" ]`) and `is_transient_empty_failure "$rc"` is true, WARN + `exit 0` (leave $SEEN/$JSINCE unadvanced, retry next tick) rather than die. Reserve the die→self-heal path for a non-empty, non-transient real defect. This reuses the existing common.sh helper the gardener already relies on, so the two handlers' transient-vs-real classification stay aligned.

---
claim:
  host: endolinbot
  gardener: 31
  claimed_at: 2026-07-05T19:52:51Z
