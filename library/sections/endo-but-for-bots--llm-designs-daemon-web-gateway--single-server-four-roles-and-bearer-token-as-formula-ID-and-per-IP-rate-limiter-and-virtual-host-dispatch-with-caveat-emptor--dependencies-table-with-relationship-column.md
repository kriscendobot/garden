---
title: §Dependencies-table with §Relationship-column
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
| Design | Relationship |
|--------|-------------|
| familiar-gateway-migration | Moved gateway into daemon as built-in service |
| familiar-unified-weblet-server | Virtual-host routing for weblets on shared port |
| familiar-electron-shell | Familiar's localhttp:// protocol handler and daemon lifecycle |
| gateway-bearer-token-auth | Agent ID as bearer token, rate limiting, CIDR filtering |
| daemon-256-bit-identifiers | 256-bit formula IDs used as access tokens |
```

§Five-named-dependencies each with §a-named-relationship. §Borrowable-pattern: §Dependencies-table-with-Relationship-column (vs cycle 222's bullet list with named-reason; vs cycle 218's three-line bullet list).

§Three-different-shapes-for-naming-dependencies in 2026-06 cluster:
- Cycle 218 familiar-chat-weblet-hosting: bullet list with §named-reason-per-dependency.
- Cycle 220 familiar-localhttp-protocol: bullet list with §named-reason-per-dependency.
- Cycle 222 endoclaw-skill-registry: bullet list with §status-per-dependency.
- Cycle 224 daemon-web-gateway: table with §Relationship-column.

§Four-different-shapes-for-naming-design-dependencies. §The-table-form (cycle 224) §makes-the-relationship-readable-at-a-glance + §the-bullet-form (cycles 218/220/222) §names-the-reason-prose-style.
