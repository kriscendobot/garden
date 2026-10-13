---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/rolling-deploy.sh
scripts/jobs/rolling-deploy.sh:731 discards failed remote drain dispatches; the 2026-10-13T08:12:13Z result reports two unacked Oros drain ops while its control bridge was unreachable. Persist and poll each pre-drain op’s sysop-log acknowledgement before releasing or validating that canary; after a bounded timeout halt the roll and send one deduplicated maintainer alert.
