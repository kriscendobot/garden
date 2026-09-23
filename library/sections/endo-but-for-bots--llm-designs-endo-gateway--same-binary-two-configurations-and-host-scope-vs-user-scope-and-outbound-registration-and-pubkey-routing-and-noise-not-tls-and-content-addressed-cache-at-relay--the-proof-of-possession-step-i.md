---
title: §the-proof-of-possession-step-IS-distinct-from-local-attestation (first-explicit-observation)
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

The handshake also includes a **proof-of-possession** step: the User Daemon signs a fresh nonce returned by an immediately preceding `E(registrar).challenge()` call with its Ed25519 private key. **This is explicitly not the local-attestation step**: "The proof-of-possession step in the registration handshake is **not** about local-vs-remote (the socket is local-by-construction); it is about distinguishing one local user from another so that a malicious local user cannot register another local user's public key." Two named concerns at one handshake, with each step doing exactly one thing.

**§one-handshake-two-distinct-concerns pattern** (first-explicit-observation): the registration handshake interleaves two security questions — *is the registrant on this host?* (channel-attested) and *does the registrant control the private key for the public key it claims?* (proof-of-possession-attested). The design names the two concerns and the two mechanisms separately so a future reader does not collapse them.
