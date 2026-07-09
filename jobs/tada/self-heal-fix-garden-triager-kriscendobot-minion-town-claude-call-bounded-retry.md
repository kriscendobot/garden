Pushed cleanly to main2.

## Completion report

**Job:** Harden the triage handler's `claude -p` call against transient failures.

**What I found:** `scripts/jobs/handlers/triager-claude.sh` had already gained stderr/exit-code capture (from the prior commit `03f33d7f1`), but still had **no retry** — a single transient non-zero exit from `claude -p` under `set -euo pipefail` would `die` the whole tick, marking `garden-triager@<repo>` Failed and burning a self-heal responder, even though `triager.sh` leaves the cursor unadvanced and re-triages on the next ~2-minute timer tick.

**What I changed:** Wrapped the single triage invocation (line 69) in a bounded retry:
- 3 attempts with a fixed 3s / 9s backoff between them.
- Each transient failure is `log`ged (attempt N/3, delay, stderr tail) so retries are visible.
- Only after all attempts are exhausted does it `die`, still emitting `claude`'s stderr (`tail -c 500 "$errfile"`) into the failure path — preserving the real self-heal signature the prior commit added.
- The exit-code capture note (rc must be read in the `else` branch, not after a `!`-negated pipeline) is retained.
- Parse/post logic below is untouched; this only hardens acquisition of `$out`.

**Sibling handlers:** `triager-claude.sh` is the sole triage handler (the default `GARDEN_TRIAGE_HANDLER` in `triager.sh:37`). The other `claude -p` callers (mentor, watchman, follow-up, foreman, proxy, self-heal, banner-sweep, portability-coupling) are distinct roles with their own error handling, not triage handlers — out of scope per the "sibling triage handler" clause, so no mirror needed.

**Verification:** `bash -n` passes; retry loop logic reviewed. Committed and pushed to `main2` (`a8b87df68`).

**Follow-ups:** None. (Note: a general `claude_call_retry` helper in `common.sh` could de-duplicate this pattern across the several `claude -p` fleet callers, but that's a larger refactor outside this job's scope.)
