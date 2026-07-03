Both changes this job asks for are already implemented on `main2` and verified green. Report follows.

---

## Completion report: `improve-scheduler-preflight-dangling-reference-guard`

**Outcome: already satisfied on `main2` — no new commit required.** Both hardening requirements the job describes were already implemented and committed to `origin/main2` (HEAD `fe4b52c91`), and I verified them end-to-end rather than taking the code on faith.

### What the job asked, and where it's already done

1. **`set-schedule.sh` — reject a dangling `preflight:` at write time.** The `validate_preflight()` helper (lines 48–52) resolves a reference exactly as `scheduler.sh` does (relative to `scripts/jobs/` unless absolute) and `die`s with a clear message unless it's an executable file. It's called for **both** the env-supplied gate (line 55, up front) **and** a gate preserved from an existing schedule on a cadence change (lines 73–75). Landed by commits `48053a960` (set-time reject) and `fe4b52c91` (preserve-path validation).

2. **`scheduler.sh` — distinguish configured-but-absent from a transient error.** A not-found/non-executable gate still fails open (never starves a schedule) but now increments a persisted `preflight_missing_streak`, and at `PREFLIGHT_MISSING_ESCALATE_THRESHOLD` (default 3) escalates **once** to the maintainer inbox via `escalate_missing_preflight()`, dedup'd by firing only on streak==threshold after the commit lands. A gate that exists but *errors* is treated as transient and resets the streak. Landed by commit `6f0e35c05`.

3. **The concrete symptom is also resolved.** `scripts/jobs/gardening/xs2rust-endor-press-preflight.sh` now exists and is executable, so the `schedules/xs2rust-endor-press.md` reference on `journal2` is no longer dangling — the gate resolves and gates dispatches as intended.

### Verification performed

- Ran the committed suite `scripts/jobs/test/run-test.sh`; it covers this exactly in **SUBTEST 8b** ("set-time guard, not-found vs error, escalate-after-N"). The full run aborts earlier at SUBTEST 6 (maintainer-channel) on an unrelated live-journal env-leakage flake (`maintainer-reply: message has no reply_to`, a message that bled in from the running fleet's shared journal), so I reproduced SUBTEST 8b's 11 assertions in a fully hermetic harness (throwaway bare journal, scrubbed `GARDEN_*` env, clock driven by `GARDEN_SCHEDULER_NOW`). **All 11 passed**: set-time reject of a nonexistent gate, accept of a valid one, preserve-path reject of a now-dangling gate, fail-open dispatch for both missing and erroring gates, streak increments only for not-found, one-time escalation at threshold, and continued fail-open past threshold with no re-escalation.
- Note for future runners: `/tmp` is `noexec` on this host, which silently defeats any `[ -x ]`/exec-based test placed there (both under and outside the Claude sandbox). The harness only passes with its temp tree on an exec-capable path (e.g. under `/home/kris/scratch`).

### Follow-ups
- **Pre-existing test flake (not this job):** `run-test.sh` SUBTEST 6 fails under live fleet load because a real maintainer-inbox message without `reply_to` leaks past the hermetic scrub into the test's inbox. Worth a separate job to tighten SUBTEST 6's isolation (or make `maintainer-reply.sh` skip-and-warn instead of FATAL on a missing `reply_to`) so the suite runs clean to completion on a busy host.

No changes to push; working tree clean at `fe4b52c91` (== `origin/main2`).
