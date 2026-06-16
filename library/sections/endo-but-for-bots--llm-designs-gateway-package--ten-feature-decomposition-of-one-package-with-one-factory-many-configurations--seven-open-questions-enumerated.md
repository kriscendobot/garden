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
title: §Seven-Open-Questions enumerated
parent: endo-but-for-bots--llm-designs-gateway-package--ten-feature-decomposition-of-one-package-with-one-factory-many-configurations
---

1. Payment-token mechanism (which processor).
2. Abuse-prevention model for the public relay.
3. Virtual-host name allocation across users (collision
   resolution).
4. Rotation story for formula-identifier bearer tokens
   (inherits Pass-Invariant-Eq follow-up).
5. Multi-tenant filesystem isolation for the per-user CAS.
6. `@endo/gateway` vs `@endo/web-gateway` (naming).
7. Migration of the existing in-daemon `web-server-node.
   js` (builder-level transition).

§Honest-deferral-discipline (parallel to cycle 170's seven
open questions, cycle 149's three).
