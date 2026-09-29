<!-- garden-job: ses-node26-lockdown-permits -->

## Goal

Make SES's `lockdown()` intrinsics-report **silent for the WHATWG `URL` family**
— no `Removing …` / `Tolerating undeletable …` lines — **with no loss of audit
rigor**. Each new permit is an explicit, powerless entry, not a blanket
allowance.

## What was noisy

Running `lockdown()` on a bare Node process emits this to stderr:

```
SES Removing unpermitted intrinsics
  Removing intrinsics.%InitialURL%.createObjectURL.prototype
  Tolerating undeletable intrinsics.%InitialURL%.createObjectURL.prototype === undefined
  Removing intrinsics.%InitialURL%.revokeObjectURL.prototype
  Tolerating undeletable intrinsics.%InitialURL%.revokeObjectURL.prototype === undefined
  Removing intrinsics.%URLSearchParamsIteratorPrototype%.RegisteredSymbol(nodejs.util.inspect.custom)
  Removing intrinsics.%URLSearchParamsPrototype%.RegisteredSymbol(nodejs.util.inspect.custom)
  Removing intrinsics.%URLPrototype%.RegisteredSymbol(nodejs.util.inspect.custom)
```

**Finding worth calling out:** this report is **identical on Node.js 22, 24, and
26** — it is *not* new in Node 26. These intrinsics have been present all along;
`permits.js` (even after the recent `%InitialURL%`/`%SharedURL%` URL split)
simply never covered them. Silencing them therefore improves the report on every
currently-tested Node major, with no version-specific behavior.

## After (Node 22 / 24 / 26)

```
=== LOCKDOWN COMPLETE (no errors thrown) ===
```

(no `Removing`/`Tolerating` lines on any of the three)

## The permits added (per-entry rationale)

Two distinct causes, each audited against the actual Node 26 descriptors:

**1. `URL.createObjectURL.prototype` / `URL.revokeObjectURL.prototype` (the
`Removing`+`Tolerating` pairs).** These two blob-registry statics are the WHATWG
File API methods. Node.js/V8 implements them as *ordinary functions* (not concise
methods), so each carries an own `.prototype` property that is **writable but
non-configurable** (`{writable:true, enumerable:false, configurable:false}`) —
lockdown cannot delete it, so it falls into the "tolerate by nulling" path and
logs both a `Removing` and a `Tolerating undeletable … === undefined` line.
`parse`/`canParse` on the same object are proper methods with no `.prototype`, so
they were already fine. The prototype's only own property is a `constructor`
back-reference to the function itself.

Fix: a new `fnWithUndeletablePrototype` permit (like `FunctionInstance` plus a
`prototype` entry) *permits* the prototype — as a hardened empty object whose
`constructor` is expressly removed (`constructor: false`) — so the whitelist pass
never tries to delete the undeletable property and stays silent. Post-lockdown
the prototype is a frozen empty object; the functions remain callable and `new
URL(…)` / `URLSearchParams` are unaffected (verified).

**2. `Symbol(nodejs.util.inspect.custom)` on `%URLPrototype%`,
`%URLSearchParamsPrototype%`, and `%URLSearchParamsIteratorPrototype%` (the three
`Removing` symbol lines).** This is a **registered** symbol
(`Symbol.for('nodejs.util.inspect.custom')` → matches the
`RegisteredSymbol(nodejs.util.inspect.custom)` permit key) — a non-standard
Node.js debugging hook used only by `util.inspect` for display. It is deletable
(configurable), so it produced only a `Removing` line. This is exactly the
property already excluded on `%TextEncoderPrototype%` /
`%TextDecoderPrototype%`; the fix adds the identical `… : false` entry (an
audited, expressly-excluded removal — silent, not blanket-permitted) to the three
URL prototypes.

## Testing

- **Repro harness**: imported `packages/ses` source directly (so `permits.js`
  edits take effect without a rebuild) and called `lockdown()` under **Node 26.8.2,
  24.20.0, and 22.23.2**. Noisy → silent on all three.
- **Full `ses` ava suite**: `553 passed, 2 known failures, 2 skipped` under
  **both Node 26.8.2 and Node 22.23.2** (identical to baseline). This includes
  `test/error/permit-removal-warnings-node.test.js`, the dedicated
  intrinsics-removal-report test, which still passes (it injects synthetic
  intrinsics and asserts those lines are *present*, so silencing the URL lines is
  compatible).
- **eslint**: `src/permits.js` clean.
- **Functional smoke (post-lockdown, Node 26)**: `new URL(…)` parses,
  `URL.createObjectURL` remains a function, its `.prototype` is a frozen empty
  object, and the `inspect.custom` symbol is gone from `URL.prototype`.

## Scope / provenance

Based on **`endojs/endo` upstream `master`** at `f183efbd` (fetched fresh, not
the `llm` branch) so it is cleanly upstreamable later; opened here on the
garden-side fork for the normal CI + panel gauntlet. No push to `endojs/endo` —
that is a separate maintainer-authorized ferry step, out of scope for this
change. CI matrix here is Node 22.x / 24.x; Node 26 is not yet a CI leg, but the
change is version-agnostic (the intrinsics are identical across the three).

