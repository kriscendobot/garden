---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
role: fixer
delegation: minion-town-pr-screening
# Heal minion.town production after merge 17e5b956aec2377dd94782fb31ec50a4634e267d
Merge 17e5b956aec2377dd94782fb31ec50a4634e267d (https://github.com/kriscendobot/minion.town/pull/220) broke production: deploy.yml failure.
Run: https://github.com/kriscendobot/minion.town/actions/runs/40186091316
Restore production by the cheapest correct route: a forward-fix PR or a revert PR of
17e5b956aec2377dd94782fb31ec50a4634e267d, against base main. Put this marker on its own line in the PR body:
<!-- garden-heal: 17e5b956aec2377dd94782fb31ec50a4634e267d -->
Open it with scripts/jobs/gardening/ensure-pr.sh and stage the ordinary gauntlet; the
proxy screens and merges a marked heal PR even while the delegation is paused. Never
push to main directly and never force-revert main.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-10-25T10:54:37Z
