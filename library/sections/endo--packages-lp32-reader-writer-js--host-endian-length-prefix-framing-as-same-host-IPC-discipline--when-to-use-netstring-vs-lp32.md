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
title: §When-to-use-netstring-vs-lp32
parent: endo--packages-lp32-reader-writer-js--host-endian-length-prefix-framing-as-same-host-IPC-discipline
---

§Cycle-167-where/index.js established that the daemon's CLI
socket speaks **netstring-framed CapTP**. §Cycle-141-daemon-
cas-management uses netstring for the envelope bus. §So-why-
not-just-use-netstring-everywhere?

§The-WebExtension-protocol-mandates-lp32-host-endian. §If-the-
daemon-deploys-as-a-WebExtension-native-helper, the framing
must be lp32. §Netstring-is-Endo's-internal-choice; §lp32-is-
the-external-protocol's-choice.

§Cycle-174-gateway-package mentioned multiple wire framings as
a forward-compatibility hedge; §lp32-and-netstring-are-the-two-
already-in-tree.
