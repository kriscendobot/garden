---
title: §Cycle 271 first-explicit-observations roundup (twelve)
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

1. **§the-host-side-and-the-worker-side-of-the-same-subsystem-as-two-separate-designs-each-deferring-to-the-other**.
2. **§the-capability-mediated-TUI-architecture** (worker-declares + daemon-renders; two asymmetric flows).
3. **§five-named-non-exposures-as-named-confinement-discipline-for-XS-workers** (no FD + no stdout + no controlling terminal + no TTY size/mode + no ANSI escapes).
4. **§the-"this-is-by-design"-acknowledgment-as-named-design-motivation** — confinement is the whole point.
5. **§three-layers-not-one-as-named-design-rationale** — wire protocol + local convenience + capability model.
6. **§a-decision-that-rules-out-two-alternatives-before-naming-the-chosen-approach** (X-over-Y-and-Z-because-W).
7. **§state-at-the-daemon-verbs-at-the-worker** as named source-of-truth discipline.
8. **§named-reference-to-an-existing-pattern-as-design-rationale-rather-than-inventing-a-new-discipline**.
9. **§deterministic-ID-discipline** — line numbers, not pointers, for buffer edits.
10. **§abstraction-over-renderer-as-named-design-discipline** — regions, not raw terminal access.
11. **§five-named-`@`-prefix-system-pet-names-listed-in-one-place** + §the-cluster-now-has-six-named-`@`-prefix-system-pet-names-counting-`@tui-screen`.
12. **§named-escape-hatch-for-when-the-abstraction-doesn't-fit** — Canvas regions.

Plus: §the-no-fighting-for-foreground-discipline + §three-named-failure-modes-as-first-class-error-codes + §a-design-decision-named-"agents-do-not-fight-for-foreground" + §the-Dependencies-table-size-correlates-with-the-design's-fan-in-not-its-complexity + §seven-named-Known-Gaps + §two-cycles-with-host-side-and-worker-side-as-named-design-pair + §two-cycles-with-symmetric-non-duplication-discipline.
