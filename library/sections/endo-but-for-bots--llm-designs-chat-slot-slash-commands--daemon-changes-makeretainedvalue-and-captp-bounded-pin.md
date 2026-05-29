---
title: Daemon changes — makeRetainedValue, release exo, and the captp-bounded transient pin
source: designs/chat-slot-slash-commands.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: f3bf100cec6e0480536b3256ce0280de9487cd0c
source_date: 2026-05-06
source_authors: [Kris Kowal]
topics: [daemon, eventual-send, captp, persistence]
status: current
notes: Third of five sections for chat-slot-slash-commands. The load-bearing daemon-side mechanism. Introduces `makeRetainedValue(spec) -> { id, release }` on `EndoHost` / `EndoGuest`, a tagged-union spec covering `eval` / `marshal` / `locator` variants, a release Exo with a single `release()` method, and the captp-partition handler that fires release intrinsically when the connection severs. The transient pin is in-memory only; a restart invalidates pending Chat requests anyway. *No new formula type* — the retained value is an ordinary `eval` / `marshal` / `locator` formula with a real locator; "retained" is purely a lifecycle property (the transient-root pin), not a persisted property. The "disk before graph" rule (the daemon's own invariant for `formulateEval` / `formulateMarshalValue` ordering) is what makes release-ordering safe.
---

The daemon-side machinery is one new method on the agent
capability, one release-exo class, and a captp-partition wire-up
that bounds the pin's lifetime to the connection. The retained
value is an ordinary `eval` / `marshal` / `locator` formula with
a real locator at all times. "Retained" is a property of the
daemon's transient-pin set, not of a different identifier kind,
so every existing daemon affordance (resolve, inspect,
dependency-walk) works on the retained value without special
cases.

## `makeRetainedValue(spec) -> { id, release }`

A new method on `EndoHost` and `EndoGuest`. `spec` is a tagged
union. Initial variants:

```ts
type RetainedValueSpec =
  | { type: 'eval';
      source: string;
      codeNames: string[];
      endowments: (PetNamePath | FormulaIdentifier)[];
      workerName?: Name;
    }
  | { type: 'marshal'; value: Passable }
  | { type: 'locator'; locator: string };
```

For `type: 'eval'`, the implementation is exactly the existing
transient-pin path in `host.js` and `guest.js`: call
`formulateEval` with `pinTransient` supplied, **but do not**
`await value` and do **not** `unpinTransient` in a `finally`
before returning. Instead, return `{ id, release }` where
`release` wraps `unpinTransient(id)` and drains any resulting
collection.

For `type: 'marshal'`, delegate to `formulateMarshalValue` with
`pinTransient`. For `type: 'locator'`, delegate to
`provideLocator` (or whatever locator formula type exists under
`daemon-locator-terminology`) with a transient pin.

The `release` capability is an exo with a single `release()`
method, returned as a capability (not a thunk) so it survives
serialization. It is itself transient: its own formula inputs
retain the target, but it only lives until `release()` is called
or until the captp connection that holds the reference severs.

## Release Exo lifetime and captp partition

The release Exo is held by the Chat UI across the captp
connection to the daemon. If that connection severs (network
failure, daemon restart, Chat process termination), the Exo on
the daemon side is partitioned: its export is dropped from the
captp's export table and any outstanding eventual sends to it
reject with a bounded reason (typically a "remote disconnected"
error). The holder, while the connection was live, can obtain a
**cancellation promise** for the Exo via the standard CapTP
partition-handler mechanism (see `@endo/captp`'s connection-level
abort signal). That promise resolves (or rejects) when the captp
slot for the Exo is partitioned, allowing the holder to react to
the loss without polling.

The daemon side wires the partition signal to the Exo's intrinsic
behavior: when the captp connection severs, the daemon invokes
`release()` on the Exo's behalf, draining the transient pin. The
retained value's lifetime is therefore bounded by the captp
connection: at worst, the value remains pinned until the
connection closes, at which point it is released and (if no
other formula retains it) collected.

If the underlying captp partition-handler API is not yet exposed
in the form this design needs (per-Exo cancellation promise,
disconnection-triggered intrinsic release), the implementation
should add the minimum surface required and note the addition in
the Daemon changes phase. Pinning the value's lifetime to the
captp connection is what makes this design's leak surface
bounded; if the daemon cannot detect the disconnect, the design
degrades to "leak until daemon restart", which is unacceptable.

```
┌─────────────────────────────────────────────────────────────┐
│ Chat                                                        │
│   retainedSlot := { id, release }                           │
│   on submit success → await E(release).release()            │
│   on submit failure → keep                                  │
│   on cancel         → await E(release).release()            │
│   on captp severance → daemon releases automatically        │
└─────────────────────────────────────────────────────────────┘
            │
            ▼
┌─────────────────────────────────────────────────────────────┐
│ Daemon                                                      │
│   formulateEval(…, pinTransient)                            │
│     • persists eval formula to disk                         │
│     • pinTransient(id) inside formula-graph lock            │
│   returns { id, value: Promise<…> }                         │
│                                                             │
│   release exo                                               │
│     • release() → unpinTransient(id) + maybeCollect         │
│     • partition signal → release() invoked automatically    │
└─────────────────────────────────────────────────────────────┘
```

## Persistence: pin is in-memory only

The transient pin is in-memory only (see `graph.js`
`transientRoots`). If the daemon restarts while a Chat UI holds
a retained reference, the formula is still on disk but no longer
pinned. If nothing else retains it, the GC sweeps it on restart.
This is acceptable because a restart invalidates any pending
request in Chat anyway: the user would need to resubmit the outer
operation, at which point they will re-enter the slash command.
The alternative (persisting transient pins) would leak values
indefinitely if the Chat UI crashed before releasing.

## Release ordering: disk before graph

Chat must not call `release()` before the daemon has committed
the outer formula. The submit methods (`endow`, `submit`, ...)
return a promise that resolves when the outer formula is fully
persisted and its graph edges are in place. Chat awaits that
promise before calling `release()`. This matches the daemon's
**"disk before graph"** invariant: once `formulateEval` or
`formulateMarshalValue` has returned, the new retention edge is
live, so unpinning the previously-retained root will not collect
the value.

## No new formula type

The retained value is an ordinary formula (`eval`, `marshal`,
`locator`) with a real locator. The "retained" characteristic
is purely lifecycle: the transient-root pin tied to the captp
connection. It is not a persisted property. This avoids a
cross-cutting schema change and keeps the existing formulation
code paths authoritative. Crucially, because the slot value has a
real locator at all times (never an opaque "ephemeral
identifier" that lacks an addressable formula on disk), every
existing daemon affordance that takes a formula identifier
(resolve, inspect, dependency-walk) works on the retained value
without special cases.

Source: [designs/chat-slot-slash-commands.md](https://github.com/endojs/endo-but-for-bots/blob/f3bf100cec6e0480536b3256ce0280de9487cd0c/designs/chat-slot-slash-commands.md) at commit `f3bf100c`.
