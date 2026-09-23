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
title: §Four-phase-rollout
parent: endo-but-for-bots--llm-designs-gateway-package--ten-feature-decomposition-of-one-package-with-one-factory-many-configurations
---

| Phase | Content |
|-------|---------|
| 1 | Package skeleton + feature 2 (vhost) + feature 8 (OCapN-WS) |
| 2 | Feature 4 (UDS) + feature 7 (admin) + feature 1 (Chat + ledger) |
| 3 | Feature 5 (Familiar-bundled) + feature 3 (Git HTTP) |
| 4 | Feature 6 (relay) + feature 9 (HTTPS proxy) + feature 10 (OS packaging) + payment-processor adapter |

§Phases-are-sequential-on-critical-path (1+2 deliver
feature parity with existing in-daemon gateway). §Phases-
3-and-4-are-independently-order-able after Phase 2.

§Cycle-172's-decoupled-rollout has a sibling shape; the
gateway design is larger so the phase boundaries are §at-
the-subsystem-level not §at-the-helper-level.
