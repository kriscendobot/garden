---
slug: endor-tui-phase-1
repository: endo-but-for-bots
status: In Progress
size: M
milestone: M11
depends_on: []
pr: endo-but-for-bots#1525
created: 2026-10-22
updated: 2026-10-22
---

# endor-tui Phase 1: Skeleton and chat transcript

Phase 1 of [endor-tui](endor-tui.md) § Phased Implementation, which is the normative scope and acceptance; this record carries the size and dependency edges for the roadmap. Each phase is one builder PR on a frozen `llm-<sha>` base.

In flight as #1525 (`endor-tui-phase-1`): subcommand, async bus client with reconnect, single-space view, send/dismiss/adopt, modeline and modes (incl. focus mode and pending region), exit/redraw/SIGWINCH. Request/event payloads are provisional until Phase 2.
