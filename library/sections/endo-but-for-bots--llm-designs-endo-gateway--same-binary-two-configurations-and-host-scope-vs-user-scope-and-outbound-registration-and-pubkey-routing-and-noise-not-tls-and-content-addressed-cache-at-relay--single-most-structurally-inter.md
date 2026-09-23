---
title: Single most structurally interesting move
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

**§the-same-binary-two-configurations** combined with **§the-platform-singleton-by-supervisor** — the design pushes singleton-enforcement entirely outside the binary (to whichever of five named platform service managers is running) AND keeps the host-scope and user-scope code paths fused into one compiled artifact. The result is **a binary that is mode-selectable at startup but state-light at runtime**: no PID files, no lock files, no internal singleton dance, no per-platform service-manager glue inside the daemon. The platform supervisor runs one Gateway; the user session runs one (or more) User Daemons; the daemon never has to enforce its own cardinality.

This is `the-cardinality-IS-the-supervisor's-job` — a named architectural delegation that simplifies both the binary's source and the per-platform integration story.
