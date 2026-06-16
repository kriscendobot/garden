---
title: §Borrowable patterns (tier-1)
source: endo-but-for-bots designs/inventory-cancel-and-liveness.md
source-slug: endo-but-for-bots--llm-designs-inventory-cancel-and-liveness
ingest-cycle: 206
ingest-date: 2026-06-06
lane: designs
status: Not Started (2026-02-14 created; 2026-03-13 updated)
author: Kris Kowal (prompted)
related:
  - endo-but-for-bots--llm-designs-daemon-capability-bank (Dependency named in design)
  - endo-but-for-bots--llm-designs-workers-panel (cycle 147; sibling-feature also showing liveness)
  - endo-but-for-bots--llm-designs-formula-inspector (cycle 145; sibling — both surfaces inventory items)
  - endo-but-for-bots--llm-designs-retention-path-notation (cycle 38 + cycle 200 attempt; §non-throwing-API-and-error-shape sibling pattern)
  - endo-but-for-bots--llm-designs-patterns-diagnostic-feedback (cycle 198; §non-throwing-matcher mirror; similar §single-stream-with-server-filtering shape)
  - endo--packages-cache-map (cycle 203; §bounded-size-collection with set-membership-API sibling pattern)
  - endo--packages-eventual-send (E.sendOnly is the key API in cycle 146 E.js)
keywords:
  - one-button-two-functions (cancel IS indicator)
  - five-state-color-coding (Live / Settled / Pending / Not-incarnated / Cancelled)
  - coalesced-liveness-watcher-protocol
  - client-mutates-watched-set
  - E.sendOnly-fire-and-forget-watch-unwatch
  - watch + unwatch + watchAll three-method API
  - server-filters-transitions-by-watched-set
  - single-CapTP-async-iterator-carries-all-transitions
  - confirm-on-cancel via two-click-3-second-timeout
  - deletion-vs-cancellation-distinct (naming vs lifecycle)
  - disabled-for-special-names (AGENT / SELF / HOST uppercase)
  - pinned-capabilities-survive-pet-name-deletion (PINS directory retention)
  - watcher-scoped-to-agent's-own-pet-store (capability discipline)
  - additive-API-old-clients-unaffected
  - design-consolidation (live-reference-indicator + inventory-cancel-and-liveness merged)
  - five-Design-Decisions canonical format
  - ASCII-visual-layout-diagram for UI
  - amber-pulsing for pending state
  - hollow-border-for-cancelled
  - thirteen Dependencies + Affected-Packages-table
  - N+1 subscription problem
  - cycle 206 designs-lane
  - fortieth consecutive designs/chat alternation cycle 166-206
parent: endo-but-for-bots--llm-designs-inventory-cancel-and-liveness--one-button-two-functions-and-coalesced-watcher-protocol-and-confirm-on-cancel-two-click-and-deletion-cancellation-distinct
---

1. **§One-button-two-functions** for §UI-density when §the-affordance-and-the-status-display-are-conceptually-related.
2. **§Five-state-color-coding** (Live / Settled / Pending / Not-incarnated / Cancelled) with §one-pulsing-state + §one-non-filled-state as §canonical-shape.
3. **§Confirm-on-cancel-via-two-click-3-second-timeout** for §destructive-actions-deserving-confirmation-but-not-interruption.
4. **§Deletion-and-cancellation-are-distinct** — §naming-operation vs §lifecycle-operation with §two-distinct-affordances.
5. **§Pin-as-GC-anchor** — pinned capabilities survive pet name deletion via PINS directory.
6. **§Disabled-but-still-shown** for §uncancellable-substrate-capabilities (uppercase system names like AGENT/SELF/HOST).
7. **§Coalesced-watcher-protocol** with §client-mutates-watched-set + §server-filters-transitions + §single-async-iterator-carries-all-results as §canonical-solution-to-N+1-subscription-problem.
8. **§Three-method-API**: watch + unwatch + watchAll (batch optimization for initial load).
9. **§E.sendOnly-fire-and-forget** for §state-update-without-round-trip-latency.
10. **§watch(id)-immediately-publishes-current-status** as §initial-value-on-subscribe pattern.
11. **§Watcher-scoped-to-agent's-own-pet-store** as §capability-discipline.
12. **§Single-watcher-per-component-tree** + §per-item-watch/unwatch + §automatic-GC-on-unmount.
13. **§ASCII-art-as-design-prose** for §UI-mockup-in-Markdown-design-docs.
14. **§Five-Design-Decisions canonical format** with §each-decision-names-the-rationale.
15. **§Additive-API** + §reuse-existing-mechanism for §UI-features-that-surface-existing-capabilities.
16. **§Design-consolidation-recorded-in-Prompt-section** for §design-evolution-events where two designs merge into one.
17. **§Upgrade-Considerations-section** with §named-concerns as §a-design-discipline.
18. **§Four-lifecycle-hooks** for publishing watcher transitions (provide / cancel / settle / initial-on-watch).
19. **§InterfaceGuard-with-named-methods** as §canonical-shape for Endo exos.
