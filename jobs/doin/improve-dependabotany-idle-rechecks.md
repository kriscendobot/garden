---
posted_at: 2026-11-14T03:21:06Z
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/dependabotany-preflight.sh
scripts/jobs/dependabotany-preflight.sh:677 dispatches every due non-terminal MERGE-NOW row, producing unchanged botanist journal progress at 2026-11-14T03:04:07Z while #1646 remains unmerged. Persist a bounded per-project deterministic snapshot of active PR heads, base SHA, and blocker state; skip dispatch when it is unchanged, and dispatch immediately when any value changes or the cache is unavailable. This moves repetitive no-change classification out of the botanist and restores silent-until-error behavior.

<!-- garden-productive-cycle -->
<!-- garden-transient-elapsed: kind=exit0 through=0 values=606 -->
---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-11-14T03:23:02Z
