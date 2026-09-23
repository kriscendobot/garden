---
title: §Synthesis-target — slot machine library
source-slug: endo-but-for-bots--llm-designs-cli-http-client
source-url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/cli-http-client.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/cli-http-client.md
total-lines: 644
ingest-cycle: 238
ingest-date: 2026-06-08
lane: designs
parent: endo-but-for-bots--llm-designs-cli-http-client--controller-and-client-cap-split-and-mutate-the-policy-not-the-client-identity-and-the-controller-IS-the-pet-name-handle-and-three-SSRF-defenses-and-design-revision-after-CHANGES_REQUESTED
---

For a slot machine library:

- §game-controller-and-game-client-cap-split for §game-policy-vs-game-use-authority.
- §mutate-the-game-rules-not-the-game-engine-identity — game admin can adjust rules without re-deploying the game.
- §the-game-controller-IS-the-pet-name-handle that survives across player sessions.
- §game-subcommand-tree (`game mk`, `game allow-mode`, `game set-payout`, `game revoke`, `game inspect`).
- §game-method-placement-table — which methods sit on which facet (player + admin + spectator).
- §game-add-and-remove-convenience-methods on the controller prevent read-mutate-write races on the rule set.
- §game-cancellation-promise for platform-neutral abort of in-flight bets.
- §two-independent-cancellation-channels for §game-admin-revoke + §player-abort-current-bet.
- §three-SSRF-equivalents-in-game-context: §game-redirect-defense (game-rule cannot pivot to another payout source) + §game-slow-loris-defense (game-rule must respond within wall-clock timeout) + §game-response-flooding-defense (game-payout truncated at threshold).
- §local-idioms-cited-table for §game-rule-builder-uses-established-patterns.
- §game-engine-shim-shape for forward-compat with future game engines.
- §alternatives-considered with rejected/deferred labels for §game-design-doc-discipline.
- §identifier-conventions-TBD-pending-namer-dispatch for §game-content-naming-as-separate-decision.
- §open-questions-with-default-or-proposal for §game-rule-defaults-named-as-recommendations.
