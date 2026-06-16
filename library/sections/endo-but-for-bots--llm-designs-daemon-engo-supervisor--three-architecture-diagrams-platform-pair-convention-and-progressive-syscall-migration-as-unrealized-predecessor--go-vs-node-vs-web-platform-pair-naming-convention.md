---
source: designs/daemon-engo-supervisor.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_url: https://github.com/endojs/endo-but-for-bots/blob/llm/designs/daemon-engo-supervisor.md
section_kind: design
ingested: 2026-06-05
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - daemon
  - capability-security
status_at_ingest: Not Started
genre: §endo-but-for-bots-design §unrealized-predecessor-of-cycle-176
cycle: 192
lane: designs
status: current
title: §-go-vs-node-vs-web platform-pair-naming-convention
parent: endo-but-for-bots--llm-designs-daemon-engo-supervisor--three-architecture-diagrams-platform-pair-convention-and-progressive-syscall-migration-as-unrealized-predecessor
---

```
| Platform | Daemon entry | Powers module | Worker entry | Worker powers |
|----------|-------------|---------------|-------------|---------------|
| Node.js  | `daemon-node.js` | `daemon-node-powers.js` | `worker-node.js` | `worker-node-powers.js` |
| Go (engo) | `daemon-go.js` | `daemon-go-powers.js` | `worker-go.js` | `worker-go-powers.js` |
| Web (future) | `daemon-web.js` | `daemon-web-powers.js` | — | — |
```

§Four-file-quadruple-per-platform: daemon + daemon-powers +
worker + worker-powers. §Each-platform-pair is §a-distinct-
file-quadruple. §The-naming-convention is §-platform.js + §-
platform-powers.js for both daemon and worker entry points.

§Why-the-convention-matters: §near-copies-with-channel-
adapted is the §migration-path. §`daemon-go.js` is initially-
a-near-copy of `daemon-node.js` with the §key-difference being
that `makeWorker` sends a spawn-envelope to engo instead of
calling `child_process.fork()`. §Over-time the -go-powers
modules §progressively-replace-Node.js-API-calls with
syscalls (envelope-protocol messages to engo).

§Compare-to-cycle-167-where/index.js' §per-platform-naming-
conventions (POSIX lowercase / macOS CapitalE-space / Windows
CapitalE-backslash). §Both-are-§platform-pair-naming-
discipline at different layers; cycle 167 names §runtime-
discovery-paths; cycle 192 names §source-file-quadruples.

§Compare-to-cycle-176-endor-architecture's §three-worker-
platforms-with-byte-identical-CBOR-envelopes. §Cycle-176-
worker-platforms are (separate-XS / shared-XS / Node.js); §cycle-
192-worker-platforms are (Node.js / Go / Wasm in future). §The-
Wasm-worker-platform is named-but-not-built in either design.
