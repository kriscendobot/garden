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
title: §Eleven-endo-crate-modules + §five-xsnap-crate-modules
parent: endo-but-for-bots--llm-designs-daemon-endor-architecture--unified-Rust-binary-with-three-worker-platforms-and-byte-identical-CBOR-envelopes
---

§The-endo-crate's-eleven-modules each have one
responsibility (supervisor, endo, inproc, proc, socket,
codec, engine, mailbox, paths, pidfile, types). §Single-
responsibility-per-module.

§The-xsnap-crate's-modules: Machine, runner, transport,
archive, cesu8, ses_boot. §Engine-specifics-stay-isolated.

§Reading-the-module-table-tells-you-the-architecture.
