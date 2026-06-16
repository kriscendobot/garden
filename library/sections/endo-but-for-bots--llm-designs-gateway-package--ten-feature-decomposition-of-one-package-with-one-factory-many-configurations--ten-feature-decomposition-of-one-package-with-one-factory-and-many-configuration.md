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
title: Ten-feature decomposition of one package with one factory and many configurations
parent: endo-but-for-bots--llm-designs-gateway-package--ten-feature-decomposition-of-one-package-with-one-factory-many-configurations
---

> §Endo-but-for-bots-design genre (designs-lane). §The-
> researcher-tracked-gap from cycle 173's message
> `224238Z-message-liaison-44760a.md` (gap 1 of 4). Picked
> freely on cycle 174's natural designs-lane slot per
> *Pick freely, but track for future work*.
>
> Status: **Proposed**. Created 2026-05-22. Supersedes
> [`endo-gateway`](endo-gateway.md). Lives on the
> `design/gateway-package` branch (not master or llm).

`designs/gateway-package.md` (1157 lines) is the
**§overarching-design-driving-the-entire-gateway-package-
phase-stack** (Phases 1–11+ landing as stacked PRs against
`master`). Every gateway-phase dispatch reads it; the
library previously proxied it through per-phase result
entries (Phase 7, 10, 11a builder results). Ingesting
compresses that chain.

The single most structurally interesting move is the
**§ten-feature-decomposition-of-one-package** with
§one-factory-many-configurations — the same `@endo/gateway`
code runs as developer-install, system-service, Familiar-
bundled-fallback, and public-relay depending on
configuration.
