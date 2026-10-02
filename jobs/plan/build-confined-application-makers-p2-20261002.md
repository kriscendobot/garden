---
gate: orchestrated
orchestrated_by: build-confined-application-makers-orch-20261002
priority: normal
posted_by: producer
posted_at: 2026-10-02T16:52:10Z
---

---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Phase 2: daemon capture for node-modules-with-map and node-modules-scan layouts, including the daemon canonical hook for mounts; EndoHost.makeFromTree gains layout and entry.

Repo endojs/endo-but-for-bots, base llm. Implement exactly the landed design https://github.com/endojs/endo-but-for-bots/blob/llm/designs/agent-confined-application-makers.md (merged via #1340, refs #1339/#1336) — read the full doc, especially § Phased implementation and § Test plan. Open a DRAFT PR via ensure-pr.sh (one PR per phase; stack on the previous phase's branch if it has not merged yet). Predecessor: endojs-endo-but-for-bots-pr1340-build-20261002.
