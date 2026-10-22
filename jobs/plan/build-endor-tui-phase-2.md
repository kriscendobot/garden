---
gate: awaiting-maintainer
maintainer_question: 'endor-tui Phase 2: minimal Rust CapTP client over the existing socket (recommended) or a manager-side adapter serving the bus-verb table?'
asked_at: https://github.com/endojs/endo-but-for-bots/pull/1526
priority: normal
posted_by: builder
posted_at: 2026-10-22T05:16:55Z
---

---
role: builder
arc: moonshots
dispatch: automatic
tier: mentor
fallback-tier: minion
---
# Build: endor-tui Phase 2 (chat data path) from the design in endojs/endo-but-for-bots#1526

Repo: https://github.com/endojs/endo-but-for-bots. Design PR: https://github.com/endojs/endo-but-for-bots/pull/1526.

Successor of `build-endor-tui-phase-breakdown-open-pr`, which stopped without building because the maintainer had not answered the design's Phase 2 open question.

Scope: endor-tui **Phase 2 only** (plan record endor-tui-phase-2, size L, depends_on endor-tui-phase-1 = https://github.com/endojs/endo-but-for-bots/pull/1525). Phases 3-8 are separate later builds.

Before building: confirm the maintainer's answer to the first Open question on https://github.com/endojs/endo-but-for-bots/pull/1526 (or in this job's inbox): (a) a minimal Rust CapTP client over the existing socket (recommended), or (b) a manager-side adapter serving the bus-verb table (needs its own spec first, since endor-bus-tui does not define the chat verbs). Build what was chosen. Build on Phase 1's rust/endo/src/tui/ (weave onto the Phase 1 branch, or wait for it to merge). Open a DRAFT PR via ensure-pr.sh; completion stages its gauntlet. Report a gap rather than weaken a property the design requires.
