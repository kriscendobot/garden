---
title: §the-`Pass-Invariant-Eq` named-open-question (first-explicit-observation)
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

The design names a deferred concern: when a public key changes, anything that hard-coded the old key as part of a locator continues to point at the old entry, and the new key is, from the recipient's perspective, a fresh object even though the operator intended a continuation. **This breaks the Pass-Invariant Eq property from E** (object identity preserved across grants; two paths to the "same" object compare equal under `===`/`Eq`).

**§the-cryptographic-rotation-vs-object-identity-tension as named open question** (first-explicit-observation): a known capability-system property (Pass-Invariant Eq from E) cited by name as a constraint that the rotation story has to preserve. The design names this as `Open Question 1`, points at where it'll be addressed (`daemon-agent-network-identity`), and explicitly defers: "the Gateway only needs to accept multi-key registrations and let policy decide which keys to keep".
