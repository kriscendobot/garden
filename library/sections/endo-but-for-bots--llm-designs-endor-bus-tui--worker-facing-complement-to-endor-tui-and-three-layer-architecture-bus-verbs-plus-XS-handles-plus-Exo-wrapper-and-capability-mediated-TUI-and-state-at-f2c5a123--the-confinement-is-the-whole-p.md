---
title: §The "confinement is the whole point" acknowledgment
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

Lines 20-25 name the underlying constraint:

> *XS workers are confined JavaScript processes. They cannot write to a file descriptor they were not given. They have no access to `stdout`, no access to the controlling terminal, no knowledge of the TTY's size or mode, and no way to produce ANSI escape sequences that would reach the user. **This is by design: confinement is the whole point.***

§Five-named-non-exposures:
1. **No file descriptor they were not given**.
2. **No access to `stdout`**.
3. **No access to the controlling terminal**.
4. **No knowledge of the TTY's size or mode**.
5. **No way to produce ANSI escape sequences**.

§First-explicit-observation in library: **§five-named-non-exposures-as-named-confinement-discipline-for-XS-workers — §sibling-pattern to cycle 259's three-named-non-exposures-on-Page-interface and cycle 261's three-named-non-exposures-on-HttpClient**.

§The-"this-is-by-design-confinement-is-the-whole-point"-acknowledgment — §the-design-NAMES-the-constraint-rather-than-treating-it-as-a-problem; §the-named-non-exposures-IS-the-feature-not-the-limitation; §three-cycles-with-named-non-exposures-as-design-feature-not-limitation (259 + 261 + 271); §first-explicit-observation in library of §the-"this-is-by-design"-acknowledgment-as-named-design-motivation.
