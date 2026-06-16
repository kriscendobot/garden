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
title: §External-TLS-via-reverse-proxy (Feature 9)
parent: endo-but-for-bots--llm-designs-gateway-package--ten-feature-decomposition-of-one-package-with-one-factory-many-configurations
---

> *The gateway does **not** terminate TLS itself.*

§Gateway-has-no-certificate-management-no-ACME-client-no-
cipher-suite-configuration.

§External-TLS-via-reverse-proxy (nginx, Caddy, Cloudflare,
Traefik).

§Cycle-139-daemon-docker-selfhost named this at the daemon
layer (§design-as-deferral; TLS is a proxy concern); this
design extends it to the gateway. §Same-decision-different-
layer.

§Why-this-is-good: §avoids-bundling-certificate-management
(Let's Encrypt renewal, OCSP stapling, TLS suite selection
are non-trivial moving targets).

§Defense-in-depth: HTTPS on the OCapN endpoint is *only*
defense-in-depth; OCapN's confidentiality is provided by
Noise in-band per cycle 162's Ken / cycles 119/137 envelope
+ streaming.
