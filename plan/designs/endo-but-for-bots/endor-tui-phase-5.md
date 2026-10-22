---
slug: endor-tui-phase-5
repository: endo-but-for-bots
status: Not Started
size: L
milestone: M11
depends_on: [endor-tui-phase-2, daemon-xs-worker-debugger]
created: 2026-10-22
updated: 2026-10-22
---

# endor-tui Phase 5: XS debugger baseline

Phase 5 of [endor-tui](endor-tui.md) § Phased Implementation, which is the normative scope and acceptance; this record carries the size and dependency edges for the roadmap. Each phase is one builder PR on a frozen `llm-<sha>` base.

Worker list, attach/detach via the Debugger exo (lands daemon-xs-worker-debugger's remaining host-exposed attachDebugger and followBreaks if not already landed), stop events with frame/stack/locals, go/step/step-over/step-out, session-scoped unconditional breakpoints.
