Inbox is empty. Work is complete.

## Completion report

**Job:** `improve-mentor-transient-handler-exit-zero` — stop `mentor.sh` from turning a transient inner-handler outage into a systemd `Failed` state.

**Root cause (confirmed):** At `mentor.sh:87` the `$GARDEN_MENTOR_HANDLER` invocation was gated by a bare `if … then … else die …`. During the 2026-07-02 01:20:07/01:50:08 broad `claude` quota/usage cut + api.github.com outage the handler failed, so mentor took the `die "…retry next tick"` branch. `die()` exits 1, which (a) marked `garden-mentor.service` Failed and (b) fired `self-heal-run.sh` into a `claude -p` diagnosis that failed identically in the same outage. The intent — retry next tick — is already satisfied by leaving `$SEEN`/`$JSINCE` unadvanced, so a transient must exit 0.

**What changed:**
- `scripts/jobs/mentor.sh` — capture the handler's combined stdout+stderr to a temp file. On failure, when the captured output matches `is_transient_claude_signature` OR `_fetch_stderr_is_offline` (the existing `common.sh` helpers, covering claude overload/5xx/quota-cut and github/network/DNS blips), `log` a `WARN` and `exit 0` without advancing the markers — the transient retries next tick with no `Failed` state and no self-heal cascade. The `die` (exit 1 → self-heal) path is reserved for a genuine non-transient handler failure, and now surfaces the real diagnostic to stderr before dying. Mirrors `gardener.sh`'s transient-vs-real classification.
- `scripts/jobs/test/run-test.sh` — added a regression subtest to SUBTEST 11 (MENTOR): a transient-signature handler failure → exit 0 with markers unadvanced; a genuine non-transient defect → non-zero exit.

**Verification:** `bash -n` clean on both files. Full test suite run: both new mentor assertions PASS ("transient handler outage → exit 0, markers unadvanced"; "genuine handler defect → non-zero exit"). The 4 unrelated failures in the run are in the issue-inbox / issue-source-gh subtests (empty `out:` — they need a live-authenticated `gh`, unavailable in this sandbox) and are pre-existing, untouched by this change.

**Pushed:** committed with explicit pathspecs and pushed `HEAD:main2` (CAS loop, landed on attempt 1).

**Follow-ups:** none required. (An adjacent, out-of-scope idea already noted in `common.sh`: when a transient signature carries an explicit reset time, back the reaper requeue off until that time rather than re-failing every cycle.)
