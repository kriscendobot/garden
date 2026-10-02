---
gate: go-ahead
priority: normal
role: builder
tier: mentor
token-budget: 250000
doomed: true
doom_signature: requeue-exhausted
doom_count: 1
split_eligible: true
split_reason: repeated-plain-exit
failure_classification: transient
requeue_cycles: 2
deadline_overruns: 0
elapsed_constancy_confirmations: 0
doomed_at: 2026-10-02T18:43:08Z
doomed_on: endolin-garden-ece02cb4
posted_by: reaper:endolin-garden-ece02cb4
posted_at: 2026-10-02T18:43:08Z
---

---
role: builder
tier: mentor
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-10-02T17:04:05Z cleared=none -->

---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Phase 2: daemon capture for node-modules-with-map and node-modules-scan layouts, including the daemon canonical hook for mounts; EndoHost.makeFromTree gains layout and entry.

Repo endojs/endo-but-for-bots, base llm. Implement exactly the landed design https://github.com/endojs/endo-but-for-bots/blob/llm/designs/agent-confined-application-makers.md (merged via #1340, refs #1339/#1336) — read the full doc, especially § Phased implementation and § Test plan. Open a DRAFT PR via ensure-pr.sh (one PR per phase; stack on the previous phase's branch if it has not merged yet). Predecessor: endojs-endo-but-for-bots-pr1340-build-20261002.
