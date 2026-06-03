---
section: two-coordinated-changes-with-error-shape-sentinel-and-four-case-rendering-fallback
source: endo-but-for-bots--llm-designs-unhandled-rejection-display
topics: [daemon, captp, errors]
status: current
---

# Two-coordinated-changes with Error-shape sentinel and four-case rendering fallback

> *Either part on its own is insufficient: a sender that
> preserves Error structure does no good if the receiver's
> display still falls through to a formatter that drops it;
> a smarter receiver display has nothing to display if the
> wire stripped the structure.*
>
> — `designs/unhandled-rejection-display.md` §Two coordinated changes

`unhandled-rejection-display.md` (323 lines, *Complete*
status, shipped 2026-05-11 via PR #187) is a tight,
load-bearing CapTP diagnostic-path design. Author Kris Kowal
*(prompted)*; design phase single commit 2026-05-10;
implementation 2026-05-11-12. The §three-day-active-
development calibration is recorded via `git blame` on the
`llm` branch.

## The §load-bearing-symptom-and-diagnosis

The §What-is-the-Problem-Being-Solved paragraph names the
exact mechanism:

> *When a CapTP `CTP_DISCONNECT.reason` carries an `Error`
> instance, the JSON-encoded form on the wire is the empty
> object `{}` because `Error`'s own properties (`message`,
> `stack`, `name`) are non-enumerable and therefore invisible
> to `JSON.stringify`.*

The §non-enumerable-Error-properties-and-JSON.stringify
collision: `Error.prototype` defines `name`, `message`, and
`stack` as *non-enumerable* properties. `JSON.stringify`
*only* iterates enumerable own properties. Result: any
`Error` instance encodes as `"{}"`.

The §receiver-prints-empty-curly downstream effect: the
daemon's unhandled-rejection trap prints
*`CapTP <name> exception: {} ''`* — *literally* the empty
object. The §triage-failure consequence: *triage cannot
distinguish a `socket has been ended` race from an
`assert.fail` in a guest formula*.

The §repro-test-pins-both-sides observation: PR #174's
regression test exercises both the wire round-trip (Error
becomes `{}`) and the receiver-side display (formatter prints
empty braces).

## The §single most structurally interesting move — §two-coordinated-changes

The fix has **two parts that must coordinate**. The
§either-part-alone-is-insufficient framing is named
explicitly:

> *Either part on its own is insufficient: a sender that
> preserves Error structure does no good if the receiver's
> display still falls through to a formatter that drops it;
> a smarter receiver display has nothing to display if the
> wire stripped the structure.*

The §coordinated-changes-as-design-shape discipline: a single
diagnostic fix is *one piece of work* but spans *two code
sites* (sender + receiver). The design treats them as a
*coordinated pair* rather than two separate designs. This is
the §wire-and-display-are-conjugate-sides framing later
echoed in the *helper-lives-next-to-encoder* discipline.

## The §sender-side — §encode Error reasons before stringify

The diff in `packages/daemon/src/connection.js`'s
`messageToBytes`:

```js
export const messageToBytes = message => {
  let outgoing = message;
  if (message?.type === 'CTP_DISCONNECT' && message.reason instanceof Error) {
    const { name, message: errMessage, stack } = message.reason;
    outgoing = {
      ...message,
      reason: { '@@error': true, name, message: errMessage, stack },
    };
  }
  const text = JSON.stringify(outgoing);
  const bytes = textEncoder.encode(text);
  return bytes;
};
```

The §three-property-extraction (name + message + stack)
matches what cycle 87's `pass-style/error.js` defines as the
four-property error allowlist (`message`/`stack`/`cause`/
`errors`); the design takes the three single-Error properties
and leaves `cause` aside (deferred to future work).

The §sentinel-not-duck-typing discipline:

> *The `'@@error': true` sentinel marks the encoded shape so
> the receiver can decide whether to reconstruct an `Error`
> instance or just render the fields. The sentinel is
> preferable to duck-typing on `'message' in reason && 'stack'
> in reason` because nothing prevents an application from
> sending a plain object with those field names.*

The §unique-sentinel-not-presence-of-fields discipline: a
plain object `{ name, message, stack }` *could be the
intended payload*. The `'@@error': true` sentinel
*unambiguously* signals "this was an Error instance on the
sender side". The §`@@`-prefix-convention propagates the
cycle 148 (symbol.js Hilbert-Hotel) discipline that `@@`-
prefixed names are *reserved* for system-level encoding.

The §narrow-guard-keeps-out-of-hot-path discipline: *The
narrow guard on `message.type === 'CTP_DISCONNECT'` keeps the
change out of the hot path for `CTP_CALL` and friends, which
already serialize Error fulfilments through `@endo/marshal`*.

§Hot-path-vs-cold-path partition: the disconnect path is
*cold* (fires once at session end). Adding logic there is
free. The call path (`CTP_CALL`/`CTP_RETURN`/`CTP_RESOLVE`)
is *hot* (every method invocation). Touching `messageToBytes`
*generally* would impose per-call cost. The §narrow-guard
keeps the cost on the cold path only.

## The §receiver-side — §four-case rendering fallback

The new `renderRejection` helper:

```js
const renderRejection = reason => {
  if (reason instanceof Error) {
    return `${reason.name}: ${reason.message}\n${reason.stack || ''}`;
  }
  if (
    reason &&
    typeof reason === 'object' &&
    reason['@@error'] === true
  ) {
    const { name = 'Error', message = '', stack = '' } = reason;
    return `${name}: ${message}\n${stack}`;
  }
  if (isPassable(reason)) {
    return passableAsJustin(reason);
  }
  return `(non-passable ${typeof reason}) ${String(reason)}`;
};
```

The §four-case-fallback ladder:

1. **Real `Error` instance** → `name: message\nstack`. (For
   local rejections that didn't go through the wire.)
2. **`'@@error': true` sentinel** → reconstruct as
   `name: message\nstack`. (For wire-received Errors.)
3. **Passable** (per `isPassable` from `@endo/marshal`) →
   `passableAsJustin(reason)`. (For non-Error reasons that
   *are* passable: strings, numbers, plain objects without
   remotables.)
4. **Non-passable** → `(non-passable <type>) String(reason)`.
   (Final defence: unbound functions, unregistered remotables,
   unknown reason types.)

The §`passableAsJustin`-not-`JSON.stringify` discipline:

> *`passableAsJustin` is the project-standard rendering for
> diagnostic display (per the Diagnostic Discipline rule in
> `CLAUDE.md`). It is unambiguous for remotables and promises,
> where `JSON.stringify` would strip them to `{}` or render
> them as `[object Object]`.*

The §use-marshal-for-display-not-wire distinction: marshal
*on the wire* requires marshal tables (rejected per
Alternative 1); marshal *for display* (via `passableAsJustin`)
is a *one-way* read-only render that doesn't depend on table
state. Cycle 84's rankOrder.js was an earlier appearance of
the same justin-rendering discipline.

The §`(non-passable <type>) String(reason)` final-defence
shape: even an unbound function gets *some* useful output
(`(non-passable function) function foo() { ... }`).

## The §don't-route-through-marshal — Alternative 1 rejected

The most structurally interesting *Rejected Alternatives*
entry:

> *Rejected: the disconnect path runs precisely when the
> connection state is unreliable. The marshal tables may have
> been GC'd, the c-list may be partially torn down, or the
> disconnect may be happening because marshal itself failed.
> Adding a serialize step in the disconnect path adds another
> failure mode to the diagnostic. The Error-shape extraction
> is intentionally syntactic (no marshal, no exo machinery)
> so it cannot itself fail mid-disconnect.*

The §error-path-cannot-depend-on-error-path discipline: the
disconnect mechanism is itself error-reporting; routing it
through marshal would create a *circular failure mode*: if
marshal itself broke (causing the disconnect), routing the
disconnect through marshal would *re-trigger* the same
failure.

The §extraction-is-intentionally-syntactic move: read three
non-enumerable fields directly via destructuring. No method
dispatch, no proxy traps, no table lookups, no exo invocation.
*Purely syntactic*. Cannot fail.

This is the cycle's most generalizable insight: **diagnostic
paths must not depend on the substrate they diagnose**. The
parallel to cycle 100's `unhandled-rejection.js` (SES's
GC-driven rejection tracker that *doesn't* depend on the
console it would normally write to) is direct.

## The §don't-use-replacer — Alternative 2 rejected

> *Rejected as the sole change because the `replacer` runs at
> every key in the tree, not just the top-level `reason`. A
> nested Error in a passable graph would also be flattened to
> fields, which would conflict with the marshal-side encoding
> for `CTP_RETURN.exception`.*

The §narrow-guard-not-tree-walk discipline. JSON's `replacer`
hook fires at *every* node; the design wants to touch *one
specific field on one specific message type*. The replacer
approach would *over-apply* the transformation, breaking the
marshal-encoded errors in CTP_RETURN.

The §two-different-error-encodings-must-coexist invariant:
`CTP_DISCONNECT.reason` uses the new `@@error` plain-shape
encoding; `CTP_RETURN.exception` uses marshal's existing
errorIdNum-based encoding. Both must work. The replacer would
collapse them.

## The §don't-receiver-only — Alternative 3 rejected

> *Rejected: the message is gone. No amount of receiver
> cleverness can recover the original `Error.message` that
> `JSON.stringify` discarded on the sender. A receiver-only
> fix produces a diagnostic that says "we lost something" but
> not what was lost.*

The §you-can't-fix-it-on-receiver-because-bytes-are-lost
discipline: this is the *fundamental information-theoretic
constraint* on the design. The wire format is the
information-channel bottleneck; whatever doesn't survive
serialization *cannot* be reconstructed downstream. The
two-coordinated-changes structure is *forced* by this
constraint.

## The §don't-replace-JSON-with-Justin — Alternative 4 rejected

> *Rejected: `passableAsJustin` produces a string in the
> Justin language. That string would have to be parsed back
> on the receiver, which would itself need a Justin parser.
> The wire format would become incompatible with peers that
> have not adopted the change.*

The §peer-compatibility-during-rollout discipline. The
chosen design is *strictly additive*: the unmodified field
set survives unchanged; only the `reason` field shape changes
when it carries an Error. Peers that haven't yet adopted the
change see the encoded shape as a plain object with field
names — *still parseable*, still renders (badly, but
non-fatally).

Replacing JSON wholesale would break the §progressive-
rollout-without-flag-day property.

## The §helper-lives-next-to-encoder

> *The `renderRejection` helper lives next to `messageToBytes`
> because the two are conjugate sides of the same wire-shape
> decision.*

The §wire-and-display-as-conjugate-sides discipline: the
encoder writes `'@@error': true`; the decoder reads it. Both
must agree on the sentinel and the field set. Putting them in
adjacent code makes the *coupling* visible. A future change
to either *forces* a paired change.

§Future-portability gesture: *A future refactor could move
it to `@endo/captp` if other consumers grow a need for it*.
The §Open question #2 names this explicitly: `@endo/captp`'s
own `defaultOnReject` has the same `{}` rendering bug for any
captp consumer that doesn't provide a custom `onReject`. The
implementation PR is encouraged to *lift the helper into
@endo/captp* so the fix is at the source.

## The §three-day-active-development calibration

The §Status block records the *ship-then-roadmap-calibrate*
discipline:

- Design phase: 2026-05-10 (single commit `8b2022d70`)
- Implementation phase: 2026-05-11 → 2026-05-12 (2 days)
- PR #187 squash-merge `a588f0b80` 2026-05-11
- Parallel non-bot commit `74a56009a` 2026-05-12

The §roadmap-calibration-via-git-blame discipline is the same
shape as cycle 95's chat-rename-dismiss-to-clear's 65-day
calendar-window record. The design isn't *just* a spec; it's
also the canonical history record of *how long this kind of
change actually takes*. Useful for future roadmap projection.

The §three-day-active-span observation: from design-commit
to ship-commit was 3 days. A small, well-scoped change with a
pre-existing failing test (PR #174) compresses the cycle.

## The §migration-without-caller-change

> *The migration does not require any caller change. Existing
> call sites that pass `Error` reasons get a strictly better
> diagnostic. Existing call sites that pass non-Passable
> reasons get a slightly more informative diagnostic and
> remain candidates for a follow-up cleanup pass.*

The §no-flag-day-required property. The four-case fallback
*handles every existing call site shape* without changes; the
upgrade is purely the daemon's encoder + decoder. The §strictly-
additive-on-receiver-side discipline (cycle 87's pass-style/
error.js had a similar §host-configuration-defense framing).

## The §three-open-questions — §honest-deferral discipline

§Open questions deliberately deferred:

1. **`'@@error'` vs marshal `errorIdNum`** — cycle 87's
   error.js uses errorIdNum for marshal-encoded errors;
   `@@error` is the disconnect-path equivalent. The §two-
   encodings-coexist invariant is the answer.
2. **Should `renderRejection` move to `@endo/captp`?** — the
   bug is at the source there; current daemon-only landing is
   pragmatic but not optimal. The §honest-acknowledgment-of-
   incomplete-fix discipline.
3. **Plain shape vs CapData blob?** — *Plain shape is simpler
   and survives `JSON.parse` directly*. The §recommendation
   *plain shape for now; revisit if richer Error preservation
   is needed* is the standard §do-the-simple-thing-first
   discipline.

## How this design fits the @endo/captp + @endo/marshal cluster

- **Cycle 87** [[endo--packages-pass-style-src-error-js--passable-error-validation-surface]]
  — the pass-style error.js defines the four-property error
  allowlist (`message`/`stack`/`cause`/`errors`); this design
  takes three of them and leaves `cause` for future work.
- **Cycle 100** [[endo--packages-ses-src-error-unhandled-rejection-js--SES-rejection-tracking-via-GC-driven-finalization]]
  — the SES rejection-tracking machinery that *fires* this
  diagnostic. Both designs share the §diagnostic-cannot-
  depend-on-substrate discipline.
- **Cycle 84** [[endo--packages-marshal-src-rankorder-js--in-memory-rank-order-regime]]
  — the `passableAsJustin` rendering used here is from the
  same marshal layer.
- **Cycle 148** [[endo--packages-pass-style-src-symbol-js--passable-symbols-Hilbert-Hotel-encoding-with-forward-compatibility-via-throw]]
  — the `@@`-prefix-convention this design uses for its
  sentinel is the same convention this earlier file
  establishes for the passable-symbol wire shape.

## Related sections

- cycle 87
  [[endo--packages-pass-style-src-error-js--passable-error-validation-surface]]
  — three of the four pass-style error properties form the
  sentinel payload here.
- cycle 100
  [[endo--packages-ses-src-error-unhandled-rejection-js--SES-rejection-tracking-via-GC-driven-finalization]]
  — the SES rejection-tracker that *fires* this diagnostic.
- cycle 148
  [[endo--packages-pass-style-src-symbol-js--passable-symbols-Hilbert-Hotel-encoding-with-forward-compatibility-via-throw]]
  — the `@@`-prefix-convention for system-level wire encodings.
- cycle 95
  (chat-rename-dismiss-to-clear) — sibling
  §roadmap-calibration-via-git-blame discipline.
