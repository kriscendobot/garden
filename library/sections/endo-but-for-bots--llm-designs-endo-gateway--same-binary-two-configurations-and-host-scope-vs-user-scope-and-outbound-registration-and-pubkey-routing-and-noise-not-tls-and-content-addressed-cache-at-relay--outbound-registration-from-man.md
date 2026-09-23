---
title: §outbound-registration-from-many-to-one as named direction (first-explicit-observation)
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

User Daemons **make their presence known to the Gateway by opening an outbound CapTP connection** over a local-only IPC channel and presenting their Ed25519 public key. **The direction is many-to-one outbound**, not one-to-many discovery: the Gateway does **not** scan for User Daemons; the User Daemons converge on a well-known rendezvous (`/run/endo-gateway/registrar.sock` on Linux; named pipe `\\.\pipe\endo-gateway` on Windows).

**§the-rendezvous-shape as named architectural pattern** (first-explicit-observation): a single, well-known local IPC path where every User Daemon on the host converges to find the Gateway. The Gateway holds the well-known address; the User Daemons hold the dialing logic; **the registration is a connect, not a discover**.
