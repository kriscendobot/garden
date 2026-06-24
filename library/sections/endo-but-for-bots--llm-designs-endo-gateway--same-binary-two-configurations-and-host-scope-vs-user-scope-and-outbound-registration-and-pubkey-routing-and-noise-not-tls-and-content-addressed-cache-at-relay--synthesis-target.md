---
title: Synthesis target
section-slug: endo-but-for-bots--llm-designs-endo-gateway--same-binary-two-configurations-and-host-scope-vs-user-scope-and-outbound-registration-and-pubkey-routing-and-noise-not-tls-and-content-addressed-cache-at-relay
source-slug: endo-but-for-bots--llm-designs-endo-gateway
url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/endo-gateway.md
authors: [Kris Kowal (prompted)]
status: Proposed
created: 2026-05-10
updated: 2026-05-10
ingest-cycle: 283
ingest-date: 2026-06-10
lane: designs
scope: full
total-lines: 997
parent: endo-but-for-bots--llm-designs-endo-gateway--same-binary-two-configurations-and-host-scope-vs-user-scope-and-outbound-registration-and-pubkey-routing-and-noise-not-tls-and-content-addressed-cache-at-relay
---

Slot machine library `@game/server` two-mode binary: same compiled artifact as `--mode=lobby` (host-scope front-door, one TCP port, routes player sessions by public key) vs `--mode=table` (per-table game logic, registers outbound with the lobby). The lobby holds **only** the public-key → table-connection routing table; the table owns the game state, the player-action handlers, and the deterministic-replay log. Session confidentiality between player and table is provided by Noise inside a WebSocket frame (so the lobby cannot tamper with player actions even if compromised); static asset delivery (rule sheets, sprite atlas) is served directly out of the lobby's content-addressed cache after the table publishes the tree-root hash. A standalone single-table developer install runs in `--mode=table` and binds its own port; in production, the table detects the lobby and registers outbound instead. The lobby's restart re-builds the table table from incoming registrations. Lobby + table service-manager targets: systemd + launchd + Windows Service + container + AppImage. Absent-table response is 404 (cacheable, no leak of which tables exist). The platform service manager IS the singleton enforcer.
