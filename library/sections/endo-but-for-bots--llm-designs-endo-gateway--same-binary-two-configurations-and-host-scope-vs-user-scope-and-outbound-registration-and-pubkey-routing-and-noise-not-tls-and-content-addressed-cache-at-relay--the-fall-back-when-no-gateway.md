---
title: §the-fall-back-when-no-Gateway-detected behavior (first-explicit-observation)
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

"Familiar should detect at startup whether a Gateway is reachable on the local rendezvous socket; if so, the in-process User Daemon registers with it instead of binding a port; if not, Familiar falls back to today's behaviour (User Daemon binds a per-user port)." **The single-user developer flow is preserved as the fall-back path**: a standalone single-user developer install can still run a User Daemon with no Gateway in front of it, in which case the User Daemon binds its own port as it does now.

**§the-no-Gateway-fall-back as named legacy-compatibility shape** (first-explicit-observation): the new architecture is *opt-in via discovery*, with the legacy path remaining the default. This is **discovery-IS-the-feature-toggle** — no flag flip, no config file, no migration; whether you get the Gateway depends solely on whether one is reachable.
