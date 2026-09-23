---
title: The shape
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

**One binary, two modes selected at startup by `--mode=gateway` vs `--mode=user`** (`user` is the default for backward compatibility). A given host runs **at most one Gateway** and **zero or more User Daemons**:

- **Endo Gateway** (system service, one per host, **one TCP port**): listens for HTTP and a WebSocket `/ocapn` endpoint, holds the public-key → User-Daemon-connection routing table, and relays weblet traffic.
- **User Daemon** (one per OS user account): registers outbound with the Gateway over a local-only IPC channel, publishes weblets, handles dynamic-fallback HTTP and WebSocket frames.
- **Weblets** (M per User Daemon): one virtual host per weblet, addressed by the first 32 hex characters of the weblet's formula ID (preserves today's convention).

**The Gateway carries no formula store of its own beyond what it needs to represent its registration table and operator policy.** Everything else — formulas, agents, weblet code, content — stays in the per-user Daemon.
