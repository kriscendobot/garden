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
title: §Six-host-power-modules
parent: endo-but-for-bots--llm-designs-daemon-endor-architecture--unified-Rust-binary-with-three-worker-platforms-and-byte-identical-CBOR-envelopes
---

```
fs       — 19 functions (file I/O via cap-std)
crypto   — 8 functions (SHA-256, random, Ed25519)
modules  — 2 functions (dynamic import, specifier resolve)
process  — 4 functions (pid, env, joinPath, realPath)
sqlite   — 9 functions (database operations via rusqlite)
debug    — debug protocol buffers (not host functions)
```

§Capability-safe-filesystem via cap-std (cycle 141 already
named this). §Cap-tempfile sibling.

§The-host-powers-are-the-caplet-attack-surface. §Each-
host-function-is-a-capability.

§Cycle-170's-daemon-capability-filesystem § Bazel-style-
selective-mounting applies here at the worker level: §the-
worker-sees-only-host-functions-it-was-granted.
