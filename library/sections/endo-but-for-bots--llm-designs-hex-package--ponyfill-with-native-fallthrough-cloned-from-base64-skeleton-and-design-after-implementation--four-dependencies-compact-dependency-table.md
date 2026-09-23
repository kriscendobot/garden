---
source: designs/hex-package.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_url: https://github.com/endojs/endo-but-for-bots/blob/llm/designs/hex-package.md
section_kind: design
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - hardened-javascript
  - tooling
status_at_ingest: Complete
genre: §endo-but-for-bots-design §canonical-leaf-package-pattern
cycle: 180
lane: designs
status: current
title: §Four-Dependencies (compact dependency table)
parent: endo-but-for-bots--llm-designs-hex-package--ponyfill-with-native-fallthrough-cloned-from-base64-skeleton-and-design-after-implementation
---

| Design | Relationship |
|---|---|
| `base64-native-fallthrough.md` (sibling, in parallel) | Shares the runtime-detection pattern. |
| `daemon-256-bit-identifiers` (Complete) | Identifiers are 64-char lowercase hex; largest single consumer |
| `daemon-agent-network-identity` (Planned) | Agent keypair bytes over wire as hex |
| `ocapn-noise-network` (Planned) | 32-byte public keys + 16-byte nonces rendered as hex |

§Sibling-design `base64-native-fallthrough.md` is the §parallel-
sibling sharing the detection pattern. §If-one-design-diverges,
the other should be updated for consistency. §This-is-§lockstep-
sibling-design-discipline.

§Compare-to-cycle-174-gateway-package's §eighteen-dependencies.
§This-design has §four. §Hex-is-a-leaf; §gateway-is-a-junction.
§Dependency-count-correlates-with-design-position-in-the-stack.
