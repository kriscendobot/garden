---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
The weekly Claude quota should have just reset (~Friday 20:00 Pacific /
2026-08-29T03:00:00Z). `config/budget-pools`'s cap for
`anthropic:endolin-garden-ece02cb4` currently reads 650,000,000 — this is
NOT a real-capacity figure. It was a deliberate, bounded, maintainer-
authorized override on 2026-08-27 to clear the leveler's 85% high-water
mark and admit MAX (4) monks for the last ~1.5 days of that cycle, so
remaining real quota would be spent down on the minion-town-press and
xs2rust-endor-press campaigns rather than wasted at reset. Do NOT carry
650,000,000 forward.

Recalibrate it to an honest figure: if the maintainer has given a fresh
Claude Code /usage-derived weekly-capacity number this week, use that. If
not, fall back to ~150,000,000 (the prior week's back-solved estimate from
2026-08-27: real spend 74,531,754 at a reported 50% used implies ~149M/wk)
until a fresher number is available. Confirm the recalibration by checking
that `scripts/jobs/budget-level.sh`'s next tick computes a sane target
(not pinned at MAX from the stale 650M) against this week's actual spend.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-08-29T03:21:01Z
