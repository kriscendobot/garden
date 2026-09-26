Inbox empty. Work complete.

---

## Completion report

**Job:** `improve-classify-handler-timeout-rc124-as-external-kill` — stop false-escalating handlers killed by their own wall-clock `timeout` wrapper.

**Problem:** A handler killed by `timeout --signal=TERM "$GARDEN_HANDLER_TIMEOUT"` exits rc=124. The classifier (`gardener.sh`) folded only the signal codes 143/130/137 into the transient branch via `is_external_kill_rc`, so rc=124 fell through to the loud real-failure path and escalated a `kind:error` to the gardener inbox on **every** reaper requeue — false-flagging inherently-long handlers (e.g. `shepherd-kriscendobot-agoric-sdk-pr7` timing out at the 2400s CI-drive window) as defects.

**What I did** (chose the sibling-classifier option to keep `is_external_kill_rc`'s signal-code semantics pure, since 124 is `timeout`'s own non-signal code):
- **`scripts/jobs/common.sh`** — added `is_handler_timeout_rc()` (matches 124), with a thorough comment naming the timeout-wrapper kill as a fourth external-kill source and explaining the disjoint-from-signal-codes rationale + poison-counter escalation path.
- **`scripts/jobs/gardener.sh`** — added an `elif is_handler_timeout_rc "$rc"; then transient=1` branch immediately after the signal-kill branch (so it precedes the empty/non-empty capture split, making capture content irrelevant); rewrote the deliberate-route comment at the single timeout call site; updated the transient verdict log + journal-note text to read `signal-kill/timeout/empty/transient-signature`. Result: ONE `kind:progress` note, no inbox `kind:error`, left in `doin`; the existing reap-now hint + reaper poison counter still surface a genuine deadlock after the threshold.
- **`scripts/jobs/test/timeout-classifier-test.sh`** — flipped both subtests (the old test asserted rc=124 → REAL). SUBTEST 1 now asserts the two classifiers are disjoint/complementary (124→timeout-transient but not signal-kill; 143→signal-kill but not timeout); SUBTEST 2 asserts the integration path classifies rc=124 transient: no inbox escalation, no `kind:error`, a `kind:progress` note emitted, job left in `doin`.

**Verification:** `timeout-classifier-test.sh` 11/11 pass; `signal-kill-classifier-test.sh` 17/17 pass (unaffected — `is_external_kill_rc` unchanged). Other rc=124 references in the tree (clone-keeper/deadmail/journal_fetch fetch-timeouts) are unrelated and untouched.

**Committed & pushed** to `main2` (`c57e7f3d1..6b0c315cf`) on the first CAS attempt. Inbox drained empty.

**Follow-ups:** None required. (The pre-existing OPEN failed-job-lane design decision flagged in `gardener.sh` is untouched, as before.)
