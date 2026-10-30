once: 2026-10-31T04:00:00Z
job_basename_prefix: ironhorse-coverage-report-20261031
---
---
role: researcher
---
# Report: Ironhorse test262 coverage gained during the 2026-10-24 quota week

Maintainer ask (kriskowal, liaison session 2026-10-30): the maintainer released tokens to the
Ironhorse test262 ratchet (arc budget `ironhorse-test262-ratchet`: 20M tokens, 604800s rolling
window, 3600s press interval, set 2026-10-30T03:09:33Z) to spend headroom before the quota reset
at 2026-10-31T03:00:00Z. He wants a report on the increased coverage at the end of the period.

## Measure
- Baseline: the enforced floor recorded in `ratchets/ironhorse-test262-ratchet/state.json` on
  journal2 as of 2026-10-30T03:09Z (cases covered, from its `covered.txt`), plus the
  `llm` head of endojs/endo-but-for-bots at that time. Take the latest merged baseline refresh
  at or before that moment.
- End: the enforced floor and `llm` head at 2026-10-31T03:00Z.
- Report covered-case counts (absolute and as a share of the corpus total), the delta, and the
  movement by test262 area where the baseline files allow. Name each ratchet crank that landed
  (PR, merge time, aborted-reason cluster it addressed) and each that is in flight or blocked,
  with the reason. Include the press engagements run, their token spend from
  `scripts/jobs/arc-spend.sh ironhorse-test262-ratchet`, and tokens per newly covered case.
- If no crank landed, say so plainly and name the blocker (budget, gauntlet, CI, floor
  resolution); do not infer coverage from open PRs. Distinguish merged from pending.

## Deliver
Land `reports/ironhorse-coverage-quota-week-20261031.md` on journal2 per
`skills/liaison-reports/SKILL.md` § Landing convention and give the fully qualified
https://github.com/kriscendobot/garden/blob/journal2/reports/ URL in the completion report.
