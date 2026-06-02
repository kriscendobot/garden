---
section: daemon-as-message-router-with-envelope-protocol-and-handle-rewriting
source: endo-but-for-bots--llm-designs-daemon-capability-bus
topics: [daemon, capability-security]
status: current
---

# Daemon-as-message-router with envelope-protocol and handle-rewriting

> *The **daemon** is the long-running top-level process that owns
> the PID file and Unix socket, routes envelopes between its
> children, and enforces the sync-call spawn tree — the daemon
> ***is*** the capability bus. It runs no JavaScript itself.*
>
> — `designs/daemon-capability-bus.md` §Terminology

`daemon-capability-bus.md` is *In Progress*, dated 2026-02-25 (created)
/ 2026-04-11 (updated), authored by Kris Kowal. The 526-line design
records a **worldview shift**: the Endo daemon stops being a Node.js
process supervising Node.js workers, and becomes a *language-agnostic
message router* — a standalone Go or Rust binary that speaks one wire
protocol to every subprocess, JavaScript or otherwise. Phases 0-3
already shipped; phases 4-5 (syscall migration) are unbounded
follow-on work.

## The three architectures

The design opens with three boxed diagrams that lay out the migration
arc. The current arch is *flat-supervisor*:

```
endo (CLI) ──► node daemon ──►* node worker
```

The target arch of this design moves the supervisor *out* of Node.js
into a dedicated bus daemon — and demotes the former JS daemon to a
peer of its own workers:

```
                         ┌─► node manager  (or xs manager)
endo (CLI) ──► daemon ───┤
                         └─►* worker (node or xs)
```

The *future arch* (explicitly out-of-scope here, but the design points
to it) adds wasm workers and platform I/O as direct children of the
bus daemon:

```
endo (CLI) ─┐
daemon ──────┼─► node manager
              ├─►* node worker
              ├─►* xs worker
              ├─►* wasm worker
              └─► platform I/O (fs, net, crypto)
```

The key topology move is *workers are children of the daemon, not of
the manager*. The manager *requests* worker creation; the daemon
*owns* every subprocess. Killing the daemon terminates the whole tree.

## *the daemon does no JavaScript* — and what that buys

The §What is the Problem Being Solved section lists four pressures:
(1) *process supervision with OS-level control* (signals, resource
limits, sandbox-exec / namespaces / seccomp), (2) *a message-passing
substrate not tied to a Node.js host*, (3) *a path to richer platform
services* progressively assumed by the supervisor (the syscall
migration), and (4) *decoupling from Node.js runtime concerns* — SES
lockdown, V8 quirks, and npm dependency management stay inside
workers where they belong.

The *daemon runs no JavaScript* discipline is the structural
consequence. The daemon is what `endor start` brings up; the
*manager* (the privileged child) is what runs `daemon.js` and owns
the formula graph, pet-name store, and CapTP multiplexer. The manager
can be either Node.js (`bus-daemon-node.js`) or XS-hosted inside the
same Rust binary as the daemon (`endor manager -e xs`). The Rust
daemon and the native Rust/XS worker live in the same binary: `endor`
dispatches to daemon, manager child, worker, or standalone archive
runner by subcommand.

## The platform-pair table — what *bus-* prefixes denote

The §Relationship to the existing daemon table is the design's most
load-bearing index:

| Platform | Manager entry | Powers module | Worker entry | Worker powers |
|----------|--------------|---------------|-------------|---------------|
| Node.js (in-process) | `daemon-node.js` | `daemon-node-powers.js` | `worker-node.js` | `worker-node-powers.js` |
| Bus (Node manager) | `bus-daemon-node.js` | `bus-daemon-node-powers.js` | `bus-worker-node.js` | `bus-worker-node-powers.js` |
| Bus (XS manager) | `bus-daemon-rust-xs.js` | — | `bus-worker-xs.js` | — |

The `-node.js` / `-node-powers.js` module convention already
anticipated multiple platform backends; the bus is a *new platform
pair* that introduces a new role (manager) where the old role
(in-process daemon) used to live. The design explicitly resolves a
naming confusion: *the bus-daemon-*.js files implement the manager
role, not the daemon role*. The `bus-` prefix denotes participation
in the capability-bus protocol, not a role; the daemon *is* the bus,
and these files describe the wire format that the manager, workers,
and the daemon all speak. The `daemon` in the filename is kept for
symmetry with the formula-runtime's existing `daemon-*` files.

## The envelope-protocol surface

The §Subprocess protocol section defines what *one wire format for
every subprocess* actually means. All subprocesses — manager and
workers alike — communicate with the daemon using the same envelope
protocol on fd 3/4. The pipe layout:

| fd | Direction | Purpose |
|----|-----------|---------|
| 0  | inherited | stdin (unused, closed) |
| 1  | inherited | stdout → daemon log capture |
| 2  | inherited | stderr → daemon log capture |
| 3  | child → parent | CBOR-framed envelopes from subprocess |
| 4  | parent → child | CBOR-framed envelopes to subprocess |

Each envelope is a four-tuple CBOR array:

```
[handle: uint, verb: text, payload: bytes, nonce: uint]
```

- **handle** identifies the target (outgoing) or sender (incoming)
- **verb** is the operation name (`"init"`, `"spawn"`, `"deliver"`,
  `"ready"`, `"log"`, ...)
- **payload** is CBOR-encoded operation-specific data
- **nonce** is 0 for fire-and-forget; >0 for request/response
  correlation

The *startup sequence* is a four-step handshake: daemon spawns
manager with `ExtraFiles = [fd3_write, fd4_read]`; daemon sends
`[managerHandle, "init", empty, 0]`; the manager reads the init
envelope, extracts config, and starts up normally; the manager
signals `[0, "ready", empty, 0]`.

The *handle topology* assigns:

| Handle | Entity | Notes |
|--------|--------|-------|
| 0 | Daemon (control plane) | Always handle 0 |
| 1 | Manager child | First subprocess |
| 2+ | Workers | Spawned by the daemon on manager request |

## Handle-rewriting — the *both sides see their counterpart's
identity* trick

The most structurally interesting mechanism is in §Worker spawning.
When the manager (handle 1) sends to worker N, the daemon delivers
the message to worker N with the handle field *rewritten to 1* (the
manager's handle). When worker N sends to handle 1, the daemon
delivers to the manager with the handle field *rewritten to N*. This
trick means *both sides can identify their counterpart without an
explicit sender field*:

```
manager ──[N, "deliver", payload, 0]──► daemon ──[1, "deliver", payload, 0]──► worker(N)
worker(N) ──[1, "deliver", payload, 0]──► daemon ──[N, "deliver", payload, 0]──► manager
```

This is a *symmetric handle rewriting* discipline: the handle field
always denotes the local-side identity of *the peer*. Worker N sees
incoming messages stamped with handle 1 ("from the manager"); the
manager sees incoming messages stamped with handle N ("from worker
N"). No header field is needed.

## CapTP-over-envelope — the encapsulation that lets CapTP not know

The existing manager-worker communication uses CapTP (Capability
Transfer Protocol) over netstring-framed pipes. Under the bus, this
CapTP traffic is carried inside envelope payloads:

1. The manager establishes a CapTP session for each worker, as the
   in-process daemon did previously.
2. Instead of reading/writing netstring frames on raw pipes,
   `bus-daemon-node-powers.js` wraps CapTP frames in envelopes:
   `[workerHandle, "deliver", frameBytes, 0]`.
3. `bus-worker-node-powers.js` unwraps envelopes back into CapTP
   frames for the worker's CapTP layer.

This *encapsulation is transparent to the CapTP layer* — it sees the
same reader/writer interface. The envelope framing adds the handle
routing needed for the daemon to deliver messages to the correct
subprocess. CapTP doesn't need to know it's now multiplexed through a
single fd-pair per subprocess.

## The five bus-*.js modules — what *makeWorker no longer forks* means

The §The bus-*.js modules section is a five-file decomposition of the
bus-protocol surface:

- **`bus-daemon-node.js`** — Node.js manager child entry point.
  Establishes envelope reader/writer on fd 3/4, reads init envelope
  for its handle, constructs `bus-daemon-node-powers`, calls
  `daemon.js` (the shared core) with bus-specific powers, signals
  ready.

- **`bus-daemon-node-powers.js`** — *the key structural move*. A
  derivative of `daemon-node-powers.js` where `makeWorker` no longer
  forks a child. Instead it sends `[0, "spawn", {command, args},
  rid]` to the daemon and awaits a `"spawned"` response with the
  worker's handle. Then it establishes a CapTP session over
  envelope-framed messages to that handle. Also hosts future syscall
  stubs (`readFile`, `writeFile`, `listen`) that initially delegate
  to Node.js but can be individually replaced with daemon calls.

- **`bus-worker-node.js`** — Node.js worker entry point. Reads its
  handle from the init envelope on fd 4; rest of worker lifecycle
  (loading guest modules, evaluating code) is unchanged.

- **`bus-worker-node-powers.js`** — minimal worker powers. Provides
  a reader/writer pair backed by the envelope protocol on fd 3/4
  rather than raw Node.js pipe streams. CapTP frames are wrapped in
  `[managerHandle, "deliver", frameBytes, 0]` envelopes.

- **`bus-daemon-rust-xs.js`** — XS manager bootstrap. *Despite the
  "daemon" in its name (kept for symmetry), this module implements
  the manager role, not the daemon.* It runs inside the unified
  `endor` binary invoked as `endor manager -e xs` and uses
  `issueCommand` plus host powers in place of Node.js APIs. Bundled
  at build time via `scripts/bundle-bus-daemon-rust-xs.mjs` into
  `rust/endo/xsnap/src/daemon_bootstrap.js`, which the xsnap library
  embeds as `MANAGER_BOOTSTRAP`.

- **`bus-worker-xs.js`** — XS worker bootstrap. Runs inside the Rust
  `endor` binary (as `endor worker`) rather than Node.js. Uses
  `issueCommand` (synchronous host function) instead of
  `writeFrameToStream` for sending CapTP messages; uses
  `hostImportArchive` to load compartment-map archives natively in
  XS.

The previous file naming convention (`daemon-go.js`, `daemon-rust.js`,
etc.) was *duplicated per daemon language*; the unified `bus-` prefix
reflects that *the capability bus protocol is language-agnostic*. The
prefix denotes participation in the protocol, not a role.

## CBOR framing — *binary payloads without base64*

§CBOR framing notes that the envelope protocol uses CBOR rather than
netstring-framed JSON because CBOR has well-defined byte string
support, making it suitable for passing binary payloads without
base64 encoding. Each frame is a CBOR byte string (major type 2)
wrapping the inner CBOR envelope array.

## Deadlock prevention — the spawn-tree discipline

§Deadlock prevention inherits a discipline from the `endo-engo`
prototype: the daemon maintains a **spawn tree** recording
parent-child relationships (logical, not OS-level — *all* processes
are OS-level children of the daemon). Synchronous calls (`nonce > 0`)
are only permitted from child to ancestor in the *logical* tree or
to the control plane (handle 0). The `canBlock(caller, callee)` check
prevents cycles. Asynchronous messages (`nonce = 0`) are always
permitted.

In the bus arch, the logical spawn tree is:

```
daemon → manager → workers
```

So: workers can synchronously call the manager or the daemon. The
manager can synchronously call the daemon. *Sibling workers cannot
synchronously call each other* — they use asynchronous messages via
the manager's CapTP layer. The discipline is what lets the daemon
guarantee the spawn graph is a DAG; CapTP layers above the daemon
inherit the same liveness property.

## The incremental syscall migration — the unbounded phase

§Phase 4 (logging) and §Phase 5 (progressive syscall migration) lay
out the *daemon-progressively-assumes-platform-I/O* arc:

- **Phase 4 — logging**. Workers send `[0, "log", {level, message},
  0]` to the daemon instead of writing to stderr. Daemon collects
  logs, writes them to per-worker log files and/or a unified log
  with structured metadata. Demonstrates the syscall pattern.

- **Phase 5 — open-ended candidate list**:

| Syscall | Replaces | Rationale |
|---------|----------|-----------|
| `fs.read` / `fs.write` | `node:fs` | Most impactful; enables daemon-side caching and access control |
| `net.listen` / `net.connect` | `node:net` | Enables daemon-side socket management |
| `crypto.random` / `crypto.hash` | `node:crypto` | Small surface, easy to verify |

Each syscall: define verb + payload; implement handler in daemon;
replace Node.js call in bus powers with envelope send; verify
manager functions identically. *This phase is unbounded — it
proceeds as far as is useful without requiring completion.*

The §Security Considerations section names the security payoff:
*workers that obtain all I/O through daemon syscalls can be fully
confined — they need no direct access to the filesystem or network*.
The daemon controls process configuration; macOS `sandbox-exec`,
Linux namespaces + seccomp can confine workers. Handles are
unforgeable within the envelope protocol: *a worker can only address
handles that the daemon has explicitly routed to it*. This provides a
capability discipline *at the daemon level* that complements CapTP's
object-capability discipline *within the JavaScript layer* — two
ocap-disciplined layers stacked.

## Compatibility — the *rollback is trivial* invariant

§Upgrade Considerations notes that the daemon does not modify the
`endo` CLI (users set `ENDO_BIN` to switch); the Unix socket is at
the same path, so all `endo` commands work against either a
legacy-daemon-managed or bus-daemon-managed manager. The daemon does
not change the manager's state format — formula graph, pet stores,
keypairs are still managed by the manager. *Rolling back is trivial:
stop the daemon-managed manager and start a legacy in-process daemon
directly with `endo start`. No state migration is needed.* The
`-node` modules remain alongside the `bus-` modules and continue to
work independently.

## Why this is a *messages-as-the-substrate* design

The design's deepest claim isn't "let's move the supervisor out of
Node.js." It's that *the right unit of subprocess communication is
the handle-tagged envelope, not the netstring-framed CapTP stream
that happens to be carrying CapTP today*. The daemon doesn't speak
CapTP; it speaks envelopes. CapTP rides inside `"deliver"` payloads.
Other things can ride inside other verbs:
`"spawn"`/`"spawned"`/`"init"`/`"ready"`/`"log"` are non-CapTP
control-plane verbs. The syscall migration is *just more verbs* —
new control-plane operations that workers can address to handle 0.

The phrase *the daemon **is** the capability bus* is the design's
thesis. It pairs with cycle 105's
[[endo-but-for-bots--llm-designs-daemon-capability-bank--shared-capabilities-as-a-meta-design-with-six-design-principles]]
worldview shift (capabilities-as-shared-resources rather than
per-agent-attached) — but at a lower layer. The capability-bus
design says: *the daemon's job is to route handle-tagged messages
between subprocesses, and capabilities are addressed by handle*. The
capability-bank design says: *given that capabilities are first-class
shared resources, how should agents reach them?* Both designs treat
capabilities as routable, addressable objects rather than
JavaScript-stack-attached values.

## Related sections

- cycle 105
  [[endo-but-for-bots--llm-designs-daemon-capability-bank--shared-capabilities-as-a-meta-design-with-six-design-principles]]
  — the *capabilities as shared resources* worldview shift; this
  cycle is the *daemon as their message router* worldview shift.
- cycle 101
  [[endo-but-for-bots--llm-designs-daemon-commands-as-messages--ai-agent-commands-routed-as-form-and-value-messages]]
  — *form-request and value-message commands* are at the application
  layer; the capability bus is what carries those messages between
  subprocesses at the transport layer.
- cycle 103
  [[endo-but-for-bots--llm-designs-daemon-value-message--value-as-reply-primitive-for-ai-agent-form-request-flows]]
  — the *value-message* application-layer primitive that rides over
  the envelope `"deliver"` verb.
- cycle 107
  [[endo-but-for-bots--llm-designs-daemon-agent-tools--dir-shell-and-git-as-claw-like-agent-capabilities]]
  — *Dir/Shell/Git capabilities* exposed to agents; each capability
  is a handle on the daemon's capability bus.
