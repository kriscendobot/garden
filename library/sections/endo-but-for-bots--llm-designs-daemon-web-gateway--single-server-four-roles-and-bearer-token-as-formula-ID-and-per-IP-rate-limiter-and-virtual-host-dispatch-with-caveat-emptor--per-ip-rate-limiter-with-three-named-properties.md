---
title: §Per-IP-rate-limiter with §three-named-properties
source-slug: endo-but-for-bots--llm-designs-daemon-web-gateway
section-id: single-server-four-roles-and-bearer-token-as-formula-ID-and-per-IP-rate-limiter-and-virtual-host-dispatch-with-caveat-emptor
url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/daemon-web-gateway.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/daemon-web-gateway.md
total-lines: 185
status: Complete (2026-03-11)
ingest-cycle: 224
ingest-date: 2026-06-08
lane: designs
parent: endo-but-for-bots--llm-designs-daemon-web-gateway--single-server-four-roles-and-bearer-token-as-formula-ID-and-per-IP-rate-limiter-and-virtual-host-dispatch-with-caveat-emptor
---

```
A per-IP rate limiter penalizes failed `fetch()` attempts by 1 second each.
Successful fetches do not affect the rate limit. Stale entries are removed
after 10 seconds.
```

§Three-named-properties:
1. §Failed-attempts-penalized (1-second penalty per failed fetch).
2. §Successful-fetches-do-not-affect-the-rate-limit (a known user doesn't get throttled).
3. §Stale-entries-removed-after-10-seconds (the table doesn't grow unboundedly).

§Borrowable-pattern: §rate-limiter-with-explicit-rules-named-for-each-traffic-class. §Most-rate-limiters-have-one-rule (e.g., "10 requests per second"); §this-one-has-three-rules-each-targeting-a-different-attack-or-cost.

§Sibling to cycle 220 familiar-localhttp-protocol's §three-named-mitigations-per-defense-layer. §Both-designs-name-multiple-rules-per-control instead of one generic limit.
