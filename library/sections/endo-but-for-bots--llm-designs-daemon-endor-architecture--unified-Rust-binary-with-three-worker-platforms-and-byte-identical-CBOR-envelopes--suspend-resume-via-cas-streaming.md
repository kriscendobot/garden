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
title: §Suspend-resume via CAS streaming
parent: endo-but-for-bots--llm-designs-daemon-endor-architecture--unified-Rust-binary-with-three-worker-platforms-and-byte-identical-CBOR-envelopes
---

> *The full snapshot never resides in memory — it streams
> through the XS write/read callbacks directly to/from
> disk.*

§Stream-don't-buffer. §Cycle-141's-daemon-cas-management
provides the CAS substrate; this design uses it for
worker snapshots.

§Suspend-flow:
1. Daemon sends `"suspend"` with CAS dir path.
2. Worker streams XS snapshot chunks via
   `fxWriteSnapshot`, computing SHA-256 on the fly.
3. Atomic rename to `{cas_dir}/{sha256}`.
4. Worker sends `"suspended"` with SHA-256 hex digest.
5. Daemon records (sha256, cas_dir) in SuspendedWorker;
   removes inbox; worker thread exits.

§Resume-flow:
1. Message arrives for suspended handle.
2. `route_message` calls `on_resume`.
3. Re-register handle, create channel transport, pre-seed
   `"restore"` init with CAS file path, spawn machine.
4. Worker calls `Machine::from_snapshot_file()`,
   §streaming-from-disk.
5. Pending message delivered after restore.

§SHA-256-as-content-address. §Atomic-rename-after-write
is the §write-then-publish discipline (cycle 141
sibling).

§Memory-bounded-snapshots: §arbitrarily-large-workers-
without-arbitrarily-large-memory.
