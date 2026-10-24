---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
role: fixer
delegation: minion-town-pr-screening
# Heal minion.town production after merge c104813b9c464ecf314e469a4456c72ec7cdeda9
Merge c104813b9c464ecf314e469a4456c72ec7cdeda9 (https://github.com/kriscendobot/minion.town/pull/218) broke production: deploy.yml failure.
Run: https://github.com/kriscendobot/minion.town/actions/runs/40135158359
Restore production by the cheapest correct route: a forward-fix PR or a revert PR of
c104813b9c464ecf314e469a4456c72ec7cdeda9, against base main. Put this marker on its own line in the PR body:
<!-- garden-heal: c104813b9c464ecf314e469a4456c72ec7cdeda9 -->
Open it with scripts/jobs/gardening/ensure-pr.sh and stage the ordinary gauntlet; the
proxy screens and merges a marked heal PR even while the delegation is paused. Never
push to main directly and never force-revert main.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 3
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-24T21:43:30Z
