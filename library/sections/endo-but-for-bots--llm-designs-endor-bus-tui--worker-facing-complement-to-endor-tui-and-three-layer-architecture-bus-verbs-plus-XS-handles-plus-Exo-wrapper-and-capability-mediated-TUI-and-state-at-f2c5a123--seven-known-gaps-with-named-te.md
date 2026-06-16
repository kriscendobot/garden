---
title: §Seven Known Gaps with named technical concerns
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

Lines 1106-1133 carry §seven-named-Known-Gaps:

1. **Bidirectional text + combining characters + grapheme cluster widths** across region boundary.
2. **Image protocols** (Kitty, iTerm, Sixel) — out of scope; future `image` region role.
3. **Accessibility** — screen-reader annotations need orthogonal channel.
4. **Multi-screen arbitration** — multiple `screenId`s admitted but not specified.
5. **Persistence of window layout** across daemon restart — currently lost.
6. **Clipboard and selection** — could expose OSC 52-style verbs.
7. **Performance envelope** — no rate limits or backpressure for `drawCells`.

§First-explicit-observation in library: **§seven-named-Known-Gaps-IS-the-richest-Known-Gaps-section-cycle-ingested + §each-gap-IS-named-with-a-technical-concern-and-a-tentative-future-direction**.

§The-"future X-role could be added without protocol changes elsewhere" pattern (line 1115) — §the-protocol-IS-extensible-via-new-role-types-without-touching-existing-verbs; §sibling-pattern to cycle 268's tagged.js extensibility.
