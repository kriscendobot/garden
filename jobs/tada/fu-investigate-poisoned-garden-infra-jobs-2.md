The fix is landed on `origin/main2`. Here's my completion report.

## Completion report

**Job:** Harden the reaper against mass-poisoning from sustained environmental transients (an API/quota outage was poisoning healthy jobs after 5 cycles).

**Root cause:** The reaper increments a per-job poison counter on every requeue cycle and poisons at `GARDEN_REAP_POISON_THRESHOLD`. During a fleet-wide correlated outage (Claude quota/usage cut, API-overload storm), many handlers transient-fail at once for reasons unrelated to any one job, so a healthy job accrued the full threshold of purely-environmental cycles and was parked + paged — the 2026-07-01 dozen-job poisoning.

**Fix (chose "pause the counter while the fleet brake is engaged"):** The shared fleet brake is the right discriminator — a per-job defect fails while peers succeed; a fleet-wide outage lights up the correlated-transient density the brake already measures. Implemented as a gardener-stamped hint (robust across leader/follower hosts, mirroring the existing productive-cycle/reap-now hint architecture):

- **`common.sh`** — new `OUTAGE_MARKER` (`<!-- garden-outage-cycle -->`) with `has_outage_cycle_hint` / `stamp_outage_cycle_hint` (idempotent, bounded CAS retry, subshell-safe; a copy of the productive-cycle hint's contract).
- **`gardener.sh`** — after `record_transient_failure` in both transient paths (exit-0-unsatisfying and rc≠0), stamp the outage hint when `fleet_brake_engaged`. Also gated the elapsed-constancy early-escalation behind `! fleet_brake_engaged` so its early-poison overrun stamp can't defeat the pause during a constant-elapsed usage-cap outage.
- **`reaper.sh`** — `clean_body` strips the outage marker (re-earned each cycle); the poison branch **holds** the counter (not increment, not reset) on an outage cycle and skips the poison decision entirely (`outage` guard). Unlike a productive cycle it holds rather than resets, so intermittent outages can't erase legitimate prior failures and shield a genuinely-broken job.

**Verification:**
- New regression test `test/outage-poison-pause-test.sh` (10 subtests): helper stamp/detect/idempotency, gardener e2e (stamps iff brake engaged, not when disengaged), reaper (outage cycle at threshold → requeued held-not-poisoned; non-outage cycle still poisons; partial count held-not-reset). All pass.
- Existing regressions all green: productive-cycle (10), reaper-poison-park (5), fleet-brake (14), and the classifier suite (elapsed-constancy 25, signal-kill 17, empty-output 14, timeout 36, session-limit 15, handler-budget 7).
- `bash -n` clean on all four files; shellcheck on the new test surfaces only the two SC2046/SC2034 warnings inherent to the shared test idioms (also present in the sibling `productive-cycle-test.sh`; test scripts aren't in CI's shellcheck scope).

**Landed:** commit `913cfc8e9` on `origin/main2` (confirmed).

**Follow-ups:** None required. Note that the outage hint depends on the journal push succeeding while the outage is in progress — fine for the common Claude-quota case (GitHub/git is up); if the journal remote itself is also down, `stamp_outage_cycle_hint` can't land and that cycle counts, but the TTL-requeue and subsequent-cycle re-stamp backstop it, same as the existing reap-now hint.
