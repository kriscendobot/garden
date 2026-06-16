---
title: §Three layers, not one — the explicit layering rationale
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

Lines 43-77 name §three-layers:

1. **Layer 1: Bus protocol verbs** — wire protocol (CBOR envelope bus); serializable + versioned + survives worker restart.
2. **Layer 2: XS handle API** — small JavaScript module; local JS convenience; per-worker state (pending draw buffers + event subscriptions); §NOT-capability-safe-by-itself.
3. **Layer 3: Exo-based CapTP wrapper** — `makeExo` remotables with `M.interface` method guards; the capability model; §delegatable + revocable + storable-in-pet-store.

§First-explicit-observation in library: **§three-layers-not-one-as-named-design-rationale — §each-layer-solves-a-different-problem (wire-protocol + local-convenience + capability-model) + §a-direct-Exo-only-API-would-couple-the-bus-protocol-to-the-capability-model-and-preclude-non-Exo-users**.

§Design Decision 1 (line 1041) makes the rationale explicit:

> *Three layers, not one. A direct Exo-only API would couple the bus protocol to the capability model and preclude non-Exo users (internal tooling, tests) from driving the TUI. A bus-only API would force every consumer to re-implement the handle bookkeeping. Three layers let each do one job.*

§The-X-over-Y-because-Z-rationale-shape from cycle 269 instantiated here three times in one decision; §the-design-explicitly-rules-out-two-alternatives-before-naming-the-chosen-three-layer-approach.

§First-explicit-observation in library: **§a-decision-that-rules-out-two-alternatives-before-naming-the-chosen-approach — §the-X-over-Y-and-Z-because-W-pattern + §when-a-design-faces-three-or-more-alternatives, §rule-out-the-non-chosen-ones-explicitly-rather-than-just-naming-the-chosen-one**.
