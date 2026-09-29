---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/gardener.sh
`scripts/jobs/gardener.sh:1190` treats a nonzero handler result as failure even when its report ends in a durable successor handoff. At 2026-09-29T17:48:16Z, `activate-ironhorse-ratchet-autopilot-20260929-r4` named queued `...-r5` yet was left for reaping. Before the failure path, verify the report’s handoff marker against board/schedule state and terminalize the source with `complete-job.sh --handed-off`, preserving retries for unverified handoffs.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-29T17:53:34Z
