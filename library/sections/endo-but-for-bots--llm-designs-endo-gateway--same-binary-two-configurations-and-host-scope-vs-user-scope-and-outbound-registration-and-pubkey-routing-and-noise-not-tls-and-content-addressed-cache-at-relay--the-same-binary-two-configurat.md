---
title: §the-same-binary-two-configurations pattern (first-explicit-observation)
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

The Gateway and the per-user Daemon **are two modes of the same generic Daemon binary**, selected at startup by a configuration flag. **Reusing one binary keeps the formula machinery, content store, worker plumbing, and OCapN client common between modes**. The Gateway's "mode" is largely a startup configuration that *disables the formula-execution side*, *enables the registration table and the proxying handlers*, and *selects a different unconfined-guest formula at boot in place of the user-side `@apps` formula*.

**Three named subtractions and one named substitution** between the two modes (from the same shared binary):

- Subtracts: formula-execution side.
- Adds: registration table + proxying handlers.
- Substitutes: a different unconfined-guest boot formula in place of `@apps`.

This is **§binary-reuse-as-mode-not-fork** as a named architectural shape — the same compiled artifact serves both host-level and user-level postures.
