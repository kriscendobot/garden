---
title: §the-rebuild-from-registrations-on-restart, not persisted (first-explicit-observation)
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

**A Gateway restart drops every connection (TCP closes), and clients reconnect.** User Daemons reconnect to the registration socket and re-publish their weblets; **the Gateway's registration table is rebuilt from those incoming registrations rather than persisted across restarts**. This keeps the Gateway's on-disk state minimal (operator policy files, the sqlite formula store, the CAS cache; no TLS key, no certificate, no Noise static key beyond what the OCapN netlayer manages itself) and avoids the Gateway's table going stale relative to the live User Daemons.

**§the-state-IS-rebuildable-from-clients shape** (first-explicit-observation): the relay's routing state is not its source of truth — the User Daemons are — so a restart that loses the routing table is **self-healing**: the User Daemons re-converge and re-register. This is similar to the way a DNS server doesn't persist client TTLs; the clients re-query when their cache expires.
