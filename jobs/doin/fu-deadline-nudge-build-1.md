---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
In the garden's own repo (kriscendobot/garden, `main2`), reconcile the `pre-push-gates` skill contract with reality: the documented driver `scripts/jobs/gardening/pre-push-gates.sh` referenced by `skills/pre-push-gates/SKILL.md` does not exist. Either restore the driver script or update the skill (and any roles referencing it) to describe the actual gate procedure workers should run, then push directly to `main2`.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 4
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-08-10T23:38:21Z
