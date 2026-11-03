---
posted_at: 2026-11-03T19:20:52Z
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/gardener.sh
gardener.sh:1327 reserves rc=76 (GARDEN_HANDOFF_UNVERIFIED_RC) for complete-job. At 07:00:10Z the weave handler for kriscendobot-minion.town-pr199-weave-20261103 also exited rc=76 and was classed as a generic handler FAILED. After a retry that exited rc=75 after 18s, the job was doomed requeue-exhausted at 07:33:05Z, even though the force-push and base move had already landed at 06:33:29Z. Before requeueing or dooming an ordinary job whose handler exits 75/76, check for a durable post-condition (the pushed head equals the expected SHA, or the gauntlet was already staged). If it holds, run complete-job instead of leaving the job in doin for the reaper. Alternatively, make the handler's rc namespace distinct from complete-job's.

---
claim:
  host: oros-studio-garden-ce242c49
  gardener: 3
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-11-03T19:27:24Z
