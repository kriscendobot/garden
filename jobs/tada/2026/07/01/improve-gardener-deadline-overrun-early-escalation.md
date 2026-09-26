Clean, pushed, and all 31 tests green against the rebased tree. Done.

---

## Completion report

**Job:** Act on the deadline-overrun signal instead of only logging it — early-escalate a job that hits its OWN handler wall-clock budget.

**What I did** (committed as `4fb807154`, pushed to `main2`):

1. **`scripts/jobs/gardener.sh`** — In the transient failure branch, when `is_handler_timeout_rc "$rc"` is true (rc=124) AND `elapsed >= GARDEN_HANDLER_TIMEOUT - epsilon`, the gardener now sets a `deadline_overrun` flag and, in the transient block, stamps a distinct `<!-- garden-deadline-overrun: N -->` counter (via the new `stamp_deadline_overrun_hint`, which stamps it *alongside* the reap-now hint) instead of the plain reap-now path. Added knob `GARDEN_HANDLER_DEADLINE_EPSILON` (defaults to `GARDEN_HANDLER_KILL_AFTER`) as the guard band confirming the handler hit its own wall rather than an external kill. Emits a distinct progress note naming the wall-clock budget.

2. **`scripts/jobs/common.sh`** — New `§ deadline-overrun` section: `DEADLINE_OVERRUN_MARKER_RE`, `deadline_overrun_count` (reader), and `stamp_deadline_overrun_hint` (increment-and-re-stamp the counter + reap-now, drop the prior overrun marker, bounded CAS retry — mirrors `stamp_reap_now_hint`).

3. **`scripts/jobs/reaper.sh`** — New knob `GARDEN_REAP_OVERRUN_THRESHOLD:=2`. The poison decision now poisons a job whose `deadline_overrun_count >= GARDEN_REAP_OVERRUN_THRESHOLD` (2) OR `count >= GARDEN_REAP_POISON_THRESHOLD` (5). The overrun-triggered poison alert names the deterministic-overrun signature (rc=124, elapsed≈GARDEN_HANDLER_TIMEOUT, "exceeds the handler budget") rather than the generic per-cycle message. The external-signal-kill path (143/130/137) is untouched and stays on the 5-cycle threshold. `clean_body` already preserves the overrun marker across requeues (it strips only reap-count/reap-now), so the counter accumulates cycle over cycle.

4. **`scripts/jobs/test/timeout-classifier-test.sh`** — Added SUBTEST 1b (helper `deadline_overrun_count` round-trip + the elapsed-at-the-wall arithmetic branch, including a below-wall negative), extended SUBTEST 2 to assert the overrun counter + reap-now hint get stamped and the distinctive progress note is journaled, and added SUBTEST 4 (reaper requeues a below-threshold overrun and *preserves* the marker) and SUBTEST 5 (reaper *poisons* an overrun-2 job at the lower threshold, naming the budget signature). Now 31 passing.

**Verification:** `timeout-classifier-test.sh` 31/31; regression-checked `signal-kill`, `empty-output`, `elapsed-constancy`, `completion-signal`, `claude-session-limit` classifier tests — all green. shellcheck surfaced only pre-existing findings in untouched code.

**Notes / follow-ups:**
- The elapsed-constancy escalation already excludes `is_handler_timeout_rc`, so there's no double-escalation — deadline-overrun is the dedicated handling for the rc=124 case that constancy deliberately skips.
- One test-only wrinkle worth recording: the reaper's existing orphaned-worktree `sed work/<spine>` runs under `pipefail`, so a hand-crafted seed must include a `work/<spine>` file (a real claim always has one) or `set -e` aborts the reaper before the requeue. Handled in SUBTEST 5's seed.

<<<GARDEN-JOB-COMPLETE>>>
