---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
role: fixer
delegation: minion-town-pr-screening
# Heal minion.town production after merge f6fe2b522cacc8443e45fb42676243cd9edb8cb3
Merge f6fe2b522cacc8443e45fb42676243cd9edb8cb3 (https://github.com/kriscendobot/minion.town/pull/200) broke production: deploy.yml failure.
Run: https://github.com/kriscendobot/minion.town/actions/runs/39617782849
Restore production by the cheapest correct route: a forward-fix PR or a revert PR of
f6fe2b522cacc8443e45fb42676243cd9edb8cb3, against base main. Put this marker on its own line in the PR body:
<!-- garden-heal: f6fe2b522cacc8443e45fb42676243cd9edb8cb3 -->
Open it with scripts/jobs/gardening/ensure-pr.sh and stage the ordinary gauntlet; the
proxy screens and merges a marked heal PR even while the delegation is paused. Never
push to main directly and never force-revert main.
