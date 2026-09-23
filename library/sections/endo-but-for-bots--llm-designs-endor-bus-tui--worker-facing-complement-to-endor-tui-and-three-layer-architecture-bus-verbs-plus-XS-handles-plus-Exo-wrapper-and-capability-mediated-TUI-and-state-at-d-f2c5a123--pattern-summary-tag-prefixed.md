---
title: Pattern summary (tag-prefixed)
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

§worker-facing-complement-to-cycle-269's-endor-tui + §the-host-side-and-the-worker-side-of-the-same-subsystem-as-two-separate-designs-each-deferring-to-the-other + §the-capability-mediated-TUI-architecture + §two-asymmetric-flows (render-flow worker→daemon + event-flow daemon→worker) + §five-named-non-exposures-as-named-confinement-discipline (no FD + no stdout + no controlling terminal + no TTY size/mode + no ANSI escapes) + §the-"this-is-by-design"-acknowledgment + §three-layers-not-one (bus verbs + XS handles + Exo wrapper) + §each-layer-solves-a-different-problem + §a-decision-that-rules-out-two-alternatives-before-naming-the-chosen-approach + §state-at-the-daemon-verbs-at-the-worker + §named-reference-to-an-existing-pattern + §deterministic-ID-discipline (line numbers, not pointers) + §abstraction-over-renderer (regions, not raw terminal access) + §three-named-alternative-renderers (Windows console + tmux control mode + remote web terminals) + §named-escape-hatch (Canvas regions) + §abstract-cell-format (`{char, fg, bg, attrs}`) + §the-no-fighting-for-foreground-discipline + §three-named-failure-modes-as-first-class-error-codes (window-revoked + screen-lost + wrong-role) + §`whenRevoked`-dedicated-promise + §five-named-`@`-prefix-system-pet-names + §three-cycles-with-named-`@`-prefix-system-pet-name-convention (250 + 257 + 271) + §ten-numbered-Design-Decisions + §five-numbered-Phases + §four-row-Dependencies-table + §seven-named-Known-Gaps + §the-extensible-protocol-via-new-role-types-without-touching-existing-verbs + §six-cycles-with-spec-and-instance-or-validator-and-constructor-or-host-and-worker-discipline-alignment.
