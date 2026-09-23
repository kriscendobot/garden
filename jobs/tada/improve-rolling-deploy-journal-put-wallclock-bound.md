Pushed cleanly (no rebase needed). The job is complete.

---

## Completion report

**Job:** `improve-rolling-deploy-journal-put-wallclock-bound`

**Re-derivation:** Clean start. Inspected history — HEAD was still at `0fd22b0fac`; the reference fix `5db2500cee` (post-job/post-plan wall-clock bound) was present but never applied to `rolling-deploy.sh`. No prior attempt had committed anything for this job. Confirmed the defect was still live in `scripts/jobs/rolling-deploy.sh` `journal_put`/`journal_rm` (attempt-count-only bound of 25).

**What I did:**
- Added an overall wall-clock deadline to both `journal_put` and `journal_rm` in `scripts/jobs/rolling-deploy.sh`, mirroring the maintainer's `post-job.sh` fix exactly: record loop-start `SECONDS`, and at the top of each attempt bail `GARDEN_OFFLINE_RC` (EX_TEMPFAIL, 75) once `GARDEN_POST_DEADLINE_SECS` (default 300s) is exceeded, before starting a fresh `sync_clone`.
- Verified the mechanism is genuinely clean: `self-heal-run.sh` normalizes exit 75 to a clean exit 0, so a degraded episode is a self-classified skip (the next idempotent conductor tick resumes the roll) rather than the blunt `TimeoutStartSec=900` SIGTERM/kill seen in the 2026-09-17 incident. `GARDEN_POST_DEADLINE_SECS` was already defined in `common.sh` by the reference commit — reused it, no new var.
- Added a **WALL-CLOCK DEADLINE** test section to `scripts/jobs/test/rolling-deploy-test.sh` that drives a real release tick with `GARDEN_POST_DEADLINE_SECS=0` and asserts the tick exits 75, writes no release token, and logs the bail.

**Verification:** `bash -n` clean on both files; full `rolling-deploy-test.sh` passes **45/45** (including the 3 new assertions).

**Changed:** `scripts/jobs/rolling-deploy.sh`, `scripts/jobs/test/rolling-deploy-test.sh`. Committed as `425cf9877a` and pushed to `main2`.

**Follow-ups:** None. The fix is symmetric with the producer-loop fix; both push-CAS loop families are now wall-clock-bounded.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-rolling-deploy-journal-put-wallclock-bound.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s) (1 unmetered)
- Input: 34 tokens (1014522 cached reads)
- Output: 11923 tokens
- Cost: $1.473283 (1 engagement(s) unpriced)
- Wall-clock: 177s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
