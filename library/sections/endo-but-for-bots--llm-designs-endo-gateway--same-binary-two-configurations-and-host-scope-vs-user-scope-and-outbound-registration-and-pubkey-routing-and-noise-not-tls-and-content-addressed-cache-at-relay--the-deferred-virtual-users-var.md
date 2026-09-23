---
title: §the-deferred-virtual-users-variant as named future-mode-extension (first-explicit-observation)
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

The design names a **second deferred variant**: a "daemon hosting service" config in which the Gateway manages **virtual users** rather than addressing system-level User Daemons. "In that variant the Gateway holds the formula stores and the agent powers directly (one logical User Daemon per virtual user, all in-process), instead of relaying to N OS processes." The interfaces above are written so that a virtual-users variant can implement the same `UserDaemon` exo internally. **The current design constrains its scope to one mode-pair while explicitly leaving the door open for a third mode.**

**§the-scope-cutoff-with-named-future-mode pattern** (first-explicit-observation): a design that names what it is **not** doing, with the interface shape that the future variant will reuse.
