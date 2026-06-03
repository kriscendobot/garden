---
section: compose-suspend-and-debug-aware-resume-via-debug-flag-with-paused-at-XS-login-break
source: endo-but-for-bots--llm-designs-daemon-debug-worker-restart
topics: [daemon, tooling, hardened-javascript]
status: current
---

# Compose suspend and debug-aware resume via debug-flag with paused-at-XS-`<login>`-break

> *No new restart primitive is needed. Suspend/resume already
> exists; adding a debug flag to the resume path is minimal.
> This keeps the supervisor simple — it does not need to
> understand "restart" as a concept.*
>
> — `designs/daemon-debug-worker-restart.md` §Design Decision 1

`daemon-debug-worker-restart.md` (386 lines, *Not Started*
status, created 2026-04-17) is a **compose-existing-not-
invent-new design** by Kris Kowal *(prompted)*. Last touch
commit `100774ff` 2026-05-02 — *docs(designs): Endor
architecture, SQLite, makeArchive, and supporting designs*.

The design adds *one method* — `E(host).debugWorker('@main')`
— without any new supervisor primitive. The §minimum-protocol-
addition discipline produces a *small* design over a *large*
substrate.

## The §load-bearing-gap — §too-late-by-the-time-debugger-attaches

The existing debugger ([daemon-xs-worker-debugger](daemon-xs-worker-debugger.md))
*hot-attaches* to a *running* worker. The §What-is-the-
Problem-Being-Solved section names what's missed:

> *It cannot catch initialization code, module-level side
> effects, or the first crank of message handling — by the
> time the debugger attaches, those have already executed.*

The §too-late-by-the-time-debugger-attaches problem: most
*surprising* bugs happen *during initialization*. Module-
level side effects, the first dispatch, eager `harden()`
calls — all execute *before* a hot-attach could fire its
first break.

The §three-invariants enumerate what the new mechanism must
guarantee:

1. **XS engine paused** before executing any code.
2. **Debugger must issue `<go/>`** before the engine takes
   its first steps.
3. **Breakpoints can be set before any code runs** —
   including module-level initialization and the first
   message dispatch.

The §enumerate-the-invariants pattern: rather than just say
"start in debug mode," the design *spells out exactly what
that means*. Each invariant is independently checkable.

## The §user-facing-one-method surface

```js
const debugSession = await E(host).debugWorker('my-worker');
```

The §user-facing-one-method discipline: one Endo-host method,
one argument (pet name or path). The whole mechanism is
invisible behind it. §everything-else-is-implementation.

The §returned-Debugger-already-paused property:

> *The returned `Debugger` is attached and paused at the XS
> `<login>` break — the machine has been restored from the
> snapshot but has not executed any code.*

The §caller-must-issue-go-before-anything contract: the
worker is *frozen* from the user's perspective until the
returned `Debugger`'s `go()` / `step()` / `setBreakpoint()`
is exercised. §pause-by-default-explicit-resume.

## The §single most structurally interesting move — §compose-existing-not-invent-new

§Design Decision 1:

> *No new restart primitive is needed. Suspend/resume already
> exists; adding a debug flag to the resume path is minimal.
> This keeps the supervisor simple — it does not need to
> understand "restart" as a concept.*

The §compose-existing-not-invent-new discipline. The
mechanism is *two existing operations* (suspend + resume)
*plus one new flag*:

1. **Suspend** the worker — snapshot to CAS (existing).
2. **Set `debug-flag`** on the worker's handle (one new
   verb).
3. **Trigger resume** — the supervisor checks the flag and
   calls `debug_enable()` before machine restoration
   (existing path + one branch).

The §don't-invent-restart-as-a-concept observation: the
supervisor doesn't need a `restart` opcode. *Restart* is *just
suspend + resume* with the debug flag set in between.

The §preserve-identity-across-snapshot property:

> *The worker keeps its handle, its bus identity, its pending
> messages in the inbox, and its metering state.*

Because the restart *is* suspend+resume, all the invariants
of the suspend+resume cycle hold. §invariant-preserved-by-
composition.

## The §two-approaches-considered for the envelope protocol

The design considers **two protocol options**:

| Option | Cost |
|--------|------|
| **New `debug-resume` verb** that duplicates resume logic | Resume logic exists in two places; bugs in one don't appear in the other |
| **`debug-flag` verb sets a per-handle flag** + normal resume checks it | Smaller change; one resume code path |

**Chosen: `debug-flag` + normal resume**. The §minimize-
protocol-additions discipline:

> *This is simpler because it does not require duplicating
> the resume logic.*

The §flag-set-before-action-not-action-with-flag pattern. A
flag-then-action shape vs an action-with-flag shape. The
flag-then-action shape:

- Lets the action be a *single* code path.
- Lets the flag be set *at any time before* the action.
- Lets the flag be *queried* independently.

The §fire-and-forget-control-verb observation: the
`debug-flag` verb's nonce is 0 (no response needed). The
supervisor just sets a HashSet entry. §nonce-0-means-no-
response convention.

## The §take_debug_flag atomic-removal discipline

```rust
debug_flags: RwLock<HashSet<Handle>>,
// ...
let debug = sup.take_debug_flag(handle);
// ... in the worker thread:
if debug {
    xsnap::powers::debug::debug_enable();
}
```

The §take-not-just-read shape: `take_debug_flag` *atomically
removes* the handle from the HashSet *and* returns whether
it was present. The flag is *one-shot*:

- Set: flag goes in the HashSet.
- Take: flag is removed; returned value indicates whether
  debug was requested.

§one-shot-flag-not-persistent: a subsequent resume of the
same handle (without re-setting the flag) is a *normal*
resume. The §opt-in-per-resume property prevents accidental
debug mode bleed-through.

## The §six-step-implementation in the JS manager

```js
const debugWorker = async petNameOrPath => {
  const namePath = namePathFrom(petNameOrPath);
  assertNamePath(namePath);

  // 1. Identify the worker formula
  const workerId = await E(directory).identify(...namePath);
  if (workerId === undefined) throw new TypeError(...);

  // 2. Get the worker's bus handle
  const workerHandle = await getWorkerHandle(workerId);

  // 3. Suspend (snapshot to CAS)
  await requestSuspend(workerHandle);

  // 4. Set the debug flag
  sendControlVerb('debug-flag', { handle: workerHandle });

  // 5. Create a session that will receive <login>
  const session = createDebugSession(workerHandle);

  // 6. Trigger resume via no-op message
  sendControlVerb('debug-ping', { handle: workerHandle });

  // 7. Wait for <login>
  await session.waitForLogin();

  // 8. Return the Debugger exo
  return makeDebuggerExo(session, workerHandle);
};
```

The §sequence-matters-but-each-step-is-existing observation.
Steps 1-2 are pet-name resolution; steps 3-4 are existing
verbs; steps 5-7 are existing debugger machinery; step 8
wraps existing infrastructure in an exo.

The §inbox-as-resume-trigger observation:

> *Alternatively, if the worker's inbox already has pending
> messages, no ping is needed — the next `route_message`
> call for that handle will trigger resume.*

The §opportunistic-shortcut discipline: the `debug-ping` step
is only needed *if no other message would arrive*. A worker
with pending mail resumes naturally.

## The §<login>-break is before any bytecode

§Design Decision 3:

> *XS enters the debug loop immediately after `fxConnect`
> during machine creation/restoration. The `<login>` break is
> before any bytecode executes. This gives the caller a
> window to set breakpoints before any code runs.*

The §XS-debug-loop-fires-at-machine-creation observation: XS
itself has the *paused-at-construction* hook. The design
*uses* it; doesn't invent it.

The §`<login>`-not-first-user-code distinction matters: a
naive *first-user-code* hook would have to identify "user
code" (vs runtime / module-loader code). XS's `<login>` is
*before any of that* — even module-loader bytecode hasn't
run yet. §earliest-possible-break.

## The §metering-survives-debug-restart discipline

§Interaction with metering:

> *When a worker is restarted in debug mode, its metering
> state is preserved through the suspend/resume cycle (Phase
> 6 of the metering design). The debug session does not
> affect metering — computrons are still counted during
> debugger-driven stepping. This is correct: debugging a
> worker should not grant it unlimited computation.*

The §debug-doesn't-grant-unlimited-computation discipline.
Debugging is *observation*; it doesn't *bypass* the
substrate's resource discipline. Otherwise, a developer
could *exhaust* the budget during a step-through that's
indistinguishable from normal execution.

The §existing-mechanism-handles-escape-hatch observation:

> *If the caller wants to temporarily disable metering during
> a debug session, they can use the existing `meterSetQuota`
> to set measurement mode (hard_limit = 0).*

The §escape-hatch-exists-elsewhere pattern: the *temporary
disable* is the existing `meterSetQuota` knob, not a new
"debug doesn't meter" flag. The principle stays clean; the
escape hatch is *named and reusable*.

## The §CapTP-connections-broken acceptance

§Design Decision 4:

> *CapTP connections are broken. This is inherent to suspend/
> resume. The alternative — keeping connections alive during
> a machine restart — would require a proxy layer that does
> not exist. The cost is acceptable: debug sessions are
> developer tools, not production operations.*

The §accept-the-cost-because-developer-tool discipline. Three
parts:

1. **Acknowledge the cost** explicitly (live CapTP refs to
   the worker will break).
2. **Name the alternative** (a proxy layer keeping refs
   alive).
3. **Defer the alternative** (not worth the complexity for a
   developer tool).

The §don't-build-the-proxy-layer-for-now choice. Compare
cycle 154's §lifted-from-E.js / §no-this-receiver-check — *we
copy the proxy machinery, we don't extend it*.

The §returned-Debugger-is-itself-a-CapTP-capability
compensation: the *new* connection (the debug session) is a
fresh capability, transferable like any other. The lost
*old* connections are replaced by *new* ones if needed.

## The §five Design Decisions codify the structural choices

§Design Decisions:

1. **Compose suspend + debug-aware resume** — §compose-
   existing-not-invent-new.
2. **Debug flag on supervisor, not per-message** — §flag-
   set-before-action-not-action-with-flag.
3. **Worker paused at `<login>`, not at first user code** —
   §earliest-possible-break.
4. **CapTP connections broken** — §accept-the-cost-because-
   developer-tool.
5. **Method name `debugWorker`, not `restartWorkerInDebugMode`**
   — *Concise and discoverable. The "restart" is an
   implementation detail — from the user's perspective, they
   are debugging a worker*. §user's-perspective-not-
   implementation-detail.

The §five-decisions-form-coherent-shape: each decision
reinforces the others. *Composition* (D1) requires *minimal
protocol additions* (D2). *Earliest break* (D3) makes the
*one method* (D5) actually useful. *Accepting the connection
cost* (D4) is *consistent with* being a developer tool. The
decisions are *not independent*; they form a *coherent
design philosophy*.

## The §three-implementation-phases with tests

| Phase | Scope | Test |
|-------|-------|------|
| **1** | Rust supervisor debug flag | `take_debug_flag` returns true once, false thereafter |
| **2** | JS manager `debugWorker` | call on running worker → returned Debugger is connected and worker is paused |
| **3** | Chat integration | manual: `/debug-restart @main` opens the debugger panel |

The §phased-with-tests pattern: each phase has an *acceptance
test*. The §independent-phases-with-clear-handoffs property:
Phase 1 can land alone (test passes); Phase 2 builds on
Phase 1's landed support; Phase 3 is UI on top of Phase 2.

The §manual-test-OK-for-UI-phase concession: Phase 3's test
is manual. Chat integration is hard to automate without a
running daemon + chat UI; *manual is acceptable* given the
small surface area of the new command.

## How this design fits the @endo-but-for-bots cluster

Three explicit Dependencies:

| Design | Relationship |
|--------|-------------|
| `daemon-xs-worker-debugger` | Requires (debug infrastructure) |
| `daemon-xs-worker-snapshot` | Requires (suspend/resume) |
| `daemon-xs-worker-metering` | Composes (meter state preserved) |

The §dependency-typology — *Requires* vs *Composes*:

- **Requires**: the design *cannot ship* without this.
- **Composes**: the design *interacts* with this; both must
  understand each other.

The §two-required-pieces-make-the-substrate observation:
this design *adds one thin layer* on top of two substrates
(debugger + snapshot). Without either, the design is
inoperable. §thin-layer-on-thick-substrate.

## Related sections

- cycle 141
  [[endo-but-for-bots--llm-designs-daemon-cas-management--content-address-store-as-supervisor-owned-subsystem-with-typed-content-retain-release-and-background-mark-sweep-gc]]
  — the CAS-snapshot substrate this design's *suspend* step
  produces a snapshot in.
- cycle 145
  [[endo-but-for-bots--llm-designs-formula-inspector--pop-the-bonnet-on-pet-named-capabilities-with-edit-toggle-and-retention-path-reveal]]
  — sister observability design. Cycle 145 surfaces *static*
  formula-graph; this surfaces *dynamic* worker-state at
  pause. Pair forms a *runtime-introspection* duo.
- cycle 147
  [[endo-but-for-bots--llm-designs-workers-panel--event-loop-latency-sparkline-with-tenant-listing-retention-paths-and-correlated-log-view]]
  — sister observability design. Cycle 147's correlated-view
  shows *what's running*; this design lets you *pause it for
  inspection*. Observe + intervene as conjugate operations.
- cycle 109+ (familiar-electron-shell, etc.) — the deployment
  surface the §Chat-integration phase 3 lives on.
