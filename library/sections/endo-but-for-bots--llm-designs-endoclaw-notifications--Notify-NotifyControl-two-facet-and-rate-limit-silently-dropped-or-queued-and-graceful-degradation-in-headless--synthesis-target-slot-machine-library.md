---
title: §Synthesis target — slot machine library
source-slug: endo-but-for-bots--llm-designs-endoclaw-notifications
source-url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/endoclaw-notifications.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/endoclaw-notifications.md
total-lines: 55
ingest-cycle: 253
ingest-date: 2026-06-09
lane: designs
parent: endo-but-for-bots--llm-designs-endoclaw-notifications--Notify-NotifyControl-two-facet-and-rate-limit-silently-dropped-or-queued-and-graceful-degradation-in-headless
---

For a slot machine library:

- §game-notification / game-notification-control two-facet pattern for §player-notifications-with-host-rate-limit.
- §single-rate-limit-axis for §the-simplest-game-notification-control.
- §silently-dropped-or-queued for §game-notification-overflow-policy (game doesn't throw when the player is notified too fast).
- §graceful-degradation-across-substrates for §game-notification-degrades-to-game-log-when-desktop-API-absent.
- §two-named-degradation-targets for §game-log + §game-UI-banner.
- §named-non-dependency as completeness signal for §narrow-game-feature-with-no-design-deps.
- §the-agent-cannot-discover-or-influence-the-control-facet for §game-rule-cannot-self-grant-rate-bump.
- §revocation-is-immediate for §game-notification-revoke-and-future-calls-throw.
