---
source: designs/daemon-xs-worker-debugger.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_url: https://github.com/endojs/endo-but-for-bots/blob/llm/designs/daemon-xs-worker-debugger.md
section_kind: design
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - daemon
  - capability-security
  - hardened-javascript
status_at_ingest: In Progress
genre: §endo-but-for-bots-design §sibling-design-trio
cycle: 182
lane: designs
status: current
---

# Six-layer XML-pass-through architecture with dormant-by-default debug and break-on-uncaught-via-firstJump-walk-before-fxJump

> §Designs-lane after cycle 181's chat-lane. §The-sixteenth-
> consecutive designs/chat alternation cycle (166-182). §Status:
> **In Progress** — Phases 1-5 done; Phase 6 (Chat panel UI
> shell) done, with `attachDebugger` CapTP exposure, `followBreaks`
> live notification, source-view, and profiling format
> remaining.

`daemon-xs-worker-debugger.md` (1211 lines, Created 2026-04-14,
Updated 2026-04-15) designs an interactive debugger for Endo's
Rust-supervised XS workers: breakpoints, stepping, frame
inspection, profiling, all driven over CapTP, hot-attachable to
any running worker.

§The-design-is-a §sibling-trio-with cycle 178 (daemon-xs-worker-
snapshot) and the un-ingested daemon-xs-worker-metering — three
worker-level capabilities sharing the §endor-Rust-supervisor
substrate (cycle 176). §All-three-extend-the-xsnap-engine-
exposure with non-obvious mechanisms while keeping the §three-
worker-platforms-with-byte-identical-CBOR-envelopes invariant.

§The-single-most-structurally-interesting-move is the §six-
layer-XML-pass-through-architecture combined with §break-on-
uncaught-via-firstJump-walk-before-fxJump:

- §Stock-xsbug-XML-protocol stays intact (XS engine upgrades get
  debug features for free).
- §Rust-supervisor-is-opaque-byte-ferry (no XML parsing in Rust).
- §JS-side-SAX-parser inside SES handles the protocol.
- §Debugger-exposed-as-CapTP-capability (`Debugger` exo).
- §Hot-attach-without-restart via dormant compile-time hooks.
- §Break-on-uncaught-exceptions uses XS's pre-jump throw hook to
  walk the active-handler linked list at throw time — §zero-
  cost-if-the-answer-is-don't-break.

## §The-six-layer-stack

| Layer | Component | Where it lives |
|-------|-----------|----------------|
| 1 | C platform hooks → Rust callbacks | `xsnap-platform.c/h` + `powers/debug.rs` |
| 2 | Envelope bus verbs `debug` / `debug-attach` / `debug-detach` | `proc.rs`, `inproc.rs` |
| 3 | DebugSession (xsbug XML SAX parser + structured API) | `packages/daemon/src/debug-session.js` |
| 4 | Debugger exo (CapTP-remotable) | `packages/daemon/src/debugger.js` |
| 5 | Daemon bus handler + `attachDebugger` | `packages/daemon/src/bus-daemon-rust-xs.js` |
| 6 | Chat debugger panel + `/debug` command | `packages/chat/debugger-panel.js` |

§Six-layer-strict-stratification. §Each-layer-only-talks-to-the-
layer-above-and-below. §Compare-to-cycle-176-daemon-endor-
architecture which has §three-worker-platforms decomposition;
§this-design-has §six-layers-across-language-boundaries (C → Rust
→ JS → SES → CapTP-remotable → UI).

§The-traffic-flow per debugger action:

```
UI button click
  ↓ [Layer 6]
E(debugger).setBreakpoint(path, line)
  ↓ [Layer 5: daemon bus handler]
DebugSession command method
  ↓ [Layer 4]
xsbug XML written to outbound buffer
  ↓ [Layer 3]
envelope verb "debug" + XML payload
  ↓ [Layer 2: envelope bus]
worker's debug.rs inbound buffer
  ↓ [Layer 1: C callback rust_debug_recv]
XS engine's fxRunDebugger reads command
  ↓
breakpoint registered in XS internals
  ↓ (response XML)
... same path reversed back to UI
```

## §Three-option-architectural-decision (Option A chosen; B and C rejected)

§The-design-enumerates-three-options-and-defends-the-choice:

| Option | What | Verdict | Reason |
|--------|------|---------|--------|
| A | XML pass-through (Rust ferries opaque bytes; JS parses) | **Chosen** | Stock xsbug protocol; zero xsDebug.c changes; future XS upgrades free; small Rust surface |
| B | Host-function translation (Rust functions call xsDebug.c internals) | Rejected | Internals not public API; loses profiling/instrument-sampling; larger Rust surface with no benefit |
| C | Replace XML with JSON in xsDebug.c | Rejected | Massive fork divergence from upstream Moddable; same information, different syntax |

§Compare-to-cycle-178-daemon-xs-worker-snapshot's §six-Design-
Decisions and cycle 180-hex-package's §eight-Design-Decisions
— this design's §three-option-table is a different framing
(alternatives-considered rather than decisions-recorded). §Both-
are-valid §honest-design-discipline.

§Option-A-wins-because-it §preserves-the-XS-vendor-protocol.
§Cycle-128's §spec-driven-implementation-discipline applies:
when an external spec already defines the data shape, don't
reinvent.

§The-XML-protocol-is-the-de-facto-API — `xsbug-node/xsbug-
machine.js` is the reference implementation. §Reusing-it-keeps-
Endo-aligned-with-Moddable-upstream.

## §Always-compiled-dormant-by-default (Design Decision 1)

```
In dev/self-hosted environments, mxDebug and mxInstrument
are always defined at compile time.  This means every worker
binary carries the XS debug subsystem.  However, the debug
hooks (fxConnect, fxIsConnected, etc.) start as no-ops —
debug_enable() is never called until a "debug-attach"
envelope arrives for a specific worker.
```

§Two-binaries-eliminated. §The-pre-design-state had to choose
between debug-build (full subsystem, every binary larger) and
release-build (no debug ever available). §This-design-folds-both-
into-one: §always-compiled + §dormant-hooks.

§The-cost-named-explicitly: "modest increase in binary size and
a negligible per-instruction branch (the mxDebug bookkeeping
checks fxIsConnected, which returns false when dormant)."
§Honest-overhead-disclosure.

§The-cargo-feature-`debug`-gates the compile flag for
size-constrained production deployments. §Three-deployment-shapes
emerge:

1. **§Dev / self-hosted** — `debug=on`; debug subsystem present,
   dormant by default, activated per-worker via envelope.
2. **§Production-size-constrained** — `debug=off`; debug code
   compiled out entirely; hot-attach not available.
3. **§Production-with-on-demand-debug** — `debug=on`; binary
   larger but any worker debuggable on demand.

§Compare-to-cycle-178-daemon-xs-worker-snapshot's §suspend-only-
when-idle which avoids the CapTP reconnection problem entirely;
§this-design's §dormant-by-default avoids the §two-binaries
problem entirely. §Both-are-§avoid-the-problem-by-design-not-
by-handling-it patterns.

## §Hot-attach via `"debug-attach"` envelope (Layer 6)

```js
const debugger = await attachDebugger(workerHandle);
```

§Six-step-attach-flow:

1. Daemon sends `"debug-attach"` envelope to worker's supervisor
   handle.
2. Rust supervisor calls `debug_enable()` for the worker's
   thread, activating the debug hooks.
3. XS calls `fxConnect` on the next `fxRunDebugger` cycle;
   `fxIsConnected` now returns true.
4. XS emits a `<login>` response with machine name and tag.
5. Daemon receives login, creates a `Debugger` exo + formula
   for the worker.
6. Returns the debugger capability to the caller.

§Detach-flow-symmetric: drop the Debugger exo (or send
`"debug-detach"`); supervisor calls `debug_reset()`; XS calls
`fxDisconnect`; worker resumes normal execution.

§Compare-to-cycle-178-suspend/resume which has §two-state-
machine Live ↔ Suspended; §this-design's §two-state-machine is
Dormant ↔ Active. §The-active-state-is-the-§debugger-attached
state; the dormant state is the default.

§No-CLI-command: "There is no `endo debug` CLI command. The
primary entry point is the daemon's `attachDebugger` method,
callable from any CapTP peer." §The-CLI-is-not-the-API; CapTP-
attachment-is-the-API. §A-Chat-worker-can-debug-another-worker;
the gateway can debug a worker; Familiar can debug a worker.

## §XML-pass-through Rust as opaque byte ferry (Layer 2)

§The-Rust-supervisor-does-not-parse-XML. §Two-new-envelope-verbs:

| Verb | Direction | Payload | Nonce |
|------|-----------|---------|-------|
| `"debug"` | daemon → worker | Raw xsbug XML bytes (command) | 0 |
| `"debug"` | worker → daemon | Raw xsbug XML bytes (response) | 0 |

§Same-verb-both-directions; handle rewriting distinguishes
sender. §Matches-the-pattern-of-`deliver` for CapTP traffic.

§No-new-supervisor-code-beyond recognizing `"debug"` as a
pass-through verb. §The-existing-handle-rewrite-logic suffices.

§Compare-to-cycle-176-daemon-endor-architecture's §three-worker-
platforms-with-byte-identical-CBOR-envelopes — this design lands
within that framework: §the-`debug`-verb-is-byte-identical-
across-all-three-platforms (separate XS / shared XS / Node.js
worker).

## §C-platform-hooks → Rust callbacks (Layer 1)

§Five-platform-functions XS calls for debug I/O:

```c
void fxConnect(txMachine* the);
void fxDisconnect(txMachine* the);
txBoolean fxIsConnected(txMachine* the);
void fxReceive(txMachine* the);
void fxSend(txMachine* the, txBoolean more);
```

§The-platform-must-implement-all-five. §The-design-replaces-the-
default-stubs with Rust-calling implementations:

```c
static __thread RustDebugSendFn rust_debug_send = NULL;
static __thread RustDebugRecvFn rust_debug_recv = NULL;
static __thread RustDebugIsReadableFn rust_debug_readable = NULL;
static __thread void* rust_debug_context = NULL;
static __thread int rust_debug_connected = 0;
```

§Thread-local-storage because XS machines are single-threaded
and each worker runs on its own thread. §The-`__thread`-storage-
class is C11 thread-local; §matches-cycle-176-endor's-§pool-of-
machine-runner-threads model.

§The-Rust-side uses `Mutex<Option<DebugBuffers>>` with
`VecDeque<u8>` for outbound and inbound — §the-design-comments
"The mutex is for safety but should be uncontended in practice
since only the worker thread and the bus I/O thread touch it,
and they alternate."

§Design-Decision-3-named-explicitly: "Thread-local buffers with
mutex... XS machines are single-threaded. Each worker thread has
its own debug buffers."

## §DebugSession SAX parser in SES (Layer 3)

```js
packages/daemon/src/debug-session.js
```

§Maintains:
- §SAX-parser-state (minimal XML parser; ~100-line state machine
  suffices for xsbug's simple XML subset)
- §Current-breakpoint-set
- §Last-break-location (path, line)
- §Last-frames/locals/globals snapshots
- §Profile-accumulator
- §Pending-command-callbacks (request/response correlation)

§Why-hand-written-SAX-not-Saxophone-npm: "must be written in
Jessie-compatible JS (no regex literals in some contexts, no
`eval`)... The xsbug XML subset is simple enough for a hand-
written state machine parser."

§Compare-to-cycle-177-netstring/reader.js' §two-state-iterator
+ §three-character-cases-prefix-parsing. §The-DebugSession-SAX
is a §similar-state-machine-for-a-different-protocol.

§The-feed-cycle is four-step:

1. Raw XML bytes arrive (`feedXml(bytes)`).
2. SAX parser emits element events.
3. Element handlers update state + resolve pending promises.
4. Break events emit to registered listeners.

§Promise-correlation-by-pending-callbacks: e.g., `getFrames()`
returns a promise that resolves when `<frames>` arrives.

§Sixteen-command-methods enumerated (go / step / stepIn / stepOut
/ setBreakpoint / clearBreakpoint / clearAllBreakpoints /
getFrames / getLocals / getGlobals / selectFrame / toggleProperty
/ evaluate / startProfiling / stopProfiling / abort).

## §Debugger exo as CapTP capability (Layer 4)

```js
const DebuggerI = M.interface('Debugger', {
  go: M.call().returns(M.undefined()),
  step: M.call().returns(M.record()),
  // ... 14 more ...
  followBreaks: M.call().returns(M.remotable()),
  help: M.call().returns(M.string()),
});
```

§The-`makeExo`-pattern (cycle 108's exo-makers.js): the
Debugger is a remotable object with §runtime-method-guards.
§Cycle-117's-Exo-pattern naturally extends to the debugger
domain.

§Design-Decision-5-named-explicitly: "This is the Endo way:
everything is a capability. The debugger can be granted,
delegated, and revoked like any other capability. A guest could
debug its own sub-workers if given the debugger capability."

§Debugger-as-revocable-capability is a §powerful-property:

- §Delegate to a co-worker for collaborative debugging.
- §Restrict via attenuating proxy (e.g., read-only debugger with
  no `setBreakpoint`).
- §Revoke when session ends.
- §Audit via `passableAsJustin`-friendly diagnostic logging.

§Compare-to-cycle-170-daemon-capability-filesystem's §caretaker-
facet-separation (DirControl + FileControl held by host; Dir/
File granted to guest). §A-debugger-trio could be: §DebuggerView
(read-only inspection) + §DebuggerControl (step/breakpoint) +
§DebuggerAdmin (attach/detach lifecycle).

§Cycle-178-daemon-xs-worker-snapshot's §snapshot-as-internal-
implementation-detail contrasts with §debugger-as-explicit-
capability-surface. §The-snapshot-is-hidden; §the-debugger-is-
named.

## §followBreaks async iterator (Design Decision 6)

```js
const breaks = await E(debugger).followBreaks();
for await (const event of breaks) {
  // event: { path, line, reason, frames, locals }
  renderBreakpoint(event);
}
```

§Matches-the-Endo-followMessages/followNameChanges-pattern (cycle
135 daemon-locator-reference's subscription family). §UI-
subscribes-once; each break event arrives as a yield.

§Compare-to-cycle-161-filesystem-watchers' `followNameChanges`
extension on EndoMount (cycle 166). §All-of-Endo's-subscription-
APIs use the same §async-iterator-pattern.

§Cycle-171-stream/index.js's §symmetric-stream-interface is the
substrate; §followBreaks-returns-a-Reader<BreakEvent>.

## §Break-on-uncaught-exceptions augmentation (the deepest move)

§The-augmentation-section is 240 lines (lines 922-1166) and
contains the §single-deepest-architectural-insight in the
design. §The-problem:

> The xsbug protocol supports a single exception breakpoint
> mode: `path="exceptions" line="0"` sets
> `breakOnExceptionsFlag`, which causes the debugger to break
> on **every** `throw` — including exceptions that will be
> caught by a `try/catch` block.

§This-is-noisy-and-unusable-in-practice because Endo code
"throws and catches exceptions constantly as part of normal
control flow."

§The-insight: `fxDebugThrow` is called **before** `fxJump`:

```c
mxCase(XS_CODE_THROW)
    mxException = *mxStack;
#ifdef mxDebug
    fxDebugThrow(the, C_NULL, 0, "throw");
#endif
    fxJump(the);
```

§At-the-moment-fxDebugThrow-is-called, the VM has not yet
longjmp'd to the catch handler. §All-relevant-state-is-still-
live:

- `the->firstJump` is the head of a linked list of active
  exception handlers (`txJump` structs).
- Each `txJump` has a `flag` field:
  - `flag == 0` → C-level `mxTry/mxCatch` (host boundary)
  - `flag == 1` → JS-level `XS_CODE_CATCH` (JS `try/catch`)

§The-augmentation: walk the linked list at throw time.

```c
if (the->breakOnUncaughtExceptionsFlag) {
    txJump* jump = the->firstJump;
    while (jump) {
        if (jump->flag) {
            goto report;  // JS try/catch will catch this
        }
        jump = jump->nextJump;
    }
    // No JS catch found — this exception is uncaught.
    fxDebugLoop(the, path, line, message);
    return;
}
```

§The-architectural-property-that-makes-this-zero-cost is
explicit in the design:

> XS calls `fxDebugThrow` **before** `fxJump`, not after. The
> decision to break or not can be made at throw time with zero
> cost if the answer is "don't break."

§Compare-to-the-pre-design-state: a debugger that breaks after
the jump would have to §backtrack-from-the-handler-to-figure-out
which throw site it came from; the design-time-state allows the
decision to be made at the throw site with full stack + locals
available.

§The-design-names-the-architectural-advantage-explicitly: "There
is no need to 'undo' anything because execution has not left the
throw site yet."

§This-is-§exploit-the-pre-jump-window-as-the-decision-point. §A-
seemingly-small-protocol-change (new pseudo-breakpoint path
`"uncaughtExceptions"`) is enabled by a deep architectural fact
about XS's exception machinery.

§The-protocol-extension is backwards-compatible:

```xml
<set-breakpoint path="uncaughtExceptions" line="0"/>
```

§Older-xsbug-clients that don't send this pseudo-breakpoint see
no change in behavior. §Forward-compatible-protocol-extension.

## §Four-edge-cases-named-and-defended

The augmentation section enumerates four edge cases:

| Case | Behavior | Mitigation |
|------|----------|------------|
| **Promises** (`Promise.reject` / unhandled rejections) | Go through `fxCheckUnhandledRejections`, not `XS_CODE_THROW`. Augmentation doesn't apply. | XS's existing unhandled-rejection reporting handles this separately. |
| **Re-throw** (`catch` rethrows) | `XS_CODE_THROW` fires again; firstJump walk reflects new handler chain. | Correct by construction. |
| **`finally` without `catch`** | Compiles to `XS_CODE_CATCH` with `flag == 1`; walk sees it as "caught" though it will re-throw after finally. | Accepted as minor false negative for v1; could distinguish with `flag == 2`. |
| **Nested C host boundaries** | `flag == 0`; walk does not count as JS catch. | Usually correct: host-boundary catches typically indicate error. |

§The-§finally-without-catch case is the §honest-known-limitation
discipline. §Cycle-178-daemon-xs-worker-snapshot had §revised-
scope-discussion-2026-04-15; §this-design-names-the-limitation-
in-the-edge-case-table. §Both-are §honest-design-evolution-
record patterns.

## §Seven-Design-Decisions

| # | Decision | Reason |
|---|----------|--------|
| 1 | Always compiled, dormant by default | Eliminates two-binary problem; per-worker hot-attach via envelope |
| 2 | XML pass-through, not translation | Stock protocol; zero xsDebug.c changes; future XS upgrades free |
| 3 | Thread-local buffers with mutex | XS single-threaded per worker; mutex uncontended in practice |
| 4 | `"debug"` verb on existing bus | No new transport / pipes / sockets |
| 5 | Debugger as Endo capability | The Endo way; granted/delegated/revoked like any cap |
| 6 | `followBreaks` as async iterator | Matches `followMessages` / `followNameChanges` |
| 7 | No changes to xsDebug.c | Platform layer is our custom code; engine is upstream |

§Compare-to-cycle-180-hex-package's §eight-Design-Decisions and
cycle 178's §six. §This-design-has §seven — the §canonical-
Design-Decisions-format is honored without rigid count.

§Decision-7 is the §spec-driven-discipline named: the entire
debug subsystem is stock Moddable XS; only the platform layer is
custom.

## §Six-phases (Phases 1-5 done; Phase 6 partial)

| Phase | What | Status |
|-------|------|--------|
| 1 | Compile-time debug support (cargo feature + xsnap-platform.c hooks + powers/debug.rs) | done |
| 2 | Bus protocol integration (envelope verb routing + worker event loop) | done |
| 3 | DebugSession JS client (SAX parser + structured API) | done |
| 4 | Hot-attach + daemon integration (debug-attach/detach envelopes + bus handler + CESU-8 codec) | done |
| 5 | Debugger exo + CapTP integration (makeExo + M.interface + 16 CapTP tests) | done |
| 6 | Chat debugger panel (UI shell + /debug command + ~460 lines of CSS) | done (UI shell); §remaining: attachDebugger CapTP exposure + followBreaks live notification + source-view + profiling format |

§Compare-to-cycle-178-daemon-xs-worker-snapshot's three-phase
plan; §this-design-has-six-phases. §The-phase-count-scales-with-
the-vertical-stack: more layers means more landable chunks.

§The-§remaining-work named in Phase 6 includes §`attachDebugger`-
CapTP-exposure — the most important remaining gap. §Once-that-
lands, the debugger is reachable from Chat / Familiar / any
peer.

## §File-inventory (the change footprint)

§Seven-new-files + §eighteen-modified-files = §twenty-five-file
footprint.

§New-files split across three boundaries:

| Boundary | Files |
|----------|-------|
| Rust supervisor | `powers/debug.rs` + `cesu8.rs` + `debug_protocol_tests.rs` |
| Daemon JS | `debug-session.js` + `debugger.js` + `debugger-captp.test.js` |
| Chat UI | `chat/debugger-panel.js` |

§The-CESU-8-codec is a §supporting-infrastructure that emerged
from this work — XS strings use CESU-8 surrogate-pair encoding
(see cycle 176 daemon-endor-architecture's §CESU-8-surrogate-
pair-encoding-XS-string-quirk).

§Modified-files include 11 Rust files + 6 JS files + 1 CSS. §The-
modification-spread-tells-the-story: every layer touched, no
layer "owns" the change.

## §Two-design-dependencies

§The-design-cites-no-explicit-Dependencies-section, but the
prose names two §related-designs:

| Related | Relationship |
|---------|---------------|
| cycle 178 (daemon-xs-worker-snapshot) | §sibling-worker-capability — both extend xsnap engine exposure with non-obvious mechanism |
| cycle 176 (daemon-endor-architecture) | §the-Rust-supervisor-substrate this design lives within |

§Cycle-178-and-this-cycle form a §sibling-design-pair for the
xs-worker-* family: §snapshot extends with §suspend/resume;
§debugger extends with §inspect/control. §The-third-sibling
(`daemon-xs-worker-metering.md`, 828 lines, un-ingested) extends
with §observability.

§The-three-form-a §xs-worker-capability-trio: snapshot +
debugger + metering. §All-three-build-on-the-same-substrate
(cycle 176 endor-architecture) and extend the same engine layer.

## §Cohesion notes

- §Sibling-design-pair to cycle 178 daemon-xs-worker-snapshot.
  Both are In Progress, both extend xsnap engine exposure with
  envelope-bus-based control plane.
- §Stock-protocol-preserved (XML pass-through) — Option A's
  Rust-as-opaque-ferry minimizes xsDebug.c changes (Decision 7).
- §Always-compiled-dormant-by-default eliminates two-binary
  problem with §negligible-per-instruction-overhead.
- §Hot-attach via `debug-attach` envelope — no restart needed.
- §Debugger-as-Endo-capability is the §Endo-way-meta-discipline:
  everything is a capability; the debugger inherits ocap
  delegation / revocation properties.
- §The-deepest-architectural-move is §break-on-uncaught-via-
  firstJump-walk-before-fxJump: exploits the fact that
  `fxDebugThrow` runs at the throw site, not at the catch site.
  Zero-cost-if-the-answer-is-don't-break.
- §Forward-compatible-protocol-extension: new pseudo-breakpoint
  `"uncaughtExceptions"` does not affect older xsbug clients.
- §Four-edge-cases-named-and-defended including the §honest-
  finally-without-catch-false-negative.
- §Seven-Design-Decisions in the §canonical-Design-Decisions-
  format.
- §Six-phases scaling with the §six-layer-vertical-stack.
- §xs-worker-capability-trio (snapshot + debugger + metering)
  sharing cycle 176's endor substrate.
- §DebugSession-SAX-parser is a §state-machine-in-Jessie-
  compatible-JS; sibling to cycle 177-netstring/reader.js's
  §two-state-iterator and cycle 169-atomics.js' §async-generator-
  as-resumable-state-machine.

## §Tier-1 borrowing

- §always-compiled-dormant-by-default (one binary; per-instance
  activation eliminates two-binary problem)
- §XML-pass-through (Rust as opaque byte ferry; preserve vendor
  protocol)
- §hot-attach-via-envelope (no restart required)
- §debugger-as-Endo-capability (CapTP-remotable; granted /
  delegated / revoked)
- §followBreaks-async-iterator (matches followMessages/
  followNameChanges pattern)
- §break-on-uncaught-via-firstJump-walk-before-fxJump (zero-cost
  decision at throw site)
- §exploit-the-pre-jump-window-as-the-decision-point
- §forward-compatible-protocol-extension (new pseudo-breakpoint
  path; old clients unaffected)
- §three-option-architectural-decision-table (alternatives-
  considered framing)
- §six-layer-strict-stratification (C → Rust → JS → SES → CapTP
  → UI; each layer talks only to neighbors)
- §thread-local-buffers-with-mutex (single-threaded inside, safe
  outside)
- §SAX-parser-in-Jessie-compatible-JS (hand-written state machine
  for simple XML subset)
- §honest-edge-case-table with §accepted-false-negative for v1
- §finally-without-catch-as-known-limitation

## §Synthesis-target

The §slot-machine-library's worker layer can §borrow-the-six-
layer-stratification when adding non-obvious worker capabilities
(snapshot / debugger / metering equivalents). §The-protocol-
preservation-discipline (Option A) is especially valuable: when
delegating to an external vendor's substrate (XS / DOM / WASM),
treat the vendor protocol as opaque bytes and parse in your own
layer.

§The-§exploit-the-pre-jump-window-pattern is borrowable wherever
a §decision-must-be-made-before-an-irreversible-action: the
firstJump walk happens before the longjmp; the §uncaughtExceptions-
breakpoint pseudo-path is the protocol's window into that
decision.
