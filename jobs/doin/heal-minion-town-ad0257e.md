---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
role: fixer
delegation: minion-town-pr-screening
# Heal minion.town production after merge ad0257e18e2d050d2ed4b1728f8066f468357097
Merge ad0257e18e2d050d2ed4b1728f8066f468357097 (https://github.com/kriscendobot/minion.town/pull/93) broke production: deploy.yml failure.
Run: https://github.com/kriscendobot/minion.town/actions/runs/38610358762
Restore production by the cheapest correct route: a forward-fix PR or a revert PR of
ad0257e18e2d050d2ed4b1728f8066f468357097, against base main. Put this marker on its own line in the PR body:
<!-- garden-heal: ad0257e18e2d050d2ed4b1728f8066f468357097 -->
Open it with scripts/jobs/gardening/ensure-pr.sh and stage the ordinary gauntlet; the
proxy screens and merges a marked heal PR even while the delegation is paused. Never
push to main directly and never force-revert main.

<!-- garden-terminal-handler-failure -->
---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-10-14T18:14:39Z
