---
slug: endor-tui-phase-7
repository: endo-but-for-bots
status: Not Started
size: M
milestone: M11
depends_on: [endor-tui-phase-5]
created: 2026-10-22
updated: 2026-10-22
---

# endor-tui Phase 7: Durable breakpoints and controller claim

Phase 7 of [endor-tui](endor-tui.md) § Phased Implementation, which is the normative scope and acceptance; this record carries the size and dependency edges for the roadmap. Each phase is one builder PR on a frozen `llm-<sha>` base.

Manager-held breakpoints reapplied on attach (survive TUI restart; stop with no TUI attached); multi-client observers with one claimed controller, released on disconnect.
