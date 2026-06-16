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
title: §Two-files-with-shared-semantics-via-host-endian-js
parent: endo--packages-lp32-reader-writer-js--host-endian-length-prefix-framing-as-same-host-IPC-discipline
---

§The-host-endian-probe-runs-once-at-module-load. §Both-reader
and writer import the constant. §If-they-imported-different-
copies-or-if-the-probe-were-non-deterministic, the encoded
and decoded length prefixes could disagree — a write of length
5 could be read back as length 0x05000000 (= 83 886 080).

§This-is-the-classic-endianness-mismatch-bug. §lp32-avoids-it-
by-using-a-single-shared-host-endian-constant: on any given
host, reader and writer always agree because both consult the
same probe.

§Cross-host-deployment: §a-little-endian-x86-laptop-cannot-
exchange-lp32-messages-with-a-big-endian-mainframe-over-the-
network. §But-lp32-is-not-a-network-protocol — it's stdio
within one OS process tree, where both sides run on the same
CPU. §The-constraint-and-the-design-match.
