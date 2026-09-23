Done. The fix is committed and pushed to `origin/main2` (`6a6e21b36`), the worktree is cleaned up, and the inbox is empty.

---

## Completion report

**Job:** `self-heal-fix-garden-follow-up-handler-swallows-producer-failure`

**Root cause confirmed:** `scripts/jobs/handlers/follow-up-claude.sh` ran each emitted action block as a bare piped producer under `set -euo pipefail`, so any non-zero downstream exit killed the tick. `follow-up.sh` then left the seen-marker unadvanced and retried the same digest every 10 min — re-rolling the non-deterministic `claude -p` output and re-failing whenever a roll produced a bad block (the 07:53–08:25 2026-06-27 wedge). A prior commit (`3ab9074bc`) already addressed requirement (1) — surfacing `claude`'s own exit/stderr instead of an opaque `FATAL` — but it went too far on the producer loop: it swallowed **every** producer failure, so a genuinely transient push-exhaustion no longer retried either. Requirement (3) was unmet and there was no test.

**What I changed (one handler + test, on an isolated worktree off `origin/main2`):**
- Added `run_producer`, which captures each producer's combined output+status without letting `pipefail` abort the tick, and classifies the failure:
  - **Deterministic per-block rejection** (illegal derived name / unparseable value — what the producers `die` on before touching the network): logged, routed to the maintainer inbox (best-effort, so it isn't silently dropped), and **skipped** — never fails the tick, so a re-roll can't re-wedge the seen-marker.
  - **Transient failure** (push-retry exhaustion): sets `tick_failed`, so the handler `die`s at the end and `follow-up.sh` keeps the marker and retries next cadence. Unrecognized failures default to transient (safe = retry, not silent-drop).
  - Routed all four producer invocations (JOB / SCHEDULE / SCHEDULE-ONCE / MAINTAINER) through it.
- Indirected `claude -p` via `GARDEN_FOLLOWUP_CLAUDE` for deterministic testing.
- Added `scripts/jobs/test/fake-claude.sh` (deterministic `claude -p` stand-in) and `run-test.sh` **SUBTEST 13b**, asserting: an illegal-name block is logged-and-skipped (tick succeeds, marker advances, routed to maintainer) while a forced transient push failure fails the tick (marker not advanced).

**Verification:** Full `run-test.sh` suite — **174 PASS, 0 FAIL**, exit 0 (the new 13b assertions pass and downstream subtests stay green, so my new state setup doesn't corrupt the shared fixture).

**Commit:** `6a6e21b36` on `main2`.

**Follow-ups:** None. The classifier keys on the producers' current die strings (`illegal basename`, `illegal schedule name`, `unparseable ISO datetime`); if those messages are ever reworded, `is_deterministic_rejection` in the handler must be updated in lockstep — the safe default (retry) means a drift would only cost extra retries, not silent work loss.
