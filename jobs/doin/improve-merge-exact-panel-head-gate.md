---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/gardening/ci-wait-merge.sh
Defect: `scripts/jobs/gardening/ci-wait-merge.sh:800-830` admits a merge after review-decision and maintainer-approval checks without enforcing exact panel-head coverage; prosecutor entries at 2026-10-24T03:22:39Z and 03:28:24Z record unpanelled successor heads entering conduct after halted gauntlets.
Before merging, invoke `assert-panel-head-fresh.sh pr --require-reviewed-head` and fail closed on stale, absent, or unreadable coverage, alerting the maintainer and leaving the conductor claimable.
Add focused tests for equal-head admission and stale, missing, and unreadable panel coverage refusal.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-10-24T03:51:40Z
