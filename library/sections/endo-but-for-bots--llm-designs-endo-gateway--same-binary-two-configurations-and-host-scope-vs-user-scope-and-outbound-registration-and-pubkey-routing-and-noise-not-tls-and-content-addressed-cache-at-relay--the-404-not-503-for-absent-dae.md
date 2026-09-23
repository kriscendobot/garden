---
title: §the-404-not-503-for-absent-daemon as named privacy-and-cacheability decision (first-explicit-observation)
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

"A request for a Host whose User Daemon is down returns **404 (not 503)** so that **the response is cacheable and gives no signal about which users exist on the host**." Two named reasons in one decision:

1. **Cacheability** — 404 is a normal cacheable response; 503 advertises a transient condition that must not be cached.
2. **Privacy** — 404 means "no such Host on this server"; 503 means "this Host exists but is unavailable". The latter leaks which users have ever registered.

**§the-error-code-choice-IS-a-privacy-decision pattern** (first-explicit-observation): a status code as a side-channel, with the privacy implication called out explicitly. This is `the-404-not-503` as a *security-property-by-choice-of-error-code*.
