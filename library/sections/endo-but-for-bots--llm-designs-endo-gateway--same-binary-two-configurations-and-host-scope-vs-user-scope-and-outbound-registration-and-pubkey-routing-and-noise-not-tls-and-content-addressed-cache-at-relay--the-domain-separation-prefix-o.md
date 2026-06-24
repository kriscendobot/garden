---
title: §the-domain-separation-prefix-on-the-nonce as named protocol-cross-use defense (first-explicit-observation)
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

The Gateway hashes the nonce with a **domain-separation prefix** (suggested literal `endo-gateway:registrar:nonce`) before checking the signature; this prevents a captured registration signature from being misused as a signature in another OCapN protocol step. **§the-domain-separation-literal as named-string-tag** (first-explicit-observation): a literal protocol-and-step namespace `endo-gateway:registrar:nonce` that prevents signature cross-replay between protocol steps that share the same long-lived key material. The signature is bound to the protocol context, not just the bytes signed.
