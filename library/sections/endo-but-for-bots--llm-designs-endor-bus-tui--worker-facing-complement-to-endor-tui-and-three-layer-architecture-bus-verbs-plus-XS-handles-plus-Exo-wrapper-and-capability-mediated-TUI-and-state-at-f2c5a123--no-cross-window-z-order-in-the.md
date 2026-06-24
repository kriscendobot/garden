---
title: §"No cross-window z-order in the bus" — agents don't fight for foreground
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

Design Decision 9:

> *No cross-window z-order in the bus. The layout engine owns stacking. A worker requests a `dock: 'float'` window and accepts whatever stacking order the daemon assigns. Agents do not fight for foreground.*

§First-explicit-observation in library: **§the-no-fighting-for-foreground-discipline — §when-multiple-workers-could-request-foreground, §the-protocol-DOESN'T-expose-stacking-order-as-a-worker-controllable-property + §the-daemon-IS-the-policy-authority + §agents-accept-whatever-the-daemon-assigns**.

§Sibling-pattern to capability-systems' principle-of-least-authority — §the-worker-doesn't-need-to-control-stacking + §the-daemon-can-implement-fair-policy-without-cooperation-from-workers.

§First-explicit-observation in library: **§a-design-decision-named-"agents-do-not-fight-for-foreground"-encodes-the-no-fighting-for-resources-discipline-explicitly**.
