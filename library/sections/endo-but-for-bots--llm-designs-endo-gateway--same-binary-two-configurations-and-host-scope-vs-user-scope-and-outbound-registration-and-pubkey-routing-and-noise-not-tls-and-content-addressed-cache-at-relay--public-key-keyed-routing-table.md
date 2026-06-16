---
title: §public-key-keyed-routing-table as named indirection (first-explicit-observation)
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

The Gateway maintains a `publicKey -> User Daemon connection` table keyed by the registrant's public key. **The routing key is cryptographic, not OS-level**: the Ed25519 public key (the same per-agent key material that doubles as OCapN node identifier in `daemon-256-bit-identifiers`) is the join key across two paths — the local IPC registration path and the remote OCapN endpoint at `/ocapn`. A single lookup serves both paths.

**§the-single-lookup-serves-both-paths shape** (first-explicit-observation): the same key type is the join key for the local registration path AND the OCapN session demultiplex path on remote ingress, so **the Gateway's lookup table is shape-shared across two distinct entry surfaces**.
