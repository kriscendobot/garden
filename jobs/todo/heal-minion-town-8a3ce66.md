---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
role: fixer
delegation: minion-town-pr-screening
# Heal minion.town production after merge 8a3ce66c4e8fd0e8521b1e2f91ece3a28bb58d71
Merge 8a3ce66c4e8fd0e8521b1e2f91ece3a28bb58d71 (https://github.com/kriscendobot/minion.town/pull/204) broke production: deploy.yml failure.
Run: https://github.com/kriscendobot/minion.town/actions/runs/39281790117
Restore production by the cheapest correct route: a forward-fix PR or a revert PR of
8a3ce66c4e8fd0e8521b1e2f91ece3a28bb58d71, against base main. Put this marker on its own line in the PR body:
<!-- garden-heal: 8a3ce66c4e8fd0e8521b1e2f91ece3a28bb58d71 -->
Open it with scripts/jobs/gardening/ensure-pr.sh and stage the ordinary gauntlet; the
proxy screens and merges a marked heal PR even while the delegation is paused. Never
push to main directly and never force-revert main.
