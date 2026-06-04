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
---

# Unified Rust binary with three worker platforms and byte-identical CBOR envelopes

> §Endo-but-for-bots-design genre (designs-lane). Status:
> **Active**. Created 2026-04-16. §Sibling-design to
> cycle 141's daemon-cas-management (also Rust supervisor
> work).

`designs/daemon-endor-architecture.md` (806 lines) is the
**§Rust-supervisor-architecture-design** for `endor`, the
unified Rust binary that replaces the Node.js-only daemon
with a §native-supervisor routing messages between
workers running on multiple platforms.

The single most structurally interesting move is the
**§three-worker-platforms-with-byte-identical-CBOR-
envelopes**: workers can run as XS child process
(separate), XS in-process (shared), or Node.js child
process (node), and the §supervisor-is-transport-agnostic.

## §Why-the-Rust-supervisor

§The-Node.js-only-daemon-doesn't-scale to the deployment
shapes Endo now wants:
- Sandbox-managed workers with capability-safe filesystem.
- Multi-platform engine choice (XS for confined; Node for
  unconfined caplets).
- In-process workers for low-latency calls without process-
  spawn overhead.
- Native suspend/resume via CAS streaming.

§Rust-supervisor + §Node.js-or-XS-workers is the §two-
tier-architecture.

§Sibling-extract-pattern from §cycle-141-daemon-cas-
management: the §supervisor-owned-CAS belongs in the Rust
layer; the workers consume it via envelope verbs.

## §Two-crate-decomposition

```
rust/endo/       endo crate — supervisor, routing, process management
rust/endo/xsnap/ xsnap crate — XS engine bindings
```

§endo-crate-handles-routing-and-process-management:
supervisor, inbox routing, suspend/resume state.

§xsnap-crate-handles-XS-bindings: machine lifecycle, host
powers, envelope dispatch, snapshot I/O.

§Separation-of-routing-from-engine. §The-supervisor-doesn't-
know-XS-internals; §xsnap-handles-them.

§Reflects-cycle-141's-supervisor-owned-vs-worker-owned
decision: supervisor owns shared resources (routing, CAS,
filesystem); workers own JS execution.

## §Binary-as-multi-tool with six subcommands

```
endor daemon            — foreground daemon
endor start             — spawn detached daemon
endor stop              — graceful shutdown via SIGINT
endor ping              — liveness check
endor worker [-e xs]    — supervised XS worker child
endor run [-e xs] <ar>  — standalone archive runner
```

§One-binary-many-roles. §Subcommands-encode-the-role.

§-e-flag-selects-execution-engine (currently only XS
wired). §Worker-platform-for-spawned-workers-handled-by-
spawn-control-verb-not-CLI.

§Cycle-167's-where/index.js §protocol-suffix-in-socket-
names (captp0) is the §sibling-extensibility-via-naming;
this design's §subcommand-suffixes-as-role-selector is
the analog at the binary level.

## §Three-worker-platforms (the centerpiece)

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

## §Byte-identical-CBOR-envelopes across transports

```
Envelope { handle, verb, payload, nonce }
  CBOR 4-element array on the wire:
  [i64, text, bytes, i64]
```

§Both-separate-and-shared-workers-speak-byte-identical-
CBOR-envelopes. §The-supervisor-routing-layer-is-
transport-agnostic.

§Two-transport-implementations:
- **PipeTransport**: fd 3 (write) / fd 4 (read), for
  child-process workers.
- **ChannelTransport**: `std::sync::mpsc`, for in-process
  workers. §Pre-seeded-init-no-handshake-roundtrip.

§Same-protocol-different-substrate. §Cycle-119's-
envelope-protocol named this discipline; this design
implements it.

§Nonce-semantics: 0 = fire-and-forget; positive =
synchronous call (response carries same nonce). §Cycle-
162's-Ken-protocol-FIFO-via-TCP sibling.

## §Manager-must-be-co-resident (hard requirement)

> *The manager (initial peer) always runs in the same
> process as the supervisor message bus.*

§Hard-requirement-not-platform-preference. §The-daemon-
binary-is-self-contained. §Bootstrap-completes-without-
depending-on-external-process.

§Unlike-workers, the manager's hosting mode is §not-
caller-selectable. §Daemon-configuration-choice.

§Legacy-Node.js-child-mode (`ENDO_MANAGER_NODE=1`): exists
only for compatibility. §Co-resident-manager-is-the-
default-and-future.

§Cycle-141's-supervisor-owned-CAS depends on this: §the-
supervisor-and-the-manager-share-state.

## §Pool-of-machine-runner-threads

> *The daemon spawns a fixed pool of runner threads at
> startup (`ENDO_MACHINE_THREADS`, default = number of
> CPUs). Each runner thread hosts an event loop that
> drives one or more XS machines cooperatively.*

§XS-Machine-is-!Send-+-!Sync — each machine §pinned-to-a-
single-OS-thread for its lifetime.

§The-daemon-doesn't-create-a-new-thread-per-machine:
§one-runner-thread-can-host-many-machines.

§Cooperative-scheduling: §machines-yield-at-envelope-
boundaries. §JS-execution-within-one-dispatch-+-run-
promise-jobs-cycle-runs-to-completion.

§Risk: §a-CPU-bound-JS-computation-blocks-all-machines-
on-the-same-runner-thread. §Acceptable-trade-off-for-
shared-mode.

§Round-robin-or-least-loaded assignment of new machines
to runner threads.

## §Blocking-call-authorization

> *A caller can block on a callee only if the callee is
> an ancestor of the caller in the parent tree (or the
> callee is handle 0). This prevents deadlocks: a parent
> can call into a child synchronously, but a child cannot
> block its parent.*

§Deadlock-prevention-by-structure (parent tree).
§Blocking-by-default-is-unsafe; §authorize-blocking-via-
ancestry.

§Sync-calls (positive nonce, from ≠ 0): check
`can_block(caller, callee)` via parent chain. §Drop-the-
message-silently-if-not-authorized.

§The-tree-structure-of-handles enforces a §total-order-
within-a-process-subtree. §Calls-flow-up-the-tree;
§responses-flow-down.

§Cycle-162's-Ken-protocol §transactional-turns has a
sibling shape: §turn-boundaries-prevent-cross-vat-
deadlock. Here, §parent-tree-prevents-cross-handle-
deadlock.

## §Suspend-resume via CAS streaming

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

## §Unified-runner-four-mode-table

```
| Program | Transport | Mode |
|---------|-----------|------|
| Bundle  | Some      | Supervised peer (worker or manager) |
| Archive | Some      | Supervised archive (future) |
| Archive | None      | Standalone (endor run) |
| Bundle  | None      | Standalone bundle |
```

§One-function-four-modes: `run_xs_program(program,
creation, label, transport)`.

§Bundle-or-Archive-as-program-source. §Transport-Some-or-
None-as-supervisor-attached-or-not.

§Sibling-to-cycle-174-gateway-package's-§one-factory-
many-configurations and cycle-172-@endo/bytes's §extract-
into-own-package — §one-function-encodes-the-deployment-
space.

## §Suspend-and-resume-as-cooperative-with-Ken

§Cycle-162's-Ken-protocol-assessment named §transactional-
turns as one of seven Ken properties. The §endor-suspend-
and-resume implements §worker-level-checkpoint-and-restore
that maps to Ken's §atomic-checkpoint-before-transmit:

| Ken property | endor implementation |
|--------------|---------------------|
| Transactional turns | Cycle 162 ocap-kernel; here implicit via envelope-at-a-time |
| Output validity | Cycle 162 ocap-kernel; here: snapshot-after-quiesce |
| Deferred transmission | Cycle 162 ocap-kernel; here: outbox queue |
| Atomic checkpoint | §This-design's-CAS-stream-then-rename |
| Local recovery | §This-design's-resume-from-CAS |

§Endor-implements-Ken-properties-implicitly via the
suspend/resume + envelope routing.

§Synthesis-target: future endor work could §adopt-Ken-
vocabulary explicitly (cycle 162's §adopt-vocabulary-not-
implementation guidance).

## §CESU-8-surrogate-pair-encoding

> *XS stores strings in CESU-8 (surrogate-pair encoding
> for supplementary characters). `cesu8.rs` provides
> encode/decode between UTF-8 and CESU-8. Fast path: if no
> 4-byte UTF-8 sequences, CESU-8 == UTF-8.*

§Engine-specific-string-encoding requires §boundary-
translation. §Most-strings-are-ASCII-or-BMP — §fast-path
when no 4-byte UTF-8 sequences.

§Honest-implementation-detail: §XS-isn't-UTF-8-native;
§the-Rust-bindings-handle-the-difference.

## §Six-host-power-modules

```
fs       — 19 functions (file I/O via cap-std)
crypto   — 8 functions (SHA-256, random, Ed25519)
modules  — 2 functions (dynamic import, specifier resolve)
process  — 4 functions (pid, env, joinPath, realPath)
sqlite   — 9 functions (database operations via rusqlite)
debug    — debug protocol buffers (not host functions)
```

§Capability-safe-filesystem via cap-std (cycle 141 already
named this). §Cap-tempfile sibling.

§The-host-powers-are-the-caplet-attack-surface. §Each-
host-function-is-a-capability.

§Cycle-170's-daemon-capability-filesystem § Bazel-style-
selective-mounting applies here at the worker level: §the-
worker-sees-only-host-functions-it-was-granted.

## §Five-embedded-JS-bundles via include_str!

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

## §Renames-from-kind-to-platform (migration table)

| Old | New |
|-----|-----|
| `kind: 'locked'` | `platform: 'separate'` (default) |
| `kind: 'locked'` | `platform: 'shared'` (explicit) |
| `kind: 'node'` | `platform: 'node'` |
| `defaultWorkerKind` | `defaultPlatform` |
| `workerKind` | `workerPlatform` |

§Vocabulary-update: §kind-was-binary-locked-vs-node;
§platform-is-three-way-separate-shared-node.

§The-old-name-conflated-two-axes: confinement (locked vs
not) and engine (XS vs Node). §The-new-name-names-the-
actual-engine-choice.

§Migration-summary-table is the §rename-discipline pattern
(cycle 86's rename-discipline-skill is the canonical
form).

## §Eleven-endo-crate-modules + §five-xsnap-crate-modules

§The-endo-crate's-eleven-modules each have one
responsibility (supervisor, endo, inproc, proc, socket,
codec, engine, mailbox, paths, pidfile, types). §Single-
responsibility-per-module.

§The-xsnap-crate's-modules: Machine, runner, transport,
archive, cesu8, ses_boot. §Engine-specifics-stay-isolated.

§Reading-the-module-table-tells-you-the-architecture.

## §Path-resolution-mirrors-@endo/where

§Cycle-167's-@endo/where defined the path-resolution
surface in JS. §This-design-implements-the-same-shape-in-
Rust:

| Path | Env override | macOS default | Linux default |
|------|--------------|---------------|---------------|
| State | ENDO_STATE_PATH | ~/Library/Application Support/Endo | $XDG_STATE_HOME/endo |
| Ephemeral | ENDO_EPHEMERAL_STATE_PATH | (same as state) | $XDG_RUNTIME_DIR/endo |
| Socket | ENDO_SOCK_PATH | {ephemeral}/captp0.sock | {ephemeral}/captp0.sock |
| Cache | ENDO_CACHE_PATH | ~/Library/Caches/Endo | $XDG_CACHE_HOME/endo |

§Identical-conventions-across-runtime-implementations.
§The-deployment-shape-is-stable.

## §Three-related-designs

§Daemon-capability-bus: protocol specification that endor
implements.
§Daemon-xs-worker-snapshot: suspend/resume feature design.
§Daemon-xs-worker-debugger: XS debugger protocol.

§This-design-is-the-implementation; the §three-related-
designs are the §protocols-and-features the implementation
serves.

§Cycle-141-daemon-cas-management is the §implicit-fourth
(CAS is the storage substrate).

## §Gap-revealing-comparison with garden cycles

| Cycle | Connection |
|-------|------------|
| 141 (daemon-cas-management) | §Sibling-Rust-supervisor-work; CAS for snapshots |
| 162 (ken-protocol-assessment) | §Endor implements Ken properties implicitly; §adopt-vocabulary candidate |
| 167 (@endo/where) | §Path-resolution-shape mirrored in Rust |
| 170 (daemon-capability-filesystem) | §Bazel-style-selective-mounting applies at worker host-power level |
| 174 (gateway-package) | §Sibling-junction-design (this is daemon-side; that is gateway-side) |
| 175 (@endo/harden make-selector) | §Embedded-in-polyfills.js bootstrap |

## §Tier-1 vocabulary borrowing candidates

§Three-worker-platforms-with-byte-identical-CBOR-envelopes,
§supervisor-is-transport-agnostic, §graceful-downgrade-
shared-to-separate, §manager-must-be-co-resident,
§pool-of-machine-runner-threads, §blocking-call-
authorization-via-parent-tree, §suspend-resume-via-CAS-
streaming, §stream-then-rename-atomicity, §unified-runner-
four-mode-table, §five-embedded-JS-bundles-via-include_str.

§Tier-2: §CESU-8-surrogate-pair-encoding (XS string
quirk), §rename-discipline (kind → platform migration).

## §Synthesis-target

§Slot-machine-library may need similar §multi-platform-
worker-runtime if game logic runs in confined (XS) vs
unconfined (Node) modes. §Three-worker-platforms shape is
borrowable.

§Byte-identical-CBOR-envelopes-across-transports is the
§transport-agnostic-protocol pattern. §Sibling-to-cycle-
171's-§symmetric-stream-interface (Reader/Writer differ
only by convention).

## §A-complete-implementation-design (Status: Active)

§Status-Active (not Proposed, not Reference). §The-design-
is-current; §the-implementation-tracks-it.

§Sibling-to-cycle-168-daemon-checkin-checkout's-Complete-
status and cycle 174's Proposed-status: §three-design-
lifecycle-statuses now well-represented in the corpus
(Complete / Active / Proposed / Reference / Not Started).
