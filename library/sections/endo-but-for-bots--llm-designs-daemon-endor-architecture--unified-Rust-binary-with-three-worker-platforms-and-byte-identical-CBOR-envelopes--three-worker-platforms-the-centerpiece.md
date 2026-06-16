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
title: §Three-worker-platforms (the centerpiece)
parent: endo-but-for-bots--llm-designs-daemon-endor-architecture--unified-Rust-binary-with-three-worker-platforms-and-byte-identical-CBOR-envelopes
---

| Requested | Resolved to | Condition |
|-----------|-------------|-----------|
| `"separate"` (default) | XS child process | Always available |
| `"shared"` | XS in supervisor process | XS linked into binary |
| `"shared"` | XS child process | XS not linked (§graceful-downgrade) |
| `"node"` | Node.js child process | NODE_BIN env or PATH |
| `"node"` | Error | No Node.js binary found |

§Three-platforms-resolve-to-actual-execution-engine via
`engine_for_spawn_request()`.

§Separate-is-default-and-preferred: §fault-isolation (a
crash in one worker doesn't take down others). §Each-
worker-in-its-own-OS-process.

§Shared-runs-in-supervisor-process: §no-process-spawn-
overhead, §no-pipe-I/O-serialization, §lower-per-worker-
memory-footprint. §Trade-off: §no-fault-isolation;
§cooperative-scheduling.

§Node-required-for-unconfined-caplets-that-depend-on-
Node.js-APIs. §No-silent-downgrade for Node (would break
caplet semantics).

§Graceful-downgrade-for-shared-but-not-Node: if XS isn't
linked into the binary, shared falls back to a child
process. §Caller-should-not-rely-on-shared-semantics-for-
correctness — it is a §performance-hint.
