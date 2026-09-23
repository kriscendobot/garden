Inbox empty. Work complete.

---

## Completion report

**Job:** Classify the Claude Code session/usage-limit signature as a transient `claude -p` failure.

**What I did**

1. **Extended the canonical signature set** (`scripts/jobs/common.sh:852`, `GARDEN_TRANSIENT_CLAUDE_SIGNATURES` — the single source of truth consumed by `is_transient_claude_signature`). Added three case-insensitive alternatives:
   - `hit your (session|usage) limit`
   - `(session|usage|5-hour) limit (reached|reset)`
   - `resets [0-9].*\(utc\)`

   These match the incident capture `"You've hit your session limit · resets 1:10am (UTC)"` (blob 35b3d8ab…) verbatim, plus the usage-cap and 5-hour wording variants. Updated the header comment to document the new signature class.

2. **Added a code comment** on the signature var noting the optional follow-on (back off the requeue until the named reset time rather than re-failing every TTL cycle) — flagged as out-of-scope for this job, as the spec permitted.

3. **Added a test + stub** alongside the existing timeout/signal-kill classifier tests:
   - `scripts/jobs/test/claude-session-limit-classifier-test.sh` — SUBTEST 1 drives `is_transient_claude_signature` directly on the exact incident string (and variants; and pins that an ordinary crash stays a real failure); SUBTEST 2 runs the real `gardener.sh` against a stub that emits the exact capture and exits rc=1 (the non-signal/non-timeout/non-offline path where only the signature match can rescue it), asserting: transient verdict logged, **no** gardener-inbox escalation, **no** kind:error entry, job left in doin for the reaper's requeue.
   - `scripts/jobs/test/claude-session-limit-handler-stub.sh` — the handler stub.

**Verification**
- New test: 15/15 pass.
- Existing `signal-kill` (17/17), `timeout` (18/18), `empty-output` (14/14) classifier tests still pass — no regression from the regex change.
- `bash -n` clean on all three files; shellcheck warnings are identical to the existing sibling stubs/tests and outside CI's lint scope.
- Confirmed `handlers/follow-up-claude.sh:139` calls the same helper, so it inherits the fix automatically (single source of truth, no drift).

**What changed:** `scripts/jobs/common.sh` (+ 2 new test files). Committed as `85cdde4f5` and pushed to `main2` (clean, first attempt).

**Follow-ups:** The reset-time-aware requeue backoff remains an unimplemented, non-required enhancement (now flagged in the code comment).
