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
title: §X-Forwarded-trust-model
parent: endo-but-for-bots--llm-designs-gateway-package--ten-feature-decomposition-of-one-package-with-one-factory-many-configurations
---

> *The gateway must trust them only when the immediate TCP
> peer is a configured proxy.*

§CIDR-allowlist-of-trusted-proxies. §Requests-from-outside-
allowlist-treated-as-direct-client (X-Forwarded ignored,
TCP peer IP is client IP, Host header at face value).

§The-trust-boundary-is-the-TCP-peer-not-the-X-Forwarded-
contents. §Forwarded-headers-are-trustable-only-from-
trusted-peers.

§Two-config-parameters: §CIDR-allowlist + §max-hops-to-
trust. §Both-named.
