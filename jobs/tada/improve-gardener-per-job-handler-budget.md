Pushed to main2. Done.

---

## Completion report

**Job:** `improve-gardener-per-job-handler-budget` — let a job declare a longer per-job handler budget so a legitimately long run-to-completion job isn't structurally SIGTERM-killed at the fixed 2400s cap.

**What I did**

In `scripts/jobs/gardener.sh`, added optional per-job handler-budget resolution immediately before the `timeout --signal=TERM --kill-after=... <budget> <handler>` call site (formerly `line 199`), and changed the invocation to use the resolved `$handler_budget` instead of the hardcoded `$GARDEN_HANDLER_TIMEOUT`:

- Reads an optional `handler-timeout: <seconds>` header from `$jobfile` (canonical `sed -n 's/^handler-timeout:...' | head -1`, digits-only).
- **Honored verbatim** in place of the default when it fits the single-owner invariant `budget + GARDEN_HANDLER_KILL_AFTER < GARDEN_CLAIM_TTL` (max = `CLAIM_TTL - KILL_AFTER - 1`).
- **Clamped to the safe max AND escalated** via `alert_maintainer` ("needs a longer budget than a single claim can hold; run detached or split") when the request exceeds the invariant — never silently raised, which would let the reaper requeue the same base onto a second gardener mid-run (duplicate execution). The alert is throttle/dedup-keyed per base.
- **Ignored** (default stands) when non-numeric or `<1` — `0` would disable `timeout` entirely and break the invariant.
- Added `: "${GARDEN_CLAIM_TTL:=3600}"` (mirroring reaper.sh's authority) so the clamp math has a value, with a comment noting the reaper stays the sole requeue owner.

**Tests added** (`scripts/jobs/test/`): `handler-budget-test.sh` (3 subtests: honor / clamp+escalate / ignore-invalid, 7 assertions) plus two committed stubs (`budget-sleep-complete-handler-stub.sh`, `budget-alert-record-stub.sh`). Stubs live in the repo test dir because this sandbox mounts `/tmp` noexec (rc=126 otherwise), matching existing stub convention.

**Verification**
- New test: 7/7 pass.
- Existing `timeout-classifier-test.sh`: 18/18 pass (no regression at the modified call site).
- `bash -n` clean on all four files; `shellcheck -S warning` on gardener.sh shows the same 2 pre-existing SC2034 (no new warnings). New test/stub warnings match existing gardener-stub conventions and are outside CI's shellcheck scope.

**Committed and pushed** to `main2` (`403001684`) via rebase CAS (first attempt).

**Follow-ups / notes**
- The over-budget path clamps-and-runs best-effort at the max this cycle (SIGTERM-killed at that bound, then requeued) while escalating — so a genuinely-too-long job still surfaces to the maintainer and, if it keeps overrunning, hits the reaper's poison threshold. The intended real fix for such a job is to run it detached or split it, per the escalation message.
- The concrete motivating job (`garden-issue-9-run-contract-control-upgrade-test-to-completion`) can now add `handler-timeout: <seconds>` up to ~3539s (default TTL) to get a longer single-claim run; anything beyond that must go detached/split.
