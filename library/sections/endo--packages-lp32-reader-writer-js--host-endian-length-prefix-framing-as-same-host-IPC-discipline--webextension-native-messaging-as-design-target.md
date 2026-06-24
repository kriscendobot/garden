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
title: §WebExtension-native-messaging-as-design-target
parent: endo--packages-lp32-reader-writer-js--host-endian-length-prefix-framing-as-same-host-IPC-discipline
---

§The-README-cites-Mozilla's-native-messaging-docs. §This-is-
not-an-abstract-framing-protocol — it's a specific wire
protocol mandated by Chrome and Firefox for stdio-based
communication between a browser extension and a native helper
binary. §Endo-implements-it-so-that-an-Endo-runtime-can-be-the-
native-helper.

§Cycle-127-getGuardPayloads named "spec-driven implementation
discipline"; §lp32-is-a-similar-shape: the protocol is defined
externally (browser vendors), and the @endo package must match
it byte-for-byte. §Endianness-host-byte-order-is-not-a-design-
choice-Endo-made; it's a constraint inherited from the spec.

§Cycle-176-daemon-endor-architecture mentions WebExtension as
one of the daemon's potential hosts ("the daemon could run as
a native messaging helper"); §cycle-179-lp32-is-the-framing-
layer-that-makes-that-deployment-possible.
