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
title: §Five-embedded-JS-bundles via include_str!
parent: endo-but-for-bots--llm-designs-daemon-endor-architecture--unified-Rust-binary-with-three-worker-platforms-and-byte-identical-CBOR-envelopes
---

```
polyfills.js       — harden, assert, TextEncoder stubs
host_aliases.js    — globalThis.host* → unprefixed names
ses_boot.js        — SES lockdown + HandledPromise shim
worker_bootstrap.js — Worker: bus-xs-core + single CapTP session
daemon_bootstrap.js — Manager: multiplexed CapTP sessions
```

§Embedded-at-compile-time-via-include_str!. §No-runtime-
file-resolution-for-bootstrap. §Self-contained-binary.

§Cycle-175's-§race-to-install-harden mechanism is what
polyfills.js uses. §The-Rust-binary-bundles-the-@endo/
harden-selector + makeHardener inside its embedded JS.
