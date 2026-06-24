---
title: "`endo-gateway.md` (full design)"
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

A 997-line Proposed design (Source: extracted from issue #173, which itself was extracted from PR #134 review at 2026-05-10T06:14:41Z). Splits the existing per-user Endo Daemon into a **host-scope Gateway + N per-user Daemons**, both as **two modes of the same binary**, with a public-key-keyed registration table, frame-level HTTP/WebSocket relay, and an OCapN endpoint where session confidentiality comes from the Noise netlayer rather than TLS.
