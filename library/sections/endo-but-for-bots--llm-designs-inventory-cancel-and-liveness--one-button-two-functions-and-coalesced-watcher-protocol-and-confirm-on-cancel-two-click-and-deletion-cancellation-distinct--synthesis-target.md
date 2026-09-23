---
title: §Synthesis-target
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

Slot machine library §casino-operator-dashboard:

- §One-button-two-functions borrowable for §game-state-indicator-and-stop-button (single circular element showing game status, click stops the game).
- §Five-state-color-coding borrowable for §game-state-display (Idle / Running / Paused / Settling-Payout / Suspended).
- §Confirm-on-cancel-two-click borrowable for §stopping-a-running-game (consequential — players may be mid-bet).
- §Deletion-and-cancellation-distinct borrowable for §removing-game-from-dashboard vs §stopping-current-game-session.
- §Coalesced-watcher-protocol borrowable for §dashboard-with-N-games — single watcher streams all transitions, client mutates watched set as games are scrolled in/out of view.
- §E.sendOnly-fire-and-forget borrowable for §UI-state-updates-that-don't-need-acknowledgment.
- §ASCII-art-as-design-prose borrowable for §game-UI-mockups-in-design-docs.
