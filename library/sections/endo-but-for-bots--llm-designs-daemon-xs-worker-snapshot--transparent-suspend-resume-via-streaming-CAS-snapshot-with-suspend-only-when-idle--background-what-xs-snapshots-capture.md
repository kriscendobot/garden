---
source: designs/daemon-xs-worker-snapshot.md
source_repo: endojs/endo-but-for-bots
source_url: https://github.com/endojs/endo-but-for-bots/blob/llm/designs/daemon-xs-worker-snapshot.md
source_path: designs/daemon-xs-worker-snapshot.md
source_branch: llm
section_kind: design
ingested: 2026-06-04
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - daemon
  - persistence
  - patterns
genre: §endo-but-for-bots-design
cycle: 178
lane: designs
status: current
title: "§Background: §what-XS-snapshots-capture"
parent: endo-but-for-bots--llm-designs-daemon-xs-worker-snapshot--transparent-suspend-resume-via-streaming-CAS-snapshot-with-suspend-only-when-idle
---

§XS-has-`fxWriteSnapshot`/`fxReadSnapshot` for §complete-
JS-heap-image:

**§Captured**:
- All slot heaps (objects, arrays, closures, scope
  chains).
- All chunk blocks (strings, ArrayBuffers, BigInts).
- The stack (only preserved slots).
- Key/name/symbol tables.
- Promise job queue state.

**§NOT-captured**:
- Host function pointers (replaced with callback table
  indices).
- Host context pointers (`the->context`).
- Platform state (timers, I/O handles, file descriptors).
- Debug state.

§The-host-side-must-be-rebuilt-on-restore. §JS-heap-is-
fully-restored; §native-bindings-are-re-installed.

§Three-axes-of-incompatibility (snapshot bound to):
- §XS-version.
- §Architecture (32/64-bit, endianness).
- §Callback-table-layout.

§A-signature-string-identifies-the-callback-table-version.
§If-signature-doesnt-match-fxReadSnapshot-fails.
