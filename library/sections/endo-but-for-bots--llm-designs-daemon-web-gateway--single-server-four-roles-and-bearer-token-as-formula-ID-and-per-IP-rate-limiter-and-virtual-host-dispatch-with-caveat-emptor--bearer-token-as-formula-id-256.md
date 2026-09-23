---
title: §Bearer-token-as-formula-ID (256-bit identifier doubles as auth)
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

> Chat calls `E(gatewayBootstrap).fetch(agentId)` with the agent's 256-bit hex formula identifier — which doubles as the bearer token — to obtain the agent's powers over CapTP.

§The-formula-ID-IS-the-bearer-token. §No-separate-token-table-needed — §knowing-the-formula-ID-is-the-authentication. §Borrowable-pattern: §when-an-opaque-identifier-is-already-256-bit-uniformly-random, §it-can-serve-as-its-own-bearer-token. §Sibling to cycle 200 worker-rust-xs's §retention-path-notation and cycle 220 familiar-localhttp-protocol's §the-deterministic-address-IS-the-coordination-primitive. §The-identifier-IS-the-capability discipline appears in three different layers.

§Five-cycles-on-the-identifier-IS-the-capability discipline:
- Cycle 200 worker-rust-xs (retention paths).
- Cycle 210 lal-fae-form-provisioning (deterministic naming as coordination).
- Cycle 211 @endo/common (file path IS the import path).
- Cycle 220 familiar-localhttp-protocol (deterministic address IS the route).
- Cycle 224 daemon-web-gateway (formula ID IS the bearer token).

§The-pattern-deepens: §the-coordinating-name + §the-routing-key + §the-authentication-token can all be the same string. §Don't-store-it-twice; §let-the-shape-itself-carry-the-meaning.
