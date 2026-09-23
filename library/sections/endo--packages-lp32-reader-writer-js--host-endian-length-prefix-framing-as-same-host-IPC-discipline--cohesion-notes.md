---
source: packages/lp32/{reader,writer}.js
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/tree/master/packages/lp32
source_path: packages/lp32/reader.js, packages/lp32/writer.js, packages/lp32/src/host-endian.js
section_kind: source
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - streams
  - captp
genre: §endo-source-comment-fragment
cycle: 179
lane: chat
status: current
title: §Cohesion notes
parent: endo--packages-lp32-reader-writer-js--host-endian-length-prefix-framing-as-same-host-IPC-discipline
---

- §Sibling-encoding-pair with cycle 177 (netstring/reader.js).
  Same problem (length-prefixed framing), different decisions
  on every axis: encoding (ASCII vs binary), endianness
  (irrelevant vs host), state (explicit vs implicit), buffer
  (two vs one), zero-copy (yes vs no).
- §The-WebExtension-Native-Messaging spec is the §external
  constraint that forces every design decision. §Compare-to-
  cycle-127-getGuardPayloads' §spec-driven-implementation-
  discipline.
- §Cycle-179-lp32 + cycle-177-netstring + cycle-171-stream/
  index.js = §three-layer-stream-stack: §generic-Reader/
  Writer-types → §two-concrete-framing-codecs.
- §Host-endian-probe is a §runtime-environment-detection
  pattern; cycle 152 pass-style/symbol.js had a similar
  §runtime-Symbol-probe.
- §"Must allocate to support concurrent reads" is the §key-
  correctness-comment, like cycle 130 message-breakpoints'
  §between-turns-not-within comment.
- §1MB-default-matches-WebExtension-limit — §spec-conformance
  even in the defaults.
- §All-factories-and-resulting-iterators-hardened — §consumer-
  of-cycle-175's-harden-discipline.
