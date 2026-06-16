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
title: §Why-the-Rust-supervisor
parent: endo-but-for-bots--llm-designs-daemon-endor-architecture--unified-Rust-binary-with-three-worker-platforms-and-byte-identical-CBOR-envelopes
---

§The-Node.js-only-daemon-doesn't-scale to the deployment
shapes Endo now wants:
- Sandbox-managed workers with capability-safe filesystem.
- Multi-platform engine choice (XS for confined; Node for
  unconfined caplets).
- In-process workers for low-latency calls without process-
  spawn overhead.
- Native suspend/resume via CAS streaming.

§Rust-supervisor + §Node.js-or-XS-workers is the §two-
tier-architecture.

§Sibling-extract-pattern from §cycle-141-daemon-cas-
management: the §supervisor-owned-CAS belongs in the Rust
layer; the workers consume it via envelope verbs.
