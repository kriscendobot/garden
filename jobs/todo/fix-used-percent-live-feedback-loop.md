---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
**Follow-up to `3d65d01c` (fix-subscription-used-percent-per-subscription): the claim gate's Claude utilization is still stuck through a self-feedback loop.**

**Observed 2026-09-30 ~07:02Z, after 3d65d01c deployed on both endolin hosts:**
- The per-subscription ledger filter works. The newest `usage/` rows are 0.80 for `endolin-garden-ece02cb4` (claude-endolin1) and 0.64 for `endolin-garden2-5bcdff64` (claude-endolin2).
- But `subscription_used_percent` returns **78 for both**. The dashboard truth is about 80% and about 65%.

**Cause (please verify):**
- The meter writer (`scripts/jobs/usage-meter.sh` ~L798-848) computes `used_percent` by calling `subscription_used_percent`, then publishes it as `used_percent:` in `budget/live/<sub>/<host>` with a fresh `sampled_at_epoch`.
- `subscription_used_percent` (~L1045) reads those same live files as a source. The newest epoch wins, and the live file is always newer than the ledger row.
- So a value that was contaminated before the fix (78) keeps recomputing itself and never converges to the ledger.

**Fix:**
- A live file's `used_percent` must not outrank the ledger it came from. Options:
  - the writer publishes the ledger row's own sample epoch, not the write time; or
  - `subscription_used_percent` skips live `used_percent` values the meter derived (keep only independently observed ones, such as codex-cli rate-limit percentages); or
  - the ledger always wins when present.
- Add a regression test: two subscriptions, stale contaminated live files, and fresh per-host ledger rows; each subscription must read its own ledger value.
- Land direct to main2.

**Why urgent:** the fleet is spending both endolin Claude subscriptions up to the maintainer's 90% policy (`config/token-backoff-fraction` 0.90). claude-endolin1 is under-read (78 vs 80), so the gate would let it overshoot. The liaison runs a meter-based backstop, but the gate must be right.
