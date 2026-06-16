---
title: §Ten numbered Design Decisions
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

Lines 1039-1104 carry §ten-numbered-Design-Decisions (one fewer than cycle 269's eleven):

1. **Three layers, not one** — §the-X-over-Y-and-Z-because-W-rationale.
2. **State at the daemon, verbs at the worker** — §source-of-truth-discipline.
3. **Line numbers, not pointers, for buffer edits** — §deterministic-ID-discipline.
4. **Events are fire-and-forget envelopes with subscription IDs** — §reuse-existing-bus-primitives.
5. **Regions, not raw terminal access** — §abstraction-over-renderer.
6. **Canvas regions are the escape hatch** — §named-escape-hatch-for-when-the-abstraction-doesn't-fit.
7. **Exo wrapper is optional** — §the-Exos-exist-specifically-for-delegation-and-capability-storage-not-as-the-on-ramp.
8. **The `@tui-screen` reserved name** — §named-pet-name-conventions (cycle 250's @-prefix pattern + cycle 257's @-prefix pet-name observation).
9. **No cross-window z-order in the bus** — §the-no-fighting-for-foreground discipline.
10. **Failure modes are explicit** — §three-named-error-codes (window-revoked + screen-lost + wrong-role).

§The-five-named-`@`-prefix-system-pet-names (line 1088-1089): `@agent` + `@self` + `@host` + `@keypair` + `@mail` — §sibling-pattern to cycle 250's @-prefix observation and cycle 257's @host observation; §three-cycles-with-named-`@`-prefix-system-pet-name-convention (250 + 257 + 271); §the-`@tui-screen`-name-IS-the-sixth-known-member-of-the-convention.

§First-explicit-observation in library: **§five-named-`@`-prefix-system-pet-names-listed-in-one-place + §the-cluster-now-has-six-named-`@`-prefix-system-pet-names-counting-`@tui-screen`**.
