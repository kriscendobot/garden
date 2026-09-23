---
source: packages/stream/index.js
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/blob/master/packages/stream/index.js
source_path: packages/stream/index.js
section_kind: source
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - streams
  - patterns
  - captp
genre: §endo-source-comment-fragment
cycle: 171
lane: chat
status: current
title: §The-stream-substrate-ecosystem
parent: endo--packages-stream-index-js--symmetric-async-iterator-streams-with-makeQueue-makePipe-pump-and-prime-utilities
---

§This-file-is-the-substrate-many-files-depend-on:

- **Cycle 137 daemon-message-streaming**: uses streams to
  carry §progressive-text-delivery across CapTP. The
  design's §stream-formula leans on this file's makePipe.
- **Cycle 163 ocap-kernel glossary**: notes `@endo/stream`
  as the shared substrate between Endo's stream concept
  and ocap-kernel's channel concept. §Different-vocabulary-
  same-substrate.
- **Cycle 154 trap.js**: the synchronous-trap mechanism
  doesn't use streams directly, but cycle 169's atomics.js
  has the §async-generator-as-resumable-state-machine
  pattern that mirrors §makeStream's three-method shape.
- **Cycle 158 loopback.js**: cross-wires two CapTP
  instances using two streams.
- **@endo/captp wire transport**: any CapTP connection is
  built on a Reader/Writer pair.

§Cycle-156-finalize.js's-WeakValueMap-GC is unrelated to
streams directly but the patterns are sibling: §async-data-
structures-with-careful-lifecycle.
