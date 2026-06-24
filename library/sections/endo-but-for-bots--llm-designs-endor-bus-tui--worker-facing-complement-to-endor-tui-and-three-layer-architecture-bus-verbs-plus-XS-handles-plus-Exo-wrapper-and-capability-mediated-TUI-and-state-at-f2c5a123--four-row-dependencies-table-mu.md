---
title: §Four-row Dependencies table — much smaller than cycle 269's twelve
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

Lines 982-989 carry §four-row Dependencies:
- **endor-tui.md** — host side of the same subsystem (the explicit non-duplication partner).
- **daemon-engo-supervisor.md** — the CBOR envelope bus.
- **daemon-value-message.md** — `sendValue` for cross-agent advertisement.
- **workers-panel.md** — itself a TUI consumer.

§First-explicit-observation in library: **§the-Dependencies-table-size-correlates-with-the-design's-fan-in-not-its-complexity — §endor-bus-tui-has-substantially-more-content-than-endor-tui-but-only-a-third-the-Dependencies-table-because-the-design-is-more-self-contained**.

§The-design's-substantial-content-IS-its-internal-vocabulary (bus verbs + XS handle methods + Exo interfaces) rather than dependencies on prior designs; §a-design's-fan-in-and-its-complexity-are-different-axes.
