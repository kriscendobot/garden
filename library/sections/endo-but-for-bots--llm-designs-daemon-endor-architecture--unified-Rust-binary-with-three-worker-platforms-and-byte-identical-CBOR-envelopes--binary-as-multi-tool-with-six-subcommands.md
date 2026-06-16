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
title: §Binary-as-multi-tool with six subcommands
parent: endo-but-for-bots--llm-designs-daemon-endor-architecture--unified-Rust-binary-with-three-worker-platforms-and-byte-identical-CBOR-envelopes
---

```
endor daemon            — foreground daemon
endor start             — spawn detached daemon
endor stop              — graceful shutdown via SIGINT
endor ping              — liveness check
endor worker [-e xs]    — supervised XS worker child
endor run [-e xs] <ar>  — standalone archive runner
```

§One-binary-many-roles. §Subcommands-encode-the-role.

§-e-flag-selects-execution-engine (currently only XS
wired). §Worker-platform-for-spawned-workers-handled-by-
spawn-control-verb-not-CLI.

§Cycle-167's-where/index.js §protocol-suffix-in-socket-
names (captp0) is the §sibling-extensibility-via-naming;
this design's §subcommand-suffixes-as-role-selector is
the analog at the binary level.
