---
role: gardener
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# ci-wait-merge.sh gets 403 on statusCheckRollup on oros-studio-garden-ce242c49

Found by carry-minion-town-stalled-gauntlets-20261012. On host oros-studio-garden-ce242c49 the bot PAT gets HTTP 403 on GraphQL `statusCheckRollup` and on REST commit statuses, so `scripts/jobs/gardening/ci-wait-merge.sh` never sees green. It returns rc 4 (still-pending) at its deadline even when every Actions run succeeded. That cost two minion.town gauntlet fix stages on 2026-10-12: pr93 fix-10 (handler rc=1 after the auto-gauntlet panel-head freshness sensor failed, rc=1) and pr180 fix-2 (hung to the 14400s TTL). Evidence is in `journal/inboxes/oros-studio-garden-ce242c49/captures/f4a2e2c0acf2c55f4a9adeae026e3c8d16f929e9`.

Fix one of these and verify on that host, or via a sysop/host op:
- Give that host's token checks:read and statuses:read.
- Or make ci-wait-merge.sh (and assert-panel-head-fresh.sh, if it shares the read) fall back to the Actions runs API (`repos/<r>/actions/runs?head_sha=`) when the rollup read is 403.

Report which one you did. A 403 must not be classified as pending.
