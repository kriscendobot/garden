---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/handlers/follow-up-claude.sh
Add a declarative, deterministic design-to-build recheck directive that reads only GitHub PR/timeline metadata, posts the fixed follow-up when a build appears, re-arms the once schedule when it does not, and messages on closed-unmerged. This recurring sentinel has repeatedly exhausted agent attempts without a completion signal; its three outcomes are scriptable and should not depend on an agent.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-08-21T22:50:56Z
