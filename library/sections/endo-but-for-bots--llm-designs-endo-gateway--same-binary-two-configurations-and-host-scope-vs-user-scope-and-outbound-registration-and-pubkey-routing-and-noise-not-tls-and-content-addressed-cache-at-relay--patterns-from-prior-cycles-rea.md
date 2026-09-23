---
title: Patterns from prior cycles, reaffirmed
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

- **§five-cycles-now with explicit-capability-by-construction** — extends the canonical caretaker-two-facet-pattern. The Gateway is **the-relay-IS-incapable-of-reading-OCapN-frames-by-construction** (Noise terminates at the User Daemon, not the relay). Confined-by-construction sees one more cycle.
- **§the-`Status: Proposed`-vs-`Status: Not Started`-vs-other-statuses** — Cycle 283 is `Proposed` status, the same as 279 cli-edit-verb and 281 garden-driver-design. Three cycles with `Proposed` status. **§three-cycles-with-Proposed-Status (279 + 281 + 283).**
- **§the-document-acknowledges-its-own-evolution-within-the-document** — Updated field carries a parenthetical list of the review pass that the version reflects: "*Updated 2026-05-10 (review pass: no TLS, Noise netlayer, /ocapn WS, Host→CAS, separate config trees, defer key rotation, defer daemon-hosting variant)*". This is the **fourth** cycle with this shape (269 + 279 + 281 + 283).
- **§named-author-format `Name (prompted)`** — the canonical Endo design-doc author convention is honored (single author this time).
