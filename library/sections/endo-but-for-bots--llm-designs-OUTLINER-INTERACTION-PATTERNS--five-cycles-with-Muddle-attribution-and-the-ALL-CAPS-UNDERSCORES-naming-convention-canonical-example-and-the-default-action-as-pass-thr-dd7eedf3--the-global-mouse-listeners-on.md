---
title: §the-global-mouse-listeners-on-window-not-container (first-explicit-observation)
section-slug: endo-but-for-bots--llm-designs-OUTLINER-INTERACTION-PATTERNS--five-cycles-with-Muddle-attribution-and-the-ALL-CAPS-UNDERSCORES-naming-convention-canonical-example-and-the-default-action-as-pass-through-and-three-vertical-zones-and-double-rAF-for-mobile
source-slug: endo-but-for-bots--llm-designs-OUTLINER-INTERACTION-PATTERNS
url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/OUTLINER_INTERACTION_PATTERNS.md
authors: [Endo project (with attribution to Muddle project)]
status: (no explicit metadata table)
ingest-cycle: 285
ingest-date: 2026-06-10
lane: designs
scope: full
total-lines: 996
parent: endo-but-for-bots--llm-designs-OUTLINER-INTERACTION-PATTERNS--five-cycles-with-Muddle-attribution-and-the-ALL-CAPS-UNDERSCORES-naming-convention-canonical-example-and-the-default-action-as-pass-through-and-three-vertical-zones-and-double-rAF-for-mobile
---

> "**5. Global mouse listeners for drag operations.** Always attach mousemove and mouseup to `window` during drag. If you attach them to the container, the drag breaks when the mouse leaves the container boundary."

**§the-event-listener-attached-to-window-IS-the-drag-survival-mechanism** (first-explicit-observation): attaching to the container would limit drag-detection to within container bounds; attaching to window survives mouse-leave-container. This is **§the-listener-scope-IS-the-event-coverage-area** — a named browser-quirk-workaround.
