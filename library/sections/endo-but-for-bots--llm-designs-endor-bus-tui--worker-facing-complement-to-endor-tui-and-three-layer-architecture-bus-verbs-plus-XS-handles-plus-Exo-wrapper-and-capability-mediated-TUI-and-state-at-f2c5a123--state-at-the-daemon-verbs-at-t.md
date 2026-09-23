---
title: §"State at the daemon, verbs at the worker" — the source-of-truth discipline
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

Design Decision 2 (lines 1048-1054):

> *State at the daemon, verbs at the worker. The bus protocol is imperative ("setText", "appendLines") because workers emit a stream of small updates, but the daemon keeps full state for reattach and recompose. This mirrors the existing message-hub pattern where the daemon is the source of truth for message identity even though workers produce messages.*

§First-explicit-observation in library: **§state-at-the-daemon-verbs-at-the-worker — §the-imperative-verbs-pattern (setText, appendLines, etc.) + §the-daemon-IS-the-source-of-truth-for-reattach-and-recompose + §workers-emit-deltas + §the-daemon-keeps-the-full-state**.

§Sibling-pattern to many client-server architectures — but §named-here-as-a-design-discipline-not-just-an-implementation-detail.

§"This mirrors the existing message-hub pattern" — §named-reference-to-an-existing-pattern-in-the-system + §the-design-doesn't-invent-a-new-discipline-but-aligns-with-an-existing-one; §first-explicit-observation in library of §named-reference-to-an-existing-pattern-as-design-rationale-rather-than-inventing-a-new-discipline.
