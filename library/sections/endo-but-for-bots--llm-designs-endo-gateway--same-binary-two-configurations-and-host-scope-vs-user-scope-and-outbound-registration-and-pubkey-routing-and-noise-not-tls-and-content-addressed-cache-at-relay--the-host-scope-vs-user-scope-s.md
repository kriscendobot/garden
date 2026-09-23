---
title: §the-host-scope-vs-user-scope split as named architectural distinction (first-explicit-observation)
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

The design explicitly names **three reasons the per-user Daemon is the wrong place for multi-user virtual-host service**:

1. **OS-user privilege boundary**: it runs as one OS user and would have to be granted privileges that crossed user boundaries to relay another user's traffic.
2. **Per-host singleton vs per-user implicit-multiplicity**: two daemons on the same host would race for the same port; the service is implicitly a per-host singleton, but the daemon is implicitly per-user.
3. **Policy domain**: hosting policy (which users may register weblets, which public keys are allowed at the local virtual-host hierarchy, whether to expose to the public internet) is host-administrator policy, not user policy.

**§three-named-policy-domains as named separation criteria** (first-explicit-observation): OS-user-privilege + per-host-vs-per-user-cardinality + host-administrator-vs-user-policy. This is **the-policy-domain-IS-the-decomposition-axis** rather than convenience or DRY.
