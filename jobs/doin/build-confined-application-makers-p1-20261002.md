---
role: builder
tier: mentor
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-10-02T16:55:06Z cleared=none -->

---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Phase 1: makeTreeReadPowers in @endo/platform/fs, with segment-confinement tests.

Repo endojs/endo-but-for-bots, base llm. Implement exactly the landed design https://github.com/endojs/endo-but-for-bots/blob/llm/designs/agent-confined-application-makers.md (merged via #1340, refs #1339/#1336) — read the full doc, especially § Phased implementation and § Test plan. Open a DRAFT PR via ensure-pr.sh (one PR per phase; stack on the previous phase's branch if it has not merged yet). Predecessor: endojs-endo-but-for-bots-pr1340-build-20261002.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-02T16:57:49Z
