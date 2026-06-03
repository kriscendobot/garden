---
ts: 2026-06-03T00:42:07Z
host: endolin
role: liaison
kind: result
dispatch_id: liaison--ee3d1c
cycle: 132
---

# Cycle 132 — local.js (Kris Kowal, endo) — comments-lane

Ingested `packages/eventual-send/src/local.js` (139 lines) from
`endojs/endo@e56bf00f` (master). **Twenty-fifth comment-fragment
ingest.** One cohesion-honest section:

- **three-local-delivery-primitives-with-debugger-breakpoint-
  integration-and-getMethodNames-introspection** — the *local-
  delivery primitive layer* for HandledPromise dispatch to
  non-remote recipients. Direct consumer of cycle 130's
  `makeMessageBreakpointTester` (instantiated as `onDelivery`
  with env-option name `ENDO_DELIVERY_BREAKPOINTS`).

## The single most structurally interesting move

§The placement-at-the-actual-delivery-point — two identical
debugger-breakpoint blocks (in localApplyFunction and
localApplyMethod) carry identical inline comments:

> *Stopped at a breakpoint on this delivery of an eventual method
> call so that you can step *into* the following `apply` in order
> to see the method call as it happens. Or step *over* to see what
> happens after the method call returns.*

The §STEP-INTO-APPLY-comment-pair is the *user-facing affordance*:
when the debugger pauses, the inline comment tells the developer
exactly what to do next. The placement *right before the `apply`
call* — not at the call site — is what solves cycle 130's
*async-call-debugging-pain-point*.

## §getMethodNames with four disciplines

Walks the prototype chain collecting all method names. Four
structurally interesting moves:

1. **§Set-to-deduplicate** across prototype layers.
2. **§Test-val-name-rather-than-layer-name** — respect subclass
   overrides; *in case a method is overridden by a non-method,
   test `val[name]` rather than `layer[name]`*.
3. **§Stop-at-Object-prototype** — don't leak `toString`,
   `hasOwnProperty`, etc.
4. **§Primitive-early-exit** — stops walking when value is
   primitive.

§compareStringified sort *prioritizes symbols as earlier than
strings*. §getMethodNames is both a public API and an *internal
debugging affordance* (used in error messages to show *target has
no method "foo", has ["bar", "baz", "qux"]*).

## §The cyclic-dependency-between-packages observation

The §opening TODO names the layering constraint:

> *Consolidate with `isPrimitive` that's currently in
> `@endo/pass-style`. Layering constraints make this tricky.*

`@endo/eventual-send` is foundational; `@endo/pass-style` depends
on it transitively; consolidating `isPrimitive` would create a
dependency cycle. The duplication is the *acknowledged-cost-of-
layering* discipline.

## Eventual-send coverage in the library

With this ingest the eventual-send package now has **five files
in the library**:

- cycle 66 — `handled-promise.js` §handler-protocol
- cycles 78+79+82 — three `track-turns.js` sections
- cycle 130 — `message-breakpoints.js`
- **cycle 132 (this cycle)** — `local.js`

Together they cover the eventual-send local-dispatch surface.

## Rotation note

Cycle 132 was nominally **comments-lane** (cycle 131 was the
final endopi-* ingest closing the family at 9/9). Papers-lane has
been blocked for **26+ consecutive cycles** due to lack of PDF-
fetching infrastructure.

## Counts

- 635 → **636** sections (+1).
- 176 → **177** source documents (+1).
- Topic pages updated: `eventual-send.md` (+1 row — fifth
  eventual-send row).
- Keywords index extended with ~28 local-delivery-specific
  keywords.
- Sources/README.md updated (+1 row).
- Sections/README.md updated (+1 group; total adjusted).

## Next cycle

Cycle 133 wakes in 1500s. Rotation lands on **papers-lane**
nominally (still blocked at 26+). Expect another pivot — either
to comments-lane (more @endo source files, e.g., E.js 501 lines)
or designs-lane (daemon-* family has ~25 unexplored designs).
