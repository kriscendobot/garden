---
title: §Virtual-host-dispatch for both HTTP and WebSocket
source-slug: endo-but-for-bots--llm-designs-daemon-web-gateway
section-id: single-server-four-roles-and-bearer-token-as-formula-ID-and-per-IP-rate-limiter-and-virtual-host-dispatch-with-caveat-emptor
url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/daemon-web-gateway.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/daemon-web-gateway.md
total-lines: 185
status: Complete (2026-03-11)
ingest-cycle: 224
ingest-date: 2026-06-08
lane: designs
parent: endo-but-for-bots--llm-designs-daemon-web-gateway--single-server-four-roles-and-bearer-token-as-formula-ID-and-per-IP-rate-limiter-and-virtual-host-dispatch-with-caveat-emptor
---

§Same-dispatch-mechanism-for-two-different-protocols:
- HTTP requests: matched by `Host` header to a weblet's request handler.
- WebSocket upgrade requests: matched by `Host` header to a weblet's `connect` handler.

§Borrowable-pattern: §unified-virtual-host-dispatch-across-protocol-types. §The-Host-header-IS-the-shared-discriminator across HTTP and WebSocket flows.

§When-a-WebSocket-upgrade-arrives-with-a-Host-header-matching-a-registered-weblet, §the-gateway-delegates-to-that-weblet's-connect-handler-instead-of-creating-a-GatewayBootstrap. §Borrowable-pattern: §the-default-handler-vs-the-registered-weblet-handler-distinction.
