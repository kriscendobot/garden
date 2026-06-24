---
title: §the-frame-level-relay-without-CapTP-inspection (first-explicit-observation)
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

For per-weblet WebSocket traffic, the Gateway **proxies frame-for-frame** without parsing or understanding the application-level CapTP carried over the WebSocket. **The Gateway and User Daemon split on protocol responsibility**: the Gateway owns the HTTP and WebSocket framing; the User Daemon owns CapTP. **The protocol layers are split at named boundaries**, not entangled.

**§named-protocol-layer-ownership-split shape**: HTTP-and-WS-framing-IS-Gateway + CapTP-IS-User-Daemon + Noise-IS-User-Daemon. Each layer has one owner.
