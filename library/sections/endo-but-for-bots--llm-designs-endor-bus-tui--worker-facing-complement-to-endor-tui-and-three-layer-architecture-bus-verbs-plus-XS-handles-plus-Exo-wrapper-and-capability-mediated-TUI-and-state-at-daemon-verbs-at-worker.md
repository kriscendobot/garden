---
title: "endor-bus-tui.md — worker-facing complement to endor-tui + three-layer architecture (bus verbs + XS handles + Exo wrapper) + capability-mediated TUI + state-at-daemon-verbs-at-worker + ten Design Decisions"
source-slug: endo-but-for-bots--llm-designs-endor-bus-tui
section-slug: worker-facing-complement-to-endor-tui-and-three-layer-architecture-bus-verbs-plus-XS-handles-plus-Exo-wrapper-and-capability-mediated-TUI-and-state-at-daemon-verbs-at-worker
source-url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/endor-bus-tui.md
source-repo: endojs/endo-but-for-bots
source-path: designs/endor-bus-tui.md
source-author: Kris Kowal (prompted)
total-lines: 1148
ingest-cycle: 271
ingest-date: 2026-06-10
lane: designs
scope: structural-pattern-observations
kind: index
section_count: 21
---

Sections:

- [`endor-bus-tui.md` — the worker-facing complement to cycle 269's `endor-tui.md`](endo-but-for-bots--llm-designs-endor-bus-tui--worker-facing-complement-to-endor-tui-and-three-layer-architecture-bus-verbs-plus-XS-handles-plus-Exo-wrapper-and-capability-mediated-TUI-and-state-at-f2c5a123--endor-bus-tui-md-the-worker-fa.md)
- [§The capability-mediated TUI architecture](endo-but-for-bots--llm-designs-endor-bus-tui--worker-facing-complement-to-endor-tui-and-three-layer-architecture-bus-verbs-plus-XS-handles-plus-Exo-wrapper-and-capability-mediated-TUI-and-state-at-f2c5a123--the-capability-mediated-tui-ar.md)
- [§The "confinement is the whole point" acknowledgment](endo-but-for-bots--llm-designs-endor-bus-tui--worker-facing-complement-to-endor-tui-and-three-layer-architecture-bus-verbs-plus-XS-handles-plus-Exo-wrapper-and-capability-mediated-TUI-and-state-at-f2c5a123--the-confinement-is-the-whole-p.md)
- [§Three layers, not one — the explicit layering rationale](endo-but-for-bots--llm-designs-endor-bus-tui--worker-facing-complement-to-endor-tui-and-three-layer-architecture-bus-verbs-plus-XS-handles-plus-Exo-wrapper-and-capability-mediated-TUI-and-state-at-f2c5a123--three-layers-not-one-the-expli.md)
- [§"State at the daemon, verbs at the worker" — the source-of-truth discipline](endo-but-for-bots--llm-designs-endor-bus-tui--worker-facing-complement-to-endor-tui-and-three-layer-architecture-bus-verbs-plus-XS-handles-plus-Exo-wrapper-and-capability-mediated-TUI-and-state-at-f2c5a123--state-at-the-daemon-verbs-at-t.md)
- [§"Line numbers, not pointers, for buffer edits" — deterministic ID discipline](endo-but-for-bots--llm-designs-endor-bus-tui--worker-facing-complement-to-endor-tui-and-three-layer-architecture-bus-verbs-plus-XS-handles-plus-Exo-wrapper-and-capability-mediated-TUI-and-state-at-f2c5a123--line-numbers-not-pointers-for.md)
- [§"Regions, not raw terminal access" — abstraction over renderer](endo-but-for-bots--llm-designs-endor-bus-tui--worker-facing-complement-to-endor-tui-and-three-layer-architecture-bus-verbs-plus-XS-handles-plus-Exo-wrapper-and-capability-mediated-TUI-and-state-at-f2c5a123--regions-not-raw-terminal-acces.md)
- [§Ten numbered Design Decisions](endo-but-for-bots--llm-designs-endor-bus-tui--worker-facing-complement-to-endor-tui-and-three-layer-architecture-bus-verbs-plus-XS-handles-plus-Exo-wrapper-and-capability-mediated-TUI-and-state-at-f2c5a123--ten-numbered-design-decisions.md)
- [§"Canvas regions are the escape hatch" — named escape hatch discipline](endo-but-for-bots--llm-designs-endor-bus-tui--worker-facing-complement-to-endor-tui-and-three-layer-architecture-bus-verbs-plus-XS-handles-plus-Exo-wrapper-and-capability-mediated-TUI-and-state-at-f2c5a123--canvas-regions-are-the-escape.md)
- [§"No cross-window z-order in the bus" — agents don't fight for foreground](endo-but-for-bots--llm-designs-endor-bus-tui--worker-facing-complement-to-endor-tui-and-three-layer-architecture-bus-verbs-plus-XS-handles-plus-Exo-wrapper-and-capability-mediated-TUI-and-state-at-f2c5a123--no-cross-window-z-order-in-the.md)
- [§Three explicit failure modes](endo-but-for-bots--llm-designs-endor-bus-tui--worker-facing-complement-to-endor-tui-and-three-layer-architecture-bus-verbs-plus-XS-handles-plus-Exo-wrapper-and-capability-mediated-TUI-and-state-at-d-f2c5a123--three-explicit-failure-modes.md)
- [§Five numbered Phases](endo-but-for-bots--llm-designs-endor-bus-tui--worker-facing-complement-to-endor-tui-and-three-layer-architecture-bus-verbs-plus-XS-handles-plus-Exo-wrapper-and-capability-mediated-TUI-and-state-at-daemon-ve-f2c5a123--five-numbered-phases.md)
- [§Four-row Dependencies table — much smaller than cycle 269's twelve](endo-but-for-bots--llm-designs-endor-bus-tui--worker-facing-complement-to-endor-tui-and-three-layer-architecture-bus-verbs-plus-XS-handles-plus-Exo-wrapper-and-capability-mediated-TUI-and-state-at-f2c5a123--four-row-dependencies-table-mu.md)
- [§Seven Known Gaps with named technical concerns](endo-but-for-bots--llm-designs-endor-bus-tui--worker-facing-complement-to-endor-tui-and-three-layer-architecture-bus-verbs-plus-XS-handles-plus-Exo-wrapper-and-capability-mediated-TUI-and-state-at-f2c5a123--seven-known-gaps-with-named-te.md)
- [§Cycle 271 first-explicit-observations roundup (twelve)](endo-but-for-bots--llm-designs-endor-bus-tui--worker-facing-complement-to-endor-tui-and-three-layer-architecture-bus-verbs-plus-XS-handles-plus-Exo-wrapper-and-capability-mediated-TUI-and-state-at-f2c5a123--cycle-271-first-explicit-obser.md)
- [§Recurring meta-pattern counters bumped at cycle 271](endo-but-for-bots--llm-designs-endor-bus-tui--worker-facing-complement-to-endor-tui-and-three-layer-architecture-bus-verbs-plus-XS-handles-plus-Exo-wrapper-and-capability-mediated-TUI-and-state-at-f2c5a123--recurring-meta-pattern-counter.md)
- [§Synthesis target — slot machine library](endo-but-for-bots--llm-designs-endor-bus-tui--worker-facing-complement-to-endor-tui-and-three-layer-architecture-bus-verbs-plus-XS-handles-plus-Exo-wrapper-and-capability-mediated-TUI-and-state-at-f2c5a123--synthesis-target-slot-machine.md)
- [§Tier-1 borrowing](endo-but-for-bots--llm-designs-endor-bus-tui--worker-facing-complement-to-endor-tui-and-three-layer-architecture-bus-verbs-plus-XS-handles-plus-Exo-wrapper-and-capability-mediated-TUI-and-state-at-daemon-verbs-at-worker--tier-1-borrowing.md)
- [§Tier-2 borrowing](endo-but-for-bots--llm-designs-endor-bus-tui--worker-facing-complement-to-endor-tui-and-three-layer-architecture-bus-verbs-plus-XS-handles-plus-Exo-wrapper-and-capability-mediated-TUI-and-state-at-daemon-verbs-at-worker--tier-2-borrowing.md)
- [§Tier-3 borrowing](endo-but-for-bots--llm-designs-endor-bus-tui--worker-facing-complement-to-endor-tui-and-three-layer-architecture-bus-verbs-plus-XS-handles-plus-Exo-wrapper-and-capability-mediated-TUI-and-state-at-daemon-verbs-at-worker--tier-3-borrowing.md)
- [Pattern summary (tag-prefixed)](endo-but-for-bots--llm-designs-endor-bus-tui--worker-facing-complement-to-endor-tui-and-three-layer-architecture-bus-verbs-plus-XS-handles-plus-Exo-wrapper-and-capability-mediated-TUI-and-state-at-d-f2c5a123--pattern-summary-tag-prefixed.md)
