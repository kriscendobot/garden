---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/post-gauntlet.sh
scripts/jobs/post-gauntlet.sh:167 deduplicates only by caller base; the 2026-10-05T23:07:57Z progress entry reports two concurrent gauntlets for PR #160. Add PR-keyed dedup via `gauntlet_record_for_pr` after each sync and before record creation, with a divergent-base race regression test.
