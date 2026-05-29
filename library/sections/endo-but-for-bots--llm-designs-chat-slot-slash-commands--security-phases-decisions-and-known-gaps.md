---
title: Security considerations, phased implementation, design decisions, and known gaps
source: designs/chat-slot-slash-commands.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: f3bf100cec6e0480536b3256ce0280de9487cd0c
source_date: 2026-05-06
source_authors: [Kris Kowal]
topics: [chat-ui, daemon, capability-security, eventual-send]
status: current
notes: Fifth and final section for chat-slot-slash-commands. Consolidates four end-of-design sections (security considerations, dependencies, phased implementation, design decisions) plus the known-gaps and affected-packages footers. Four security claims: retained pins cannot escalate authority; no daemon-internal reference leakage via the release exo; bounded lifetime on Chat crash via captp partition; cross-peer eval exposure has same confinement posture as named pet-store values. Seven load-bearing design decisions, including *slot as the unit of transient retention not the command*, *transient pin over deferred formulation*, *real locator over opaque ephemeral identifier*, and *no new message type*. Five-phase implementation totaling ~1 developer-week.
---

The final design surface: four security claims naming what
*cannot* go wrong, a five-phase implementation plan, seven
load-bearing decisions, and a known-gaps footer that defers
quota / telemetry to post-shipping observation.

## Security considerations

- **Retained pins cannot escalate authority.**
  `makeRetainedValue` runs inside the caller's agent (host or
  guest) and pins a formula that the caller is already authorised
  to produce via its existing `evaluate` / `storeValue` /
  `provideLocator` verbs. The only added capability is the right
  to *delay* its collection until a `release` capability is
  invoked or until the captp connection severs. Object-capability
  confinement on the formula itself is unchanged: the eval body
  sees only the endowments it was given.

- **No daemon-internal reference leakage.**
  `release` is an exo whose only method is `release()`. It
  carries no reference to the target value, the target's worker,
  or the daemon's internal graph; it is a deactivation handle
  with zero other authority. A guest that receives a `release`
  from its host cannot read or invoke the retained value through
  it.

- **Bounded lifetime on Chat crash.**
  If the Chat UI process dies between slash-command evaluation
  and form submission, the WebSocket to the daemon closes and the
  captp partition handler fires. Each release Exo held over that
  connection is partitioned and its intrinsic disconnect handler
  invokes `release()` on the daemon side, dropping the transient
  pin. This bounds leakage strictly to the duration of a live
  Chat captp session.

- **Cross-peer eval exposure.**
  Slot slash commands are evaluated in the agent that owns the
  Chat profile. If the enclosing form is being sent to a remote
  peer (for example, a guest filling a slot on a form from a
  remote host), the retained formula is created in the guest's
  namespace. The remote peer receives a *reference* to the
  resulting capability, not the source. This is the same
  confinement posture as naming a value in the pet store and
  passing it by reference.

## Dependencies

| Design | Relationship |
|--------|--------------|
| `daemon-form-request.md` | Forms with slots are the primary consumer; this design extends how slot values are supplied. |
| `chat-command-bar.md` | Slash syntax and modeline conventions reused inside slots, including the Cmd-Enter Monaco expansion. |
| `daemon-guest-eval-simplification.md` | `/js` inside a guest's slot relies on direct `formulateEval` without proposal review. |
| `chat-pending-commands.md` | Slot slash commands are *not* pending commands themselves; this design clarifies the boundary. |
| `daemon-commands-as-messages.md` | If commands become messages, the outer form's message can absorb retained inputs as its formula inputs. |
| `daemon-cross-peer-gc.md` | Retained pins interact with the cross-peer GC protocol only through ordinary retention edges; no new cross-peer concerns. |

## Phased implementation

1. **Daemon: `makeRetainedValue` for `type: 'eval'`.**
   Introduce the method on host and guest, reusing the existing
   transient-pin-and-await path but exposing a `release` exo.
   Wire the captp partition signal to the Exo's intrinsic
   release. Unit tests: pin retention across an await; release
   triggers collection; retention through a second formula
   prevents collection after release; captp disconnect triggers
   release. *Size: S-M (2 to 3 days), captp partition wiring
   being the open variable.*

2. **Chat: extract `createSlotInput`.**
   Consolidate the current slot-input clones in `endow-modal.js`
   and `inbox-component.js` into one component. No behavioural
   change yet, just refactor with the existing pet-name-only
   semantics. *Size: S (1 day).*

3. **Chat: slash mode, `/js` verb, picker drop-down,
   show-value.** Add the state machine, the slash chip, the
   `/js` handler that calls
   `makeRetainedValue({ type: 'eval', … })`, the petname picker
   drop-down with modeline `/` hint, and the chip's show-value
   affordance. Wire the release lifecycle to the form's submit /
   cancel / dispose. Add Cmd-Enter Monaco expansion mirroring the
   command bar. *Size: M (3 to 4 days).*

4. **Daemon + Chat: submission acceptance of formula IDs.**
   Extend `endow` bindings and `submit` values to accept formula
   IDs alongside pet names. Make Chat serialise retained slot
   values as formula IDs in the outbound payload. *Size: S-M
   (1 to 2 days).*

5. **Additional verbs.** Add `/json`, `/locator`, and `/ref`.
   *Size: S (1 to 2 days).*

Total: **M, roughly 1 week** for one developer.

## Seven load-bearing design decisions

1. **Slot as the unit of transient retention, not the command.**
   Transience belongs to the *use* of a value, not to the verb
   that produced it. `/js` in the command bar with `resultName`
   is persistent; the same `/js` inside a slot is transient
   because the slot's consumer decides its fate. This keeps the
   verb semantics uniform across contexts.

2. **Transient pin over "deferred formulation".**
   An alternative is to defer formulation entirely: the slot
   records the source text and arguments, and formulation
   happens only when the outer form submits. We rejected this
   because errors must surface immediately at the slot (syntax
   errors, resolver failures, worker-start failures) rather than
   appearing as opaque submit failures on the outer form.
   Formulate-now-pin-briefly preserves the existing eval error
   paths.

3. **Slash prefix is always the trigger.**
   A per-field toggle is less fluent for keyboard users. The
   slash prefix matches Chat's existing vocabulary and is
   unambiguous relative to pet names. A picker drop-down is
   still provided for mouse users, opening the petname
   drop-down first and advertising `/` as the route to commands.

4. **Verbs are registered, not hard-coded in the slot.**
   Slot verbs share a registry with command-bar commands but are
   filtered by slot `type`. This lets a `source`-typed slot
   expose only `/js`, while a generic capability slot exposes
   the full set.

5. **Release by capability, not by channel state.**
   Returning a `release` exo makes the lifetime explicit and
   testable. A purely implicit scheme (e.g., "release when the
   gateway session sends the next submit") would entangle UI
   and daemon-session state in a way that is hard to reason
   about across reconnects. The captp connection still serves
   as the outermost lifetime bound (via partition-triggered
   release), but inside that bound the release Exo is the
   explicit handle.

6. **Real locator over opaque ephemeral identifier.**
   Every slot value either has a real locator (a formula
   identifier the daemon recognises) or is a passable that the
   daemon can marshal. We deliberately do not introduce an
   "ephemeral identifier" distinct from an ordinary formula
   identifier. The retention is a property of the daemon's
   transient pin set, not of a different identifier kind. This
   means every existing affordance (show value, inspect,
   resolve, dependency-walk) works on the retained value
   without special cases.

7. **No new message type.**
   Slot slash commands never produce daemon messages. The outer
   form still produces the single `submit`, `endow`, or `form`
   message it already produces today, now with formula IDs in
   its payload. This keeps the message protocol unchanged.

## Known gaps and future considerations

- Define the exact wire representation of a formula ID in
  `endow` bindings and `submit` values (tagged string vs.
  marshalled remotable). The simplest option is to leverage the
  existing marshalled Passable pipeline: the Chat UI resolves
  the retained ID to its capability through `provide(id)` and
  hands *that* capability to `submit`. Evaluate whether the
  additional round-trip is worth the uniformity.
- Confirm the captp partition-handler API surface needed to
  trigger Exo intrinsic release on disconnect. If the per-Exo
  cancellation promise is not yet exposed by `@endo/captp`, the
  implementation phase adds the minimum surface required.
- **Future consideration:** a `/view`-like read-only inspector
  inside a slot. The chip's "show value" button covers the
  immediate need by reusing the existing value modal; a
  slot-local `/view` verb is a worthwhile follow-up.
- **Future consideration:** per-gateway pin quota. No quota is
  needed at this time; the captp-bounded lifetime is the
  load-bearing safeguard. If future telemetry shows pathological
  pin counts during a single session, a quota can be added then.
- **Future consideration:** telemetry to record slot-slash usage
  patterns and inform the verb set.

## Affected packages

- `packages/daemon/src/host.js`, `guest.js`: add
  `makeRetainedValue`; extract the shared transient-eval helper.
- `packages/daemon/src/daemon.js`: export the helper and the
  `release` exo constructor from `DaemonCore`.
- `packages/daemon/src/mail.js`: `endow`, `submit`, and form
  handling accept formula IDs in binding positions.
- `packages/daemon/src/interfaces.js`: interface guards for
  `makeRetainedValue`.
- `packages/daemon/src/help-text.js`, `help.md`: document the
  new verb.
- `packages/daemon/src/graph.js`: expose a captp-scoped pin
  tracker (minor extension of the existing `pinTransient`
  counter) and wire the partition-handler intrinsic release.
- `packages/daemon/src/daemon.js` (gateway bind): track
  transient pins per captp connection and release on disconnect.
- `packages/chat/slot-input.js` (new): unified slot input
  component with slash mode, picker drop-down, and show-value
  affordance.
- `packages/chat/endow-modal.js`, `inbox-component.js`,
  `send-form.js`, `form-builder.js`,
  `counter-proposal-form.js`: migrate to `slot-input.js`.
- `packages/chat/command-registry.js`: new `slotVerbs` table
  keyed by slot type.
- `packages/chat/index.css`: styles for the slash chip, retained
  chip, picker drop-down, and error substate.

Source: [designs/chat-slot-slash-commands.md](https://github.com/endojs/endo-but-for-bots/blob/f3bf100cec6e0480536b3256ce0280de9487cd0c/designs/chat-slot-slash-commands.md) at commit `f3bf100c`.
