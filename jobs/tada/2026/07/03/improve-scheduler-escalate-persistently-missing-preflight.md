Inbox empty. The work is complete and pushed.

## Completion report

**Job:** Harden the scheduler's preflight gate so a *not-found/not-executable* preflight is distinguished from one that *runs and errors*, escalating a persistently-absent gate to the maintainer once instead of silently re-firing an expensive dispatch every cadence.

**What I changed** (committed as `6f0e35c05` on `main2`):

- **`scripts/jobs/scheduler.sh`**
  - Added a `preflight_missing_streak` frontmatter counter, threaded through `write_schedule` (new 7th arg; the line is omitted at 0 so healthy schedules stay clean and a reset clears a stale streak).
  - The gate block now splits the two fail-open cases: a **present** gate (runs, whether it says work-present, no-work, or errors) resets the streak to 0; a **not-found/not-executable** gate still fails open (never starves the schedule) but *increments* the streak.
  - Past a threshold (`GARDEN_PREFLIGHT_MISSING_THRESHOLD`, default 3) it escalates **once** to the maintainer inbox via `message-user.sh` (new `escalate_missing_preflight` helper). Escalation fires only after the streak-bearing CAS commit lands and uses threshold *equality*, so a lost race never double-escalates and it re-arms only after the gate is found again. Delivery is guarded so a send failure can't abort the scheduler.
- **`scripts/jobs/test/run-test.sh`** — added SUBTEST 8b covering: both a not-found gate and an erroring-but-present gate fail open; the not-found gate increments the streak while the erroring gate does not; no escalation below threshold; exactly one escalation at threshold; and continued fail-open (no re-escalation, schedule not starved) past threshold.
- **`skills/schedule/SKILL.md`** — documented the not-found-vs-error distinction and the escalate-after-N behavior.

**Verification:** `bash -n` + `shellcheck -S error` clean on both scripts. My new subtest passes all 9 assertions both standalone and inside the real `run-test.sh` harness. I confirmed the diff introduces **zero** new failures by diffing against baseline.

**Pre-existing failures (not mine, confirmed identical with my changes stashed):**
- `run-test.sh` aborts at SUBTEST 6 on this host because the `identity-drift-guard` (recently wired into the gardener-scaler, exercised by SUBTEST 4) posts drift-warning messages into the shared maintainer inbox — `GARDEN=testhost` diverges from this host's real `hostname -s=endolinbot` with no recorded override — and SUBTEST 6 assumes only its own message is present. Silencing just that emission lets the suite run through my subtest.
- SUBTEST 14d (FOREMAN fill-to-target) fails with `calls=0`, likely skew from the very recent "raise active-job target default 3→5" commit vs. the test's `TARGET=3` expectation.

**Follow-ups (optional, out of scope here):** SUBTEST 6 should tolerate a pre-populated maintainer inbox (or the drift guard's emission should be redirected in the harness); SUBTEST 14d's target expectation likely needs reconciling with the raised foreman default.
