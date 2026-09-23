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
title: §`/ocapn-cbor-np`-WebSocket-subprotocol (Feature 8)
parent: endo-but-for-bots--llm-designs-gateway-package--ten-feature-decomposition-of-one-package-with-one-factory-many-configurations
---

> *The path encodes the codec/network pair (CBOR + Noise
> Protocol) so future siblings (`/ocapn-syrups-tcp`,
> `/ocapn-cbor-tls`) can coexist without renaming the
> OCapN slot.*

§Path-name-encodes-codec-and-network:
- `ocapn`: protocol family
- `cbor`: payload codec
- `np`: Noise Protocol network identifier

§Future-extensibility-via-naming. §Bare-`/ocapn`-becomes-
compatibility-alias.

§Revises-endo-gateway's-`/ocapn`-decision. §Naming-as-
extension-point pattern; §don't-collide-on-the-bare-name.

§Cycle-167's-protocol-suffix-in-socket-names (captp0
default) is the §sibling-discipline at the socket-path
layer. §Both-name-the-protocol-version-in-the-resource-
name.
