---
id: captp-bounded-transient-pin
aliases: ["transient pin", "transient-pin", "pinTransient", "unpinTransient", "transientRoots", "makeRetainedValue", "retained value", "release exo", "captp-bounded pin", "captp partition handler", "captp partition signal", "lifetime bounded by captp", "release capability"]
topics: [daemon, eventual-send, captp, persistence]
---

# captp-bounded-transient-pin

The daemon's pattern for **letting a captp peer hold a formula
alive without granting persistence**. The pin lives in-memory only
(`graph.js`'s `transientRoots`); the connection's partition signal
wires intrinsic release; an exo capability with a single
`release()` method is the explicit deactivation handle. The
combination means a retained value's lifetime is **bounded by the
captp connection** (worst case: the pin survives until the
connection severs, at which point the daemon releases it
automatically), without the design having to invent an "ephemeral
identifier" distinct from an ordinary formula identifier.

The pattern is load-bearing for the chat-slot-slash-commands
design (cycle 83), where a `/js`, `/json`, `/locator`, or `/ref`
slash command inside a form slot needs to keep the produced value
alive *just* long enough for the outer form's submission to
absorb it as a formula input, but not so long that a Chat-side
crash leaks the pin. The same mechanism underlies the daemon's
existing transient-eval path used by the host's own `/js` without
a `resultName`: the value is pinned inside the formula-graph
lock, the caller holds it across the `await value`, then unpins
in a `finally`. `makeRetainedValue` is the generalization of that
inline path — it exposes the pin / unpin lifecycle to the
caller as a release exo, rather than tying it to one specific
call's `await`.

## Why the pin is in-memory only

Persisting the pin would leak values indefinitely if the holder
crashed before releasing. Restart-time the formula is still on
disk but no longer pinned, so the GC sweeps it if nothing else
retains it. This is acceptable because a daemon restart
invalidates any pending Chat request anyway: the user would need
to resubmit, at which point they re-enter the slash command.

## Why a release exo, not a thunk

Returning a `release` exo (a capability with a single `release()`
method) makes the lifetime **explicit and testable**. A purely
implicit scheme (e.g., "release when the gateway session sends
the next submit") would entangle UI and daemon-session state in
a way that is hard to reason about across reconnects. The captp
connection still serves as the outermost lifetime bound (via
partition-triggered release), but inside that bound the release
exo is the explicit handle the holder invokes deterministically.

The exo carries **no reference to the target value, the target's
worker, or the daemon's internal graph**; it is a deactivation
handle with zero other authority. A guest that receives a
`release` from its host cannot read or invoke the retained value
through it.

## Why "real locator over opaque ephemeral identifier"

The retained value is an ordinary `eval` / `marshal` / `locator`
formula with a real locator at all times. "Retained" is purely a
lifecycle property (the transient-root pin tied to the captp
connection), not a persisted property. This avoids a cross-cutting
schema change and keeps the existing formulation code paths
authoritative. Every existing daemon affordance that takes a
formula identifier (resolve, inspect, dependency-walk) works on
the retained value without special cases.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [chat-slot-slash-commands/daemon-changes-makeretainedvalue-and-captp-bounded-pin](../sections/endo-but-for-bots--llm-designs-chat-slot-slash-commands--daemon-changes-makeretainedvalue-and-captp-bounded-pin.md) | Canonical exposition: `makeRetainedValue(spec) -> { id, release }`; tagged-union spec for `eval` / `marshal` / `locator`; release exo with intrinsic captp-partition-triggered release; pin is in-memory only; release ordering follows "disk before graph"; no new formula type. |
| [chat-slot-slash-commands/slot-state-machine-and-handler-protocol](../sections/endo-but-for-bots--llm-designs-chat-slot-slash-commands--slot-state-machine-and-handler-protocol.md) | The Chat-UI-side caller protocol: handlers return `Promise<{ id, release }>`; release is invoked on slot clear / form cancel / successful submit; submit failure keeps the pin so the user can retry without re-evaluation. |
| [chat-slot-slash-commands/security-phases-decisions-and-known-gaps](../sections/endo-but-for-bots--llm-designs-chat-slot-slash-commands--security-phases-decisions-and-known-gaps.md) | Four security claims naming what *cannot* go wrong: pins cannot escalate authority; no reference leakage via release exo; bounded lifetime on Chat crash via captp partition; cross-peer eval exposure same as named-pet-store posture. |
| [chat-slot-slash-commands/chat-ui-slot-input-component-and-submission](../sections/endo-but-for-bots--llm-designs-chat-slot-slash-commands--chat-ui-slot-input-component-and-submission.md) | The submission half: `endow` bindings extended to accept formula IDs; `submit` already accepts arbitrary Passables; the outer form's `dispose` is the authoritative cleanup point for outstanding releases. |

## See also

- [[formula-graph]] — the durable substrate; `transientRoots` is the in-memory companion to the on-disk formula store.
- [[revocation-by-withdrawal]] — sibling lifecycle mechanism: withdrawal of the constructor cascades through the formula graph; the transient pin instead delays collection without altering the graph.
- [[caretaker-pattern]] — the release exo is a single-method deactivation handle; the caretaker pattern also splits action and control facets, and the two mechanisms compose.
- [[retention-accumulator]] — the cross-peer retention-delta batching primitive; transient pins are local-only and do not flow through the accumulator.

## Common confusions

- "Transient" here does **not** mean "non-persistent storage in
  the formula-store sense". The formula itself *is* on disk
  (transient eval still calls `formulateEval` which writes the
  formula record). What is transient is the **pin** that holds
  the formula alive across the in-memory retention check; the
  formula record persists either way.
- The release exo is **not** the same as a `caretaker` revocation
  handle: a caretaker's `revoke()` invalidates the live
  reference; `release()` merely unpins a transient root. The
  underlying formula remains valid; it is just no longer pinned
  by this captp connection.
