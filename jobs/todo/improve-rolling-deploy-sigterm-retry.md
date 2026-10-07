---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/rolling-deploy.sh
scripts/jobs/rolling-deploy.sh:144 treats rc=143 as a rejected candidate; journalctl 2026-10-07 15:56:04 shows a SIGTERM-interrupted origin fetch consequently suppressing retries for sha 0c64481407d9. Classify signal exits (143/130) as transient alongside GARDEN_OFFLINE_RC, without writing the rejected marker, and add regression coverage in rolling-deploy-test.sh.
