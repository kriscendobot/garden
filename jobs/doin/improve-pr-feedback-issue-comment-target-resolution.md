---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/gardening/pr-feedback-preflight.sh
Resolve PR conversation-comment IDs through the issues-comments API in addition to review and inline-comment APIs, and build the appropriate evidence metadata. The current preflight queries an issue-comment ID on the wrong surfaces and fails open.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 3
  worker_kind: gardener
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-06T06:51:10Z
