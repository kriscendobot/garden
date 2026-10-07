---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/rolling-deploy.sh
scripts/jobs/rolling-deploy.sh:144 treats rc=143 as a rejected candidate; journalctl 2026-10-07 15:56:04 shows a SIGTERM-interrupted origin fetch consequently suppressing retries for sha 0c64481407d9. Classify signal exits (143/130) as transient alongside GARDEN_OFFLINE_RC, without writing the rejected marker, and add regression coverage in rolling-deploy-test.sh.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 3
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-07T16:22:28Z
