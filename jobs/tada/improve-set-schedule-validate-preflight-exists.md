The job's requested change is already fully implemented and committed to `origin/main2` (my worktree HEAD). No new work was needed.

## Report

**Finding:** The exact hardening this job asks for already exists in `scripts/jobs/set-schedule.sh` on `origin/main2`, landed as two commits:
- `48053a960` — "set-schedule: reject a nonexistent preflight gate at set time"
- `fe4b52c91` — "set-schedule: validate a preserved preflight gate, not just the env-var one"

**What's in place (verified against the spec):**
- A `validate_preflight()` helper (set-schedule.sh:48–52) resolves the reference **exactly as `scheduler.sh` does** — absolute paths pass through, relative paths resolve against `scripts/jobs/` (`$HERE`) — and `die`s unless the resolved path is an executable file (`[ -x "$pf" ]`). I confirmed this matches `scheduler.sh:158,160` character-for-character in resolution and the `-x` test.
- It fires for **both** sources the spec calls out: a newly-supplied `GARDEN_SCHEDULE_PREFLIGHT` (checked up front at line 55, before touching the clone) **and** a value preserved from the existing schedule file (checked at lines 73–75, inside the CAS loop, before the write/push).
- The scheduler's runtime fail-open is untouched — a preflight deleted *after* arming still fails open with the WARN + not-found-streak escalation (`scheduler.sh:160–166`), which is the correct safety valve.

**Sanity check:** Ran the guard's resolution/`die` logic against a nonexistent `gardening/does-not-exist-preflight.sh` — it correctly rejected with the clear message and a nonzero exit.

**Changes made:** None — the working tree is clean and identical to `origin/main2`; there is nothing to commit or push.

**Follow-ups:** The still-broken `xs2rust-endor-press.md` schedule already on the journal (pointing at an absent `gardening/xs2rust-endor-press-preflight.sh`) is out of scope for this hardening job — it's handled at runtime by the scheduler's fail-open + maintainer escalation, and re-arming it via `set-schedule.sh` will now be blocked until the gate script actually lands. If desired, a separate job could either land that preflight script or remove/repoint the schedule so it stops burning dispatches every cadence.
