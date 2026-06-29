Done. Inbox empty.

## Completion report

**Job:** `improve-gardener-log-handler-elapsed-on-external-kill`

**What I did:** In `scripts/jobs/gardener.sh`, added handler elapsed wall-time to the transient signal-kill (rc=143/137, and the other transient-classified rcs) progress note so a near-constant elapsed across requeue cycles becomes a positive signal of a deterministic overrun rather than a benign random restart.

**What changed (one file, `scripts/jobs/gardener.sh`):**
1. Captured `handler_start=$SECONDS` immediately before the `timeout … "$GARDEN_JOB_HANDLER"` call at the single call site (with a comment explaining the constant-vs-varied elapsed distinction).
2. In the failure branch, computed `elapsed=$((SECONDS - handler_start))` right after capturing `rc=$?`.
3. Folded `elapsed=<n>s` into both the `log` line and the kind:progress journal note emitted at the transient branch, alongside the existing `requeue cycle` count.

**Verification:** `bash -n` passes. The change is read-only of the shell's `SECONDS` monotonic counter — no new board state, no CAS, no behavioral change to classification or escalation (the note text gains a field). Committed and pushed to `main2` (`9052fab36..065d477c7`) via a rebase CAS loop.

**Follow-ups:** None required. The job note already anticipated the natural next consumer — a watchman self-test that compares elapsed across cycles to flag a genuinely-stuck job before the ~5-cycle poison threshold — but that is a separate, larger change and was explicitly out of scope here (this job only adds the signal to the journal; nothing yet consumes it programmatically).
