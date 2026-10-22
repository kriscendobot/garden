---
slug: endor-tui-phase-2
repository: endo-but-for-bots
status: Not Started
size: L
milestone: M11
depends_on: [endor-tui-phase-1]
created: 2026-10-22
updated: 2026-10-22
---

# endor-tui Phase 2: Chat data path

Phase 2 of [endor-tui](endor-tui.md) § Phased Implementation, which is the normative scope and acceptance; this record carries the size and dependency edges for the roadmap. Each phase is one builder PR on a frozen `llm-<sha>` base.

Replace #1525's provisional payloads with a path the daemon serves, for the Phase 1 surface. Recommended: a minimal Rust CapTP client over the existing socket (the `endo` CLI path); alternative: a manager-side adapter serving the bus-verb table. Gated on the design's first open question.
