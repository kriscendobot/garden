---
title: §"Regions, not raw terminal access" — abstraction over renderer
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

Design Decision 5 (lines 1068-1074):

> *Regions, not raw terminal access. The daemon never exposes cursor-move or SGR sequences. Doing so would bind the protocol to ANSI and preclude alternative renderers (Windows console, tmux control mode, remote web terminals). High-level region content is translated to whatever the renderer speaks.*

§First-explicit-observation in library: **§abstraction-over-renderer-as-named-design-discipline — §the-protocol-doesn't-expose-raw-terminal-bytes + §the-daemon-translates-region-content-to-whatever-the-renderer-speaks + §three-named-alternative-renderers (Windows console + tmux control mode + remote web terminals)**.

§Sibling-pattern to cycle 269's §reuse-protocol-but-not-implementation but applied differently — here it's §abstract-the-protocol-so-the-implementation-can-vary; §two-cycles-with-protocol-decoupling-disciplines-of-different-kinds (269 + 271).
