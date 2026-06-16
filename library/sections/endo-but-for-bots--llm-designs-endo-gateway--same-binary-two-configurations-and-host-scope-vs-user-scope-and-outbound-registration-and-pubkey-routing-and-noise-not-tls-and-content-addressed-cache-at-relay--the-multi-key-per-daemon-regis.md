---
title: §the-multi-key-per-Daemon registration pattern (first-explicit-observation)
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

The `Registration` exo exposes `addPublicKey` so **one Daemon may host more than one agent**. The protocol allows a Daemon to register additional public keys and to retire old ones; the *operational* rotation path exists by composition. The named primitive is **one-Daemon-many-keys**, not the typical one-process-one-key shape.

**§one-process-many-keys as named multiplicity** (first-explicit-observation): the routing-table entry is the (key, daemon) tuple, not a one-to-one map from process to key; many tuples may share a daemon.
