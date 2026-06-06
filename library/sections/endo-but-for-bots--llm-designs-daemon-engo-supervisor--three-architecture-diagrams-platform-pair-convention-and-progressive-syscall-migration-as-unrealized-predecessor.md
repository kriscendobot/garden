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
---

# Three architecture diagrams (current/target/future), -go vs -node platform-pair convention, progressive syscall migration, and the unrealized-Go-predecessor of cycle-176-endor-Rust supervisor

> §Designs-lane after cycle 191's chat-lane. §The-twenty-
> sixth-consecutive designs/chat alternation cycle (166-192).
> §Status: **Not Started** (Created 2026-02-25). §This-design-
> never-shipped: the team pivoted to Rust (cycle 176 endor-
> architecture, Status Active, 2026-04-16). §A-historical-
> artifact documenting the architectural exploration that
> preceded the canonical Rust direction.

`daemon-engo-supervisor.md` (481 lines, Not Started,
2026-02-25) designs a Go supervisor process ("engo") that
would wrap the existing Node.js Endo daemon and manage all
workers as peers. §The-design-never-shipped — the team
pivoted to Rust (cycle 176 endor-architecture), but neither
this design nor cycle 176 explicitly marks engo as superseded.

§The-single-most-structurally-interesting-move is §three-
architecture-diagrams (current / target / future) + §-go-vs-
node-vs-web-platform-pair-naming-convention + §progressive-
syscall-migration-with-named-priority-order +
§incrementalism-as-the-key-constraint. §Four-named-moves at
the architecture-decision-design level.

## §Three-architecture-diagrams (the §visualize-the-transition pattern)

```
### Current architecture
endo (CLI) ──► node daemon ──►* node worker

### Target architecture (this design)
                          ┌─► node daemon
endo (CLI) ──► engo (Go) ─┤
                          └─►* node worker

### Future architecture (out of scope)
endo (CLI) ─┐
engo (Go) ──┼─► node daemon
             ├─►* node worker
             ├─►* go worker
             ├─►* wasm worker
             └─► platform I/O (fs, net, crypto)
```

§Three-stages-of-architectural-evolution shown as three
diagrams. §The-current-state names what exists. §The-target-
state names what this design proposes. §The-future-state
names what the target enables (out-of-scope for this design,
but motivating).

§The-§"out of scope" label on the future-architecture is the
§named-scope-boundary pattern. §The-design-acknowledges-the-
future-direction while §refusing-to-commit-to-it-in-this-
document.

§Compare-to-cycle-190-endo-posix-sandbox's §living-phase-list-
records-its-own-renumbering. §Both-record-§architectural-
evolution; cycle 192's three-diagrams record a §multi-stage-
transition where each stage is itself a complete-and-runnable
architecture.

§Compare-to-cycle-188-perf's §working-copy-inventory which
maps in-progress work to design documents. §Cycle-192-uses-
diagrams; cycle-188-uses-tables. §Both-are-§visualization-of-
transition-state.

## §-go-vs-node-vs-web platform-pair-naming-convention

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

## §progressive-syscall-migration with §named-priority-order

```
| Syscall | Replaces | Rationale |
|---------|----------|-----------|
| `fs.read` / `fs.write` | `node:fs` | Most impactful; enables Go-side caching and access control |
| `net.listen` / `net.connect` | `node:net` | Enables Go-side socket management |
| `crypto.random` / `crypto.hash` | `node:crypto` | Small surface, easy to verify |
```

§Three-syscalls in §suggested-priority-order (most-impactful
first; smallest-surface last for verification). §Each-syscall
follows-the-same-four-step-pattern:

1. §Define-the-verb-and-payload-schema.
2. §Implement-the-handler-in-Go.
3. §Replace-the-Node.js-call-in-the-`-go-powers.js`-module-
   with-an-envelope-send.
4. §Test-that-the-daemon-functions-identically.

§The-§"This phase is unbounded — it proceeds as far as is
useful without requiring completion" is the §named-open-
ended-migration discipline.

§Compare-to-cycle-180-hex-package's §five-phases-mostly-S
(four-step-per-syscall mirrors five-phase-per-package). §Both-
are-§canonical-migration-rhythm patterns.

§The-§Most-impactful-first ordering inverts cycle 186-break-
dev-deps' §smallest-to-largest order. §Different-disciplines:
cycle 192's syscalls are §independent + §ordered-by-impact;
cycle 186's cuts are §independent + §ordered-by-diff-size-for-
review-ease.

## §incrementalism-as-the-key-constraint (named explicitly)

```
The key constraint is **incrementalism**: the existing Node.js
daemon must continue to work unmodified under `endo start`.
Engo is an alternative supervisor that hosts the daemon as a
subprocess and manages all workers as peers.
```

§The-§key-constraint named-explicitly. §Three-properties:

1. §Existing-Node.js-daemon-continues-to-work-unmodified.
2. §`endo start` continues to work.
3. §Engo-is-an-alternative-supervisor (additive, not
   replacement).

§The-§rollback-trivial section reinforces this:

> Because engo wraps the existing daemon without modifying it,
> rolling back is trivial: stop the engo-managed daemon and
> start one directly with `endo start`. No state migration is
> needed.

§The-`-node`-modules-remain-alongside-the-`-go`-modules. §Two-
implementations-coexist; the user-or-CLI chooses which.

§Compare-to-cycle-186-break-dev-deps' §sink-only-synthetic-
test-packages (§don't-touch-the-existing-packages); cycle
192's incrementalism is at the §process-architecture-layer
rather than the §workspace-dependency-graph layer.

§Compare-to-cycle-178-snapshot's §two-init-paths-one-entry-
point (init vs restore). §Both-are-§two-coexisting-shapes
patterns at different scales.

## §Five-phase-incremental-implementation

```
Phase 0: Scaffold engo (minimal Go binary spawning Node.js daemon, inherited stdio)
Phase 1: Envelope protocol and daemon-go entry point (fd 3/4 + CBOR)
Phase 2: Worker spawning through engo (handle table + per-worker goroutines + handle rewriting)
Phase 3: First syscall — logging (worker logs to handle 0 instead of stderr)
Phase 4: Progressive syscall migration (fs/net/crypto, in suggested order)
```

§Five-phases with §explicit-Validation-per-phase. §Each-phase-
has-a-§Goal-paragraph and a §Validation-paragraph.

§Phase-0-validation: "`engo start` produces a working daemon
reachable by `endo ping`. Workers are still spawned by the
Node.js daemon directly."

§Phase-2-validation includes-§ps-check ("Workers appear as
children of engo (not of the Node.js daemon) in `ps`. Killing
engo terminates both the daemon and all workers.").

§Phase-4-§This-phase-is-unbounded named.

§Compare-to-cycle-190-endo-posix-sandbox's §phase-list-with-
exit-criteria. §Both-record-§goal+validation-per-phase. §Cycle-
192-uses-"Validation" header; cycle-190-uses-"Exit criteria".

§The-§validation-via-`ps` is a §process-tree-inspection-as-
test pattern. §Compare-to-cycle-184-metering's §benchmark-
numbers-cited-from-three-angles. §Both-are-§empirical-
verification-disciplines.

## §Handle-rewriting (the supervisor router move)

```
daemon ──[N, verb, payload, rid]──► engo ──[1, verb, payload, rid]──► worker(N)
worker(N) ──[1, verb, payload, rid]──► engo ──[N, verb, payload, rid]──► daemon

Engo performs **handle rewriting** on forwarded messages:
when the daemon (handle 1) sends to worker N, engo delivers
the message to worker N with the handle field rewritten to 1
(the daemon's handle).  When worker N sends to handle 1 (the
daemon), engo delivers to the daemon with the handle field
rewritten to N.  This allows both sides to identify their
counterpart without an explicit sender field.
```

§The-§handle-rewriting move: each side sends to-the-handle-
of-the-target; engo delivers to-the-target-with-the-handle-
of-the-sender. §No-explicit-sender-field needed; §the-
asymmetry-of-the-rewrite-is-the-routing-information.

§Compare-to-cycle-176-endor-architecture's §three-worker-
platforms-with-byte-identical-CBOR-envelopes. §Cycle-176-uses
the same §handle-as-routing-key discipline. §Engo-cycle-192-
introduces it; endor-cycle-176-inherits-it.

§Compare-to-cycle-182-debugger's §`"debug"`-verb-same-in-
both-directions (§handle-rewriting-distinguishes-sender).
§Same-pattern-applied-to-debug-protocol.

## §Deadlock-prevention-via-spawn-tree

```
The Go supervisor inherits the deadlock prevention strategy
from the `endo-engo` prototype:

- The supervisor maintains a **spawn tree** recording parent-
  child relationships (logical, not OS-level — all processes
  are OS-level children of engo).
- **Synchronous calls** (requestID > 0) are only permitted
  from child to ancestor in the logical tree or to the
  control plane (handle 0).
- The `canBlock(caller, callee)` check prevents cycles.
- **Asynchronous messages** (requestID = 0) are always
  permitted.
```

§Spawn-tree-as-logical-DAG (engo → daemon → workers). §All-
processes-are-OS-children-of-engo; §logical-tree-is-separate.

§Two-rules:

1. §Sync-calls-only-child-to-ancestor-or-control-plane
   (handle 0).
2. §Async-messages-always-permitted (no cycle-detection
   needed).

§The-`canBlock`-check is the §canonical-deadlock-prevention.
§Sibling-workers-cannot-synchronously-call-each-other; they
use §asynchronous-messages-via-the-daemon's-CapTP-layer.

§Compare-to-cycle-176-endor-architecture's §blocking-call-
authorization-via-parent-tree (§deadlock-prevention-by-
structure). §Same-name-same-discipline. §Cycle-176-inherits-
this-from-cycle-192's-engo-design.

§Cycle-184-metering's §custom-fxAbort-via-longjmp + §three-
phase-drain-loop are §different-deadlock-prevention-
strategies at a different layer. §The-spawn-tree-discipline
is §protocol-level; §fxAbort is §runtime-level.

## §CBOR-with-4-byte-big-endian-length-prefix-framing

```
- **CBOR** is a binary format with well-defined byte string
  support, making it suitable for passing binary payloads
  without base64 encoding.
- **Framing**: Each frame is length-prefixed (4-byte big-
  endian length prefix followed by CBOR bytes), matching the
  `endo-engo` prototype.

The Node.js side uses a CBOR library (e.g., `cbor-x` or
`@ipld/dag-cbor`).
The Go side uses `fxamacker/cbor/v2`.
```

§Two-named-CBOR-libraries-for-each-side. §The-Go-side-is-
`fxamacker/cbor/v2`; §the-Node.js-side-is-`cbor-x`-or-
`@ipld/dag-cbor`.

§4-byte-big-endian-length-prefix is §a-different-choice from
cycle 179-lp32's §host-byte-order-uint32. §Why-big-endian:
this is §inter-language-IPC (Go ↔ Node.js); §host-byte-order-
might-be-mismatched-across-architectures-or-implementations.
§Big-endian-is-the-network-byte-order-default.

§Compare-to-cycle-179-lp32's §host-byte-order-as-deliberate-
IPC-marker (same-host-only-IPC). §Cycle-179 uses host-byte-
order because both sides are on the same machine and
endianness is moot; §cycle-192 uses big-endian because cross-
language framing benefits from a canonical byte-order.

§Compare-to-cycle-181-base64's §pre-pasted-pako-crc32 +
cycle 177-netstring/reader.js' §ASCII-decimal length prefix.
§Three-different-framing-disciplines for three-different-
contexts.

## §Subprocess-isolation (the security-future)

```
Engo's value proposition includes the ability to apply OS-
level sandboxing to workers it spawns directly.  This is out
of scope for the initial phases but the architecture supports
it:

- Engo controls the `exec.Cmd` configuration for each
  subprocess.
- On macOS, `sandbox-exec` profiles can restrict file and
  network access.
- On Linux, namespaces and seccomp filters can confine
  workers.
- Workers that obtain all I/O through supervisor syscalls can
  be fully confined — they need no direct access to the
  filesystem or network.
```

§Four-named-sandboxing-mechanisms (Cmd config + macOS
sandbox-exec + Linux namespaces+seccomp + supervisor-syscall-
confinement). §Out-of-scope-for-initial-phases but §the-
architecture-supports-it.

§Compare-to-cycle-190-endo-posix-sandbox which §made-the-out-
of-scope-into-its-scope. §Cycle-192's-engo-supervisor names
sandboxing as a future-direction; cycle-190's posix-sandbox
delivers it as a separate plugin under a different supervisor
(the actually-shipping Rust endor).

§The-§supervisor-syscalls-enable-full-confinement: workers
that get all I/O through supervisor messages need no direct
filesystem-or-network access. §This-is-the-§capability-
discipline-at-the-process-layer.

§Compare-to-cycle-190's §cap-not-string-mounts. §Both-are-
§capability-discipline-applied-to-OS-syscall-surface; cycle
192 routes through envelopes, cycle 190 routes through Mount
capabilities.

## §Why-this-design-never-shipped (the §unrealized-predecessor relationship)

§The-design-status: **Not Started** (Created 2026-02-25).

§Cycle-176-endor-architecture (Created 2026-04-16, Status
Active): the Rust supervisor that shipped instead. §The-
endor-architecture inherits substantial DNA:

- §Three-worker-platforms (cycle 176's separate-XS + shared-
  XS + Node.js vs cycle 192's Node.js + Go + Wasm in future).
- §Byte-identical-CBOR-envelopes (same framing).
- §Handle-rewriting (same supervisor-router-discipline).
- §Spawn-tree-deadlock-prevention (same §canBlock check).
- §Five-embedded-JS-bundles-via-include_str! (cycle 176 has
  this; cycle 192 doesn't because Go doesn't have the same
  include-string mechanism).
- §Cooperative-not-preemptive-scheduling.

§What-changed-in-the-pivot:

1. §Rust-instead-of-Go for the supervisor (performance +
   memory-safety + Cargo ecosystem alignment).
2. §Endor-supports-shared-in-process-XS-worker as a co-
   resident option; engo's design only contemplated
   subprocess workers.
3. §Endor-uses-bundle-source-+-include_str! for embedded JS
   (Phase 4+ of engo would have needed a different mechanism
   for syscalls).

§Neither-design-explicitly-marks-engo-as-superseded. §The-
engo-design-is-still-marked-Not-Started; cycle 176 endor is
Active. §The-fact-that-engo-was-never-built-and-endor-
shipped-instead is §archived-only-by-the-status-fields-and-
the-existence-of-the-cycle-176-design.

§Compare-to-cycle-190-endo-posix-sandbox's §Supersedes-record-
pattern with §three-named-improvements. §Cycle-192-engo +
cycle-176-endor lack-this-explicit-relationship. §An-§implicit-
supersedes that future maintainers would need to discover by
reading both designs and noting the dates.

§Tier-1-borrowing: §when-pivoting-architectures, write a
§Supersedes-record explicit in the new design (or update the
old design's Status to "Superseded by [link]"). §Cycles-186/
190 do this; cycles 192/176 don't. §The-honest-design-
evolution-discipline (cycles 178/180/183/184 family) applies
at the architecture-decision-layer too.

## §The-§Web-future-architecture-pair (the §future-direction-named-but-not-built)

```
| Web (future) | `daemon-web.js` | `daemon-web-powers.js` | — | — |
```

§The-web-platform-pair is named in the table but with §dashes-
for-worker-entries — §the-web-platform-doesn't-have-a-direct-
worker-counterpart in this design. §Web-workers-exist-in-
browsers but the engo architecture is for §server-side-
supervision; §web-deployment would be a different shape.

§Compare-to-cycle-174-gateway-package's §ten-feature-
decomposition-of-one-package with §one-factory-many-
configurations. §Both-are-§future-direction-named-but-not-
fully-specified patterns.

## §Engo-does-not-modify-the-endo-CLI (the §scope-boundary)

```
Engo does not modify the `endo` CLI.  Users can run
`engo start` instead of `endo start` to use the Go
supervisor.  The daemon's Unix socket is at the same path, so
all `endo` commands work against an engo-managed daemon.

In the future, the CLI could detect engo's presence and
delegate to it, or engo could subsume the CLI's daemon
management commands.
```

§The-§scope-boundary-with-named-future-direction. §Initial-
scope: engo is a separate command (`engo start`); §future-
direction: CLI could detect engo or engo could subsume CLI.

§The-§initial-scope-preserves-the-`endo`-CLI-surface. §All-
existing-tooling-keeps-working. §Compare-to-cycle-190-endo-
posix-sandbox's §existing-tools-unchanged-externally (genie
tools unchanged; daemon-side spawn-channel-swapped). §Same-
discipline-different-layer.

§The-§Unix-socket-at-the-same-path makes engo-managed-daemon
indistinguishable-from-Node.js-daemon-managed daemon for the
`endo` CLI. §The-supervisor-is-transparent-to-the-client.

## §Cohesion notes

- §Three-architecture-diagrams (current / target / future) is
  the §visualize-the-transition pattern. §Each-stage-is-a-
  complete-and-runnable-architecture; the design moves
  through them.
- §-go-vs-node-vs-web platform-pair-naming-convention with
  §four-file-quadruple-per-platform (daemon + daemon-powers +
  worker + worker-powers).
- §Near-copies-with-channel-adapted migration-path (new
  platform pairs start as near-copies; over time they
  diverge).
- §Progressive-syscall-migration with §named-priority-order
  (fs first, net second, crypto third — most-impactful-first
  not smallest-first).
- §Incrementalism-as-the-key-constraint named-explicitly.
- §Rollback-trivial — `-node` modules remain alongside `-go`
  modules.
- §Five-phase-incremental-implementation with §Validation-
  per-phase; §Phase-4-unbounded.
- §Handle-rewriting (engo router; sender field implicit in
  the asymmetry of the rewrite).
- §Deadlock-prevention-via-spawn-tree with §canBlock check
  and §sync-from-child-to-ancestor-only rule.
- §CBOR-with-4-byte-big-endian-length-prefix-framing (big-
  endian because inter-language IPC; different from cycle
  179-lp32's host-byte-order).
- §Out-of-scope-but-architecture-supports-it for subprocess-
  isolation (engo could apply macOS sandbox-exec or Linux
  namespaces+seccomp; deferred).
- §The-§Unrealized-predecessor relationship to cycle 176-
  endor-architecture: substantial DNA inherited; Rust pivot;
  neither design names the supersedes-record explicitly.
- §Web-future-architecture-pair with §dashes-for-worker-
  entries (named-but-not-built).

## §Tier-1 borrowing

- §three-architecture-diagrams-current-target-future
  (visualize the transition; each stage runnable)
- §-platform.js + §-platform-powers.js naming convention
  (four-file-quadruple per platform)
- §near-copies-with-channel-adapted (new platform pairs
  start as near-copies of existing ones)
- §progressive-syscall-migration-with-named-priority-order
  (most-impactful-first; phase is unbounded)
- §incrementalism-as-the-key-constraint
- §rollback-trivial discipline (preserve existing alongside
  new)
- §validation-per-phase with §process-tree-inspection-as-test
- §handle-rewriting (sender field implicit in the asymmetry
  of the rewrite)
- §spawn-tree-deadlock-prevention with §canBlock check
- §CBOR-with-big-endian-length-prefix-for-cross-language-IPC
- §when-pivoting-architectures-write-an-explicit-Supersedes-
  record (or update old design's Status)

## §Synthesis-target

The §slot-machine-library's process-supervisor work (if any)
can §borrow-the-handle-rewriting + §spawn-tree-deadlock-
prevention directly. §The-§three-architecture-diagrams
pattern is borrowable for any §multi-stage-transition design.

§The-§when-pivoting-architectures-write-an-explicit-
Supersedes-record discipline (cycle 192's failure to do so)
is borrowable as a §lesson-learned: future architecture
pivots should record the supersedes relationship in both
documents.

§The-§progressive-syscall-migration pattern is borrowable for
any §replace-runtime-API-with-supervisor-call work; the
§four-step-per-syscall + §unbounded-phase rhythm scales.
