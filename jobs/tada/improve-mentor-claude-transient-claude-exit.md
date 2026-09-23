Pushed to main2 on the first attempt. The work is complete and verified.

## Completion report

**Job:** `improve-mentor-claude-transient-claude-exit` — fix `scripts/jobs/handlers/mentor-claude.sh` misreading a transient inner-`claude` outage as a real handler defect.

**Root cause (confirmed):** The `claude -p` call at line 65 ran under `set -euo pipefail`, so any non-zero `claude` exit (the common transient case — quota/usage cut, Anthropic overload/5xx, api/network blip) aborted the handler at rc=1 with claude's stdout captured into `$out` and then discarded, re-emitting nothing. `mentor.sh` then saw an *empty capture + rc=1*, which matches neither `is_transient_empty_failure` (needs a signal/offline rc like 143/130/137/75) nor `is_transient_claude_signature`/`_fetch_stderr_is_offline` (both need signature TEXT), so it fell through to `die` — the 30-min bare "FATAL: improve handler failed" loop observed 2026-07-06 00:50/01:20/01:50, which also fires `self-heal-run.sh` into an identically-failing diagnosis.

**What changed:**
- `scripts/jobs/handlers/mentor-claude.sh`: run the inner agent under `set +e`, capture `rc` and the combined stdout+stderr, restore `set -e`, and on non-zero rc re-emit the captured output to stderr **and** `exit "$rc"` — so mentor.sh's transient classifiers see the signature text and/or a propagated signal rc and correctly WARN-and-retry. The rc=0 path parses `$out` for JOB blocks exactly as before. Mirrors `gardener-claude.sh` / `follow-up-claude.sh`.
- Routed the call through a `GARDEN_MENTOR_CLAUDE` seam (default `claude`), mirroring the existing `GARDEN_FOLLOWUP_CLAUDE` convention, so the path is testable — necessary because the fleet sandbox **pins the literal `claude` binary** (a PATH shim named `claude` gets "Permission denied"; a differently-named stub is required).
- `scripts/jobs/test/run-test.sh`: added a regression that drives the real handler via `fake-claude.sh` failing with a transient signature and asserts rc≠0 with the signature re-emitted.

**Verification:** Handler + test syntax clean (`bash -n`); no new shellcheck findings. Ran the new test snippet with the harness's variable values — **PASS** (rc=1, "Overloaded (529)" re-emitted). This is exactly the signal mentor.sh's existing (already-tested) `mentor-transient.sh`-stub branch absorbs into WARN + exit 0.

**Committed & pushed:** `8aab4e459` → `origin/main2` (clean CAS push, no rebase needed).

**Follow-up:** The fix is on `main2` but the deployed root checkout still carries the old handler until a deliberate `deploy-garden.sh` runs — until then `garden-mentor.service` can keep hitting the FATAL loop during any live outage. A deploy of the leader's root is the closing step.
