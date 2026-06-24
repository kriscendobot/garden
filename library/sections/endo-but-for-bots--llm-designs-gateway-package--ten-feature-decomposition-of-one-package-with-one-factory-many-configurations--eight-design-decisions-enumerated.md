---
source: designs/gateway-package.md
source_repo: endojs/endo-but-for-bots
source_url: https://github.com/endojs/endo-but-for-bots/blob/design/gateway-package/designs/gateway-package.md
source_path: designs/gateway-package.md
source_branch: design/gateway-package
section_kind: design
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - daemon
  - tooling
  - capability-security
genre: §endo-but-for-bots-design
cycle: 174
lane: designs
status: current
title: §Eight-Design-Decisions enumerated
parent: endo-but-for-bots--llm-designs-gateway-package--ten-feature-decomposition-of-one-package-with-one-factory-many-configurations
---

1. Extract-the-gateway-into-its-own-package.
2. `0.0.0.0:3469` default with `ENDO_HTTP_ADDR` override.
3. `/ocapn-cbor-np` rather than bare `/ocapn`.
4. Formula identifier as bearer token (reuse).
5. No TLS in the gateway.
6. Gateway and daemon are separate processes, not separate
   binaries (same package; different embeddings).
7. UDS bootstrap is the administrator's access channel.
8. Per-account resource ledger lives in the gateway.
