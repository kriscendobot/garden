---
title: "`endor-bus-tui.md` — the worker-facing complement to cycle 269's `endor-tui.md`"
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

A 1148-line design. **Closes another design-to-design dual with cycle 269's `endor-tui.md`** — that design was the host-facing side ("This document references that surface rather than duplicating it"); this design is the worker-facing side ("the **internal** side of the TUI...The **external** side...is specified in the companion document `endor-tui.md`, which this design depends on and does not duplicate").

§First-explicit-observation in library: **§the-host-side-and-the-worker-side-of-the-same-subsystem-as-two-separate-designs-each-deferring-to-the-other — §the-non-duplication-promise-IS-symmetric + §each-side-defers-to-the-other + §the-two-designs-IS-the-canonical-shape-for-a-multi-party-protocol**.

§Two-cycles-with-host-side-and-worker-side-as-named-design-pair (269 endor-tui host + 271 endor-bus-tui worker); §two-cycles-with-symmetric-non-duplication-discipline (269 + 271; both directions of the deferral promise observed in the same week); §six-cycles-with-spec-and-instance-or-validator-and-constructor-or-host-and-worker-discipline-alignment (263 + 265 + 267 + 269 + 270 + 271).
