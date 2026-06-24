---
title: §"Canvas regions are the escape hatch" — named escape hatch discipline
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
parent: endo-but-for-bots--llm-designs-endor-bus-tui--worker-facing-complement-to-endor-tui-and-three-layer-architecture-bus-verbs-plus-XS-handles-plus-Exo-wrapper-and-capability-mediated-TUI-and-state-at-daemon-verbs-at-worker
---

Design Decision 6:

> *Canvas regions are the escape hatch. When a worker genuinely needs cell-level control (an in-buffer cursor, a progress bar inside a line of text), `canvas` provides it without reintroducing terminal escape sequences. The cell packing format is still abstract: no ANSI, just `{char, fg, bg, attrs}`.*

§First-explicit-observation in library: **§named-escape-hatch-for-when-the-abstraction-doesn't-fit — §the-canvas-region-IS-the-escape-hatch-but-it-doesn't-reintroduce-ANSI + §the-escape-hatch-IS-its-own-abstraction-not-a-bypass**.

§The-cell-packing-format (`{char, fg, bg, attrs}`) — §abstract-cell-not-raw-byte; §the-escape-hatch-stays-within-the-design's-abstraction-discipline; §sibling-pattern to many systems' "raw mode" features that still go through a controlled API.
