---
title: §the-ciphertext-passing-relay as named role (first-explicit-observation)
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

The Gateway is, on the OCapN endpoint, a **ciphertext-passing relay**: it terminates the TCP and WebSocket framing but the OCapN frames riding inside the WebSocket are encrypted end-to-end Noise-secured between the remote peer and the destination User Daemon. **The Gateway in the middle sees only ciphertext** for OCapN traffic. This is true confined-by-construction: the Gateway cannot read or tamper with OCapN content even if compromised.

**§the-relay-IS-confined-by-encryption shape** (first-explicit-observation): a man-in-the-middle that is structurally unable to read what passes through it, because the cryptographic shell terminates at the endpoints rather than at the relay. This is **stronger than a-relay-that-promises-not-to-read** — the relay-IS-incapable-of-reading is the named guarantee.
