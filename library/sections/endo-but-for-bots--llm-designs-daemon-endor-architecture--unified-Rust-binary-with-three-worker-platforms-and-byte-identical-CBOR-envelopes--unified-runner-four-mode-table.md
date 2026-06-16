---
source: designs/daemon-endor-architecture.md
source_repo: endojs/endo-but-for-bots
source_url: https://github.com/endojs/endo-but-for-bots/blob/llm/designs/daemon-endor-architecture.md
source_path: designs/daemon-endor-architecture.md
source_branch: llm
section_kind: design
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - daemon
  - tooling
  - hardened-javascript
genre: §endo-but-for-bots-design
cycle: 176
lane: designs
status: current
title: §Unified-runner-four-mode-table
parent: endo-but-for-bots--llm-designs-daemon-endor-architecture--unified-Rust-binary-with-three-worker-platforms-and-byte-identical-CBOR-envelopes
---

```
| Program | Transport | Mode |
|---------|-----------|------|
| Bundle  | Some      | Supervised peer (worker or manager) |
| Archive | Some      | Supervised archive (future) |
| Archive | None      | Standalone (endor run) |
| Bundle  | None      | Standalone bundle |
```

§One-function-four-modes: `run_xs_program(program,
creation, label, transport)`.

§Bundle-or-Archive-as-program-source. §Transport-Some-or-
None-as-supervisor-attached-or-not.

§Sibling-to-cycle-174-gateway-package's-§one-factory-
many-configurations and cycle-172-@endo/bytes's §extract-
into-own-package — §one-function-encodes-the-deployment-
space.
