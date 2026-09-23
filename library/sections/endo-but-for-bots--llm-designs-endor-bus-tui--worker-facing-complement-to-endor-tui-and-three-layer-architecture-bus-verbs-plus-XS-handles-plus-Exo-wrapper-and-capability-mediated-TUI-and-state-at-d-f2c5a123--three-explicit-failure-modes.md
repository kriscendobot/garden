---
title: §Three explicit failure modes
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

Design Decision 10:

> *Failure modes are explicit. `window-revoked`, `screen-lost`, and `wrong-role` are first-class error codes. The worker is expected to handle each; the Exo wrapper surfaces `whenRevoked` as a dedicated promise so code can race it against its own main loop.*

§Three-named-error-codes:
1. **`window-revoked`** — the daemon revoked the window.
2. **`screen-lost`** — the screen was lost (TUI process terminated).
3. **`wrong-role`** — the worker tried to use a region with a role it doesn't have.

§First-explicit-observation in library: **§three-named-failure-modes-as-first-class-error-codes (window-revoked + screen-lost + wrong-role) — §each-failure-mode-IS-a-named-protocol-event-the-worker-must-handle + §the-Exo-wrapper-surfaces-them-as-`whenRevoked`-promise-for-racing-against-the-main-loop**.

§The-`whenRevoked`-dedicated-promise — §the-promise-IS-the-canonical-mechanism-for-cancel-style-events; §sibling-pattern to many cancellation-token systems.
