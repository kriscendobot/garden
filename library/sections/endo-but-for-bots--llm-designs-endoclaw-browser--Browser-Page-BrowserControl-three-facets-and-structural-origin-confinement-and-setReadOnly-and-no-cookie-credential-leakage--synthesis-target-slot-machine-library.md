---
title: §Synthesis target — slot machine library
source-slug: endo-but-for-bots--llm-designs-endoclaw-browser
source-url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/endoclaw-browser.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/endoclaw-browser.md
total-lines: 93
ingest-cycle: 259
ingest-date: 2026-06-10
lane: designs
parent: endo-but-for-bots--llm-designs-endoclaw-browser--Browser-Page-BrowserControl-three-facets-and-structural-origin-confinement-and-setReadOnly-and-no-cookie-credential-leakage
---

For a slot machine library:

- §Game-machine + game-session + game-control three-facet pattern with game-session derived from game-machine.start().
- §A-derived-capability-from-the-use-facet for §game-session-from-game-machine-start.
- §Structural-game-rule-confinement — game-machine rejects game-actions outside the allowed game-rules.
- §setReadOnly mode for §game-spectator-mode-disables-bet-fold-call (three named mutation methods).
- §Caretaker-revocation propagates to derived game-sessions.
- §No game-secret-leakage — three named non-exposures on game-session interface (game-RNG-seed + game-internal-state + game-network-events).
- §Confinement-by-omission for game-internal-state-not-exposed-to-player.
- §Use-facet-size correlates with substrate-API-size for §game-session-with-many-actions-when-game-has-many-actions.
- §Optional-prefix-on-Depends-On-bullet for §optional-game-defense-in-depth.
