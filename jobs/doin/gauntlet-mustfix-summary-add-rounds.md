---
role: gardener
tier: mentor
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-10-09T07:55:10Z cleared=none -->

---
role: gardener
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Gauntlet resume: --add-rounds N

Parent: gauntlet-early-termination-unaddressed-must-fix-summary (maintainer request 2026-10-09; full spec in its jobs/tada report or the journal job history). Goal: when scripts/jobs/gauntlet.sh ends early (review-budget-reached / halted / parked-ci-billing; held-draft owes none), summarize the UNADDRESSED must-fix requests so the maintainer can decide whether to add budget and resume. Today only a count is shown (gauntlet.sh:333, scraped from "must-fix items (N):"). See designs/gauntlet-panel-fix-nonconvergence.md (the findings set moves round to round). Land directly on main2.

## This slice
Add the smallest resume form that both raises max_iterations and resumes, e.g. gauntlet.sh --resume-from-stage <g> <stage> --add-rounds N. Test it, and document it in the gauntlet usage header, the operator docs, and the pr-creation-flow skill's gauntlet section.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-09T08:02:57Z
