---
role: fixer
handler-timeout: 7200
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Refit the Claude subscription caps from manual checkpoints (fix the fitter first)

Maintainer (kriskowal, liaison 2026-10-04): approved.

The leveler paces each Claude subscription against its token cap in `config/budget-pools`,
but the meter/cap ratio disagrees with the maintainer's dashboard:

| sub | meter spend (10-04T04:26Z) | configured cap | leveler % | dashboard % | implied cap |
|---|---|---|---|---|---|
| claude-endolin2 | 91.0M | 121M | ~75% | 53% | ~172M |
| claude-endolin1 | 87.7M | 256M | ~34% | 31% | ~283M |

claude2 looks ~40% under-capped, so the leveler throttles garden2 harder than quota requires.

`scripts/jobs/fit-quota-calibration.sh <host> --dry-run` exists for this, but on both
endolin hosts it returns "no usable paired checkpoints (all rows none/flagged or
null-spend)", although `append-quota-checkpoint.sh` recorded fresh rows on 2026-10-03 and
2026-10-04 (journal `budget/manual-checkpoints/`).

1. Find why the fitter rejects these rows (schema/key drift between recorder and fitter,
   per-host vs per-subscription keying, confidence filtering, null spend) and fix the
   wrong side, with a test in scripts/jobs/test/. Land on main2.
2. Run the fit for claude-endolin1 and claude-endolin2 and report each recommended cap
   with its confidence grade.
3. Promote with `set-budget-pool.sh` ONLY a `converged` fit; otherwise report the numbers
   and leave the pool unchanged. Do not change pacing policy, the 0.90 backoff fraction,
   or codex/oros pools.
Context: the maintainer plans to burn claude-endolin2 to ~90% and spend its reset credit
early this week, so a higher claude2 cap is consistent with that plan.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-04T04:38:29Z
