Inbox empty. Work complete.

## Completion report

**Job:** improve-scheduler-preflight-validation

**Finding:** The job's two proposed remedies were *both already implemented* in commits that landed since this job was posted:
- `set-schedule.sh` now resolves a supplied `GARDEN_SCHEDULE_PREFLIGHT` relative to `scripts/jobs/` (mirroring the scheduler's `HERE`-relative resolution) and `die()`s if it is not an executable file — commit `48053a960`. Verified working: it rejects a bogus path and accepts the real one.
- The missing gate `scripts/jobs/gardening/xs2rust-endor-press-preflight.sh` was authored and is executable — commits `adb542d64`/`0e1d7a0ad`. The `xs2rust-endor-press.md` schedule's `preflight:` line now points at a real, executable gate, so its no-work gate functions.
- Bonus hardening already present: the scheduler escalates a persistently not-found gate to the maintainer inbox after N ticks — commit `6f0e35c05`.

**Genuine remaining work I did:** The hardening commit `48053a960` broke its own test suite and left the new guard untested. `run-test.sh` SUBTEST 8b built its "deploy-lag" fixture by feeding a genuinely-absent gate (`gardening/nonexistent-preflight.sh`) straight into `set-schedule.sh` — which now `die()`s at set time. Under the harness's `set -euo pipefail` that failing pipeline aborts the entire run-test.sh, silently killing the scheduler-preflight coverage and everything after it. I confirmed this empirically (harness-faithful `set -euo pipefail` script exits 1 at that line).

**Fix (commit `ccb7bf5df`, pushed to main2):**
- Reconstructed the fixture faithfully: register the `missgate` schedule with a real exit-2 gate (so the set-time guard passes), then `rm` the script to simulate the deploy-lag state the scheduler's not-found branch actually handles.
- Added direct positive coverage for the guard itself (previously none): asserts `set-schedule.sh` *rejects* a nonexistent gate and *accepts* one resolving to an executable, using errexit-exempt `if` conditions.
- Verified: SUBTEST 8 + 8b now pass **14/14** in isolation via a scratch driver running the real preamble + subtests.

**Follow-up (out of scope, flagged):** The full `run-test.sh` fails earlier at **SUBTEST 6 — MAINTAINER CHANNEL** with `maintainer-reply FATAL: message … has no reply_to`. This is pre-existing and unrelated to preflight (both pre-edit runs failed there; my changes are only in the later SUBTEST 8b), but it means the full harness is currently red on a pristine `origin/main2` checkout. Worth a dedicated job — the reply picks an earlier maintainer-inbox message lacking `reply_to`, suggesting inbox-state pollution from an earlier subtest.
