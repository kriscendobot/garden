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
title: §Supersedes-vs-deprecates
parent: endo-but-for-bots--llm-designs-gateway-package--ten-feature-decomposition-of-one-package-with-one-factory-many-configurations
---

> *Supersedes [`endo-gateway`](endo-gateway.md).*

§Supersedes-≠-deprecates. The prior `endo-gateway` design
is **not** removed; its specific decisions carry forward
unless explicitly revised.

§Three-design-lifecycle-statuses-now-distinguished in the
library:
- **Deprecated** (cycle 99's chat-reply-chain): fully
  removed.
- **Supersedes-but-keeps-decisions** (this design): prior
  design is reference; new design extends.
- **Revision-note-refined-not-deprecated** (cycle 107's
  daemon-agent-tools): prior design carries forward with
  named successors that refine specific aspects.

§Each-has-a-different-archival-shape. §Supersedes-keeps-
the-prior-as-citable-reference.
