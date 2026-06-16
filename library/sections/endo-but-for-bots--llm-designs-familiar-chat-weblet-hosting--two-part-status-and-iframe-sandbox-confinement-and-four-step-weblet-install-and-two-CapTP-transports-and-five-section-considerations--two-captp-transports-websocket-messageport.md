---
title: §Two-CapTP-transports (WebSocket + MessagePort)
source-slug: endo-but-for-bots--llm-designs-familiar-chat-weblet-hosting
section-id: two-part-status-and-iframe-sandbox-confinement-and-four-step-weblet-install-and-two-CapTP-transports-and-five-section-considerations
url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/familiar-chat-weblet-hosting.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/familiar-chat-weblet-hosting.md
status: Not Started (with ready Familiar-side infrastructure)
ingest-cycle: 218
ingest-date: 2026-06-08
lane: designs
parent: endo-but-for-bots--llm-designs-familiar-chat-weblet-hosting--two-part-status-and-iframe-sandbox-confinement-and-four-step-weblet-install-and-two-CapTP-transports-and-five-section-considerations
---

The design proposes §two-named-transports for the weblet's CapTP connection:

1. **WebSocket** (universal): weblet JS opens WebSocket to virtual host URL; unified server routes to weblet's connection handler.
2. **MessagePort** (Familiar-specific, more performant): Chat's main frame creates `MessageChannel`; one port transferred to weblet iframe via `postMessage`; CapTP runs over the `MessagePort` directly.

§The-design-names-MessagePort-as-a-stretch-goal:

> This is a stretch goal. The WebSocket approach works universally (including when weblets are opened in external browser tabs), while the MessagePort approach is Familiar-specific and more performant.

§Borrowable-pattern: §primary-transport-and-stretch-goal-transport with §the-stretch-goal-is-environment-specific-and-more-performant. §The-universal-transport-works-everywhere-but-pays-the-overhead; §the-specific-transport-is-cheaper-but-narrower-in-applicability. §Two-axes-of-trade-off-named-explicitly: §universality vs §performance.

§Borrowable-pattern: §when-a-design-proposes-two-transports-with-trade-offs, §name-the-trade-off-explicitly-and-mark-one-as-stretch.
