---
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
role: fixer
delegation: minion-town-pr-screening
# Heal minion.town production after merge a2d2426951de58a0a3e953f24af7a7ea74c39a81
Merge a2d2426951de58a0a3e953f24af7a7ea74c39a81 (https://github.com/kriscendobot/minion.town/pull/213) broke production: deploy.yml failure.
Run: https://github.com/kriscendobot/minion.town/actions/runs/39668538848
Restore production by the cheapest correct route: a forward-fix PR or a revert PR of
a2d2426951de58a0a3e953f24af7a7ea74c39a81, against base main. Put this marker on its own line in the PR body:
<!-- garden-heal: a2d2426951de58a0a3e953f24af7a7ea74c39a81 -->
Open it with scripts/jobs/gardening/ensure-pr.sh and stage the ordinary gauntlet; the
proxy screens and merges a marked heal PR even while the delegation is paused. Never
push to main directly and never force-revert main.

<!-- garden-transient-elapsed: kind=signature through=0 values=531 -->

<!-- garden-reaped: 1 -->
<!-- garden-plain-retry-not-before: 2026-10-21T21:03:12Z -->
