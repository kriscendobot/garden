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
title: §The-gateway-becomes-a-thing-in-its-own-right
parent: endo-but-for-bots--llm-designs-gateway-package--ten-feature-decomposition-of-one-package-with-one-factory-many-configurations
---

> *The shorter framing: **the gateway is becoming a thing
> in its own right; give it a package.***

§Extract-pattern parallel to cycle 172's @endo/bytes (also
extract-into-own-package), but **at the full subsystem
level** rather than the utility-helper level.

§Five-deployment-shapes the existing in-daemon gateway
can't serve:

1. Per-host system service (virtual-host many users on one
   address; UNIX-domain bootstrap socket).
2. Public web service (internet-reachable; Chat + Git +
   OCapN-Noise WS + weblets).
3. Familiar-bundled fallback (OS-assigned port; single
   user; no UDS).
4. CapTP relay-as-a-service (customers or public).
5. Administrator handle (system admin, distinct from user
   daemon authority).

§A-single-binary-configuration-cannot-serve-all is the
forcing function. §Configuration-gates-features.
