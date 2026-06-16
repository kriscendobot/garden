---
title: §The capability-mediated TUI architecture
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

Lines 36-41 carry the canonical statement:

> *The solution is a **capability-mediated TUI** in which the worker declares what it wants to render and the daemon produces the actual ANSI bytes on the user's terminal. Events flow the other direction: the daemon decodes keyboard, mouse, and resize events and forwards them to whichever worker owns the region that currently has focus.*

§First-explicit-observation in library: **§the-capability-mediated-TUI-architecture — §the-worker-declares-what-it-wants-to-render + §the-daemon-produces-the-actual-ANSI-bytes + §events-flow-the-other-direction + §the-daemon-routes-events-to-the-region-with-focus**.

§Two-asymmetric-flows:
- §**Render-flow** — worker → daemon (worker declares; daemon renders).
- §**Event-flow** — daemon → worker (daemon decodes; worker reacts).

§the-asymmetry-IS-load-bearing — §the-confinement-discipline-precludes-the-worker-from-touching-the-terminal-directly + §the-daemon-IS-the-mediator-for-both-directions; §sibling-pattern to cycle 269's §the-debugger-mediation-discipline; §two-cycles-with-daemon-mediates-X-where-X-IS-a-platform-resource (269 debugger-traffic + 271 TUI-rendering-and-events).
