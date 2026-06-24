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
title: §Ten-feature-decomposition
parent: endo-but-for-bots--llm-designs-gateway-package--ten-feature-decomposition-of-one-package-with-one-factory-many-configurations
---

| # | Feature | Phase |
|---|---------|-------|
| 1 | Chat hosting + payment-token enhancement | 2 (no payments) / 4 (reference adapter) |
| 2 | Virtual hosting (Host → Weblet formula) | 1 |
| 3 | Git over HTTP (formula-id bearer token) | 3 |
| 4 | UDS bootstrap for local CapTP relay registration | 2 |
| 5 | Familiar-bundled fallback on OS-assigned port | 3 |
| 6 | Public CapTP relay | 4 |
| 7 | Admin daemon | 2 (after UDS) |
| 8 | `/ocapn-cbor-np` WebSocket subprotocol | 1 |
| 9 | HTTPS terminating proxy compatibility | 4 |
| 10 | OS packaging (rpm/deb/PKGBUILD/Docker) | 4 |

§Each-feature-named-with-what-it-is + §how-it-composes-
with-existing-corpus + §which-questions-it-leaves-open.

§Feature-decomposition-encodes-the-maintainer-directive:
the design's "Problem" section reproduces the directive's
ten-feature list as the §scope-contract.

§Configuration-validated-at-startup: the `make({ ... })`
factory validates the dependency graph (relay needs
UDS+ocapn; admin needs UDS). §Misconfiguration-is-startup-
error not-runtime-discovery.
