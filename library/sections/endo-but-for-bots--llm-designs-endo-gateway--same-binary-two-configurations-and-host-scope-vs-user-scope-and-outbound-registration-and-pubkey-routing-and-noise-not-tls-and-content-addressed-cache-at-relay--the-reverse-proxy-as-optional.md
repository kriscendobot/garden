---
title: §the-reverse-proxy-as-optional-operator-add for TLS, not Gateway-built-in (first-explicit-observation)
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

"Operators who want TLS in front of the browser path are free to put a reverse proxy in front of the Gateway, but the Gateway does not do TLS itself." Three named reverse proxies (Caddy + nginx + Traefik). The Gateway pushes TLS termination *outside the binary entirely*, treating it as **operator policy on the deployment**, not a built-in option.

**§named-out-of-scope-with-named-third-party-replacements shape** (first-explicit-observation): a design that explicitly delegates a function to named external software rather than carrying that function as a configurable knob.
