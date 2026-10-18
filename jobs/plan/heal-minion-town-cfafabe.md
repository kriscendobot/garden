---
gate: go-ahead
priority: normal
role: fixer
tier: minion
token-budget: 100000
doomed: true
doom_signature: requeue-exhausted
doom_count: 1
split_eligible: true
split_reason: repeated-plain-exit
failure_classification: deterministic
requeue_cycles: 2
deadline_overruns: 0
elapsed_constancy_confirmations: 0
doomed_at: 2026-10-18T14:13:15Z
doomed_on: endolin-garden-ece02cb4
posted_by: reaper:endolin-garden-ece02cb4
posted_at: 2026-10-18T14:13:15Z
---

---
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
role: fixer
delegation: minion-town-pr-screening
# Heal minion.town production after merge cfafabea5a93f0d270980d4b468841c0565b3a3a
Merge cfafabea5a93f0d270980d4b468841c0565b3a3a (https://github.com/kriscendobot/minion.town/pull/197) broke production: deploy.yml failure.
Run: https://github.com/kriscendobot/minion.town/actions/runs/39126464564
Restore production by the cheapest correct route: a forward-fix PR or a revert PR of
cfafabea5a93f0d270980d4b468841c0565b3a3a, against base main. Put this marker on its own line in the PR body:
<!-- garden-heal: cfafabea5a93f0d270980d4b468841c0565b3a3a -->
Open it with scripts/jobs/gardening/ensure-pr.sh and stage the ordinary gauntlet; the
proxy screens and merges a marked heal PR even while the delegation is paused. Never
push to main directly and never force-revert main.
