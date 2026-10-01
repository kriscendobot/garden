---
role: builder
tier: mentor
---
<!-- garden-promoted-from-plan: gate=blocked priority=normal at=2026-10-01T08:46:37Z cleared=none -->

---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Build: prune the confined tool catalog at the guest broker

Repo: endojs/endo-but-for-bots, base `llm` (after #1371 merges).
Requested by kriskowal's approving review on #1371 ("conduct and build"):
https://github.com/endojs/endo-but-for-bots/pull/1371#pullrequestreview-5375148317 — this builds a named follow-up from
#1371's live-turn evidence comment (https://github.com/endojs/endo-but-for-bots/pull/1371, "Named follow-ups", item 2).

`startGuestBroker` (@endo/agent-mcp-stdio) serves the full guest catalog; only claude's `--allowedTools` withholds `evaluate`/`define`, so `init.tools` still lists them and the README claim "absent at the boundary" does not hold. Make the broker serve (and enforce at call time) only the confined allow-list, so pruned names never reach the confined side. Coordinate with job endojs-endo-but-for-bots-pr1371-3ab5ee33 (removing identifier/locator production+consumption from guests) on storeIdentifier/storeLocator/internalizeContentLocator.

Open a DRAFT PR via ensure-pr.sh; cross-link #1371.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-01T10:28:40Z
