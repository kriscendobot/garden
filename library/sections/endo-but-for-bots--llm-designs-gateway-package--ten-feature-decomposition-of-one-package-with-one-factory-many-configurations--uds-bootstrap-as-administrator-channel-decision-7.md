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
title: §UDS-bootstrap-as-administrator-channel (Decision 7)
parent: endo-but-for-bots--llm-designs-gateway-package--ten-feature-decomposition-of-one-package-with-one-factory-many-configurations
---

> *Admin authority is not on the network surface.*

§GatewayAdmin-exo-accessible-only-over-UDS. §Never-on-
public-HTTP-surface.

§The-administrator-handle-is-the-UDS-bootstrap-itself:
filesystem permissions on the socket gate who-may-connect;
proof-of-possession gates which-public-keys-may-register.

§Two-gates-with-different-roles: §filesystem-permissions
+ §cryptographic-proof-of-possession.

§Cycle-170's-§three-layer-architecture has a sibling
shape: §authority-is-which-capabilities-you-can-reach via
*which channel*. The UDS channel reaches more
capabilities than the public network channel does.
