---
title: Compartment as a fresh JSContext sharing one JSRuntime
source: quickjs.c
source_repo: danfinlay/quickjs
source_branch: native-ses
source_commit: 49dc75ede0d511ddea07236622378df7f652b65e
source_date: 2026-03-28
source_authors: [Dan Finlay]
ingested: 2026-07-03
ingested_by: scholar
topics: [engine-implementation, compartments]
status: current
notes: Sibling-implementation ingest; read for comparison/synthesis, not import.
---

> Abstract: The native `Compartment` (`quickjs.c:60292-60552`) is a class
> whose each instance owns a **fresh `JSContext` in the same `JSRuntime`**
> as its parent. quickjs's realm model is the enabling fact: a `JSRuntime`
> holds the heap, GC, and atom table; a `JSContext` holds one realm's
> intrinsics and global object; multiple contexts on one runtime are cheap
> and share the heap and interned atoms. A compartment's child context is
> seeded with standard intrinsics only — **no host globals** (`print`,
> `scriptArgs`, `std`, `os`) — plus `Compartment` and `lockdown` so nesting
> works. `evaluate(src)` runs strict global `JS_Eval` in the child; `globals`
> endowments are copied property-by-property into the child global;
> exceptions are re-thrown across the context boundary. Because parent and
> child share one heap, endowments cross as **live object references with no
> membrane** — the isolation is realm-level (separate globals/intrinsics),
> not heap-level.

## The context-per-compartment construction

```c
// js_compartment_new_context, quickjs.c:60323
ctx = JS_NewContextRaw(rt);                    // same runtime rt as parent
JS_AddIntrinsicBaseObjects(ctx) || ... ||      // standard intrinsics only
JS_AddIntrinsicWeakRef(ctx);                   // NO host-lib intrinsics
JS_AddIntrinsicCompartment(ctx) ||             // so nesting works
JS_AddIntrinsicLockdown(ctx);
```

The child gets `BaseObjects, Date, Eval, RegExp, JSON, Proxy, MapSet,
TypedArrays, Promise, WeakRef, Compartment, Lockdown` — the ECMAScript
intrinsics but none of the qjs host surface. `tests/test_compartment.js`
checks both halves: `typeof Object === 'function'` … `typeof Proxy` etc.
all present, while `print` and `scriptArgs` throw (not accessible). Because
each compartment is a distinct context, globals are isolated: one
compartment's `globalThis.secret = 123` is invisible to a sibling.

## Options: SES-style and TC39-style endowments

The constructor (`quickjs.c:60351`) accepts three option shapes
(`quickjs.c:60382-60434`):

- **SES-style** `new Compartment({ __options__: true, globals: {…}, name })`
  — the `__options__` sigil selects this path.
- **TC39-style** `new Compartment({ globals: {…}, name: "…" })`.
- **Legacy** `new Compartment(endowmentsObjectDirectly)`.

Endowments are applied by enumerating the `globals` object's own
string+symbol properties and `JS_SetProperty`-ing each onto the child's
global (`quickjs.c:60408-60425`). Function endowments work
(`pushLog` in the test calls back into a parent-side array). A `name` is
stored for the `name` getter; missing name reads back `undefined`.

## Evaluate, globalThis, import, errors

- **`evaluate(src)`** (`quickjs.c:60440`) runs
  `JS_Eval(child_ctx, src, …, JS_EVAL_TYPE_GLOBAL | JS_EVAL_FLAG_STRICT)` —
  **strict by default**, so `with({})` and octal literals throw. On
  exception it does `JS_GetException(child_ctx)` then `JS_Throw(ctx, exc)`
  to propagate across the boundary. Cross-realm `instanceof` may not hold
  (distinct intrinsics), but `e.name` and `e.message` survive, as the test
  asserts.
- **`get globalThis`** (`quickjs.c:60465`) returns the child's global; it is
  **mutable from outside** (`c.globalThis.injected = 99` then
  `c.evaluate('injected') === 99`).
- **`import(specifier)`** (`quickjs.c:60485`) is a thin hack: it
  `snprintf`s `import('<specifier>')` into a source buffer and evals it as a
  module in the child. There is no module map and no import hook — and the
  specifier is spliced into source text unescaped. This is the weakest part
  of the surface and not a model to copy.
- **`[Symbol.toStringTag]`** is `"Compartment"`.

## The isolation model: realm-level, not heap-level

The single most important architectural fact for the XS reading:
parent and child compartments **share one `JSRuntime` heap**. That is what
makes compartments cheap (no second heap, shared GC and atoms) and makes
endowments *fast* — a `globals` value crosses as a **live reference into the
parent heap**, not a copy or a wrapper. It is also what makes the isolation
**weaker than a membrane**: confined code that is handed a live object can,
in principle, reach through it (its prototype, its methods' captured scope)
back toward parent-realm objects. SES's compartment model plus `harden` and
the pass-style membrane discipline exist precisely to police that boundary;
this native Compartment provides the realm split but not the membrane.
The contrast with a separate-heap engine (XS's `txMachine`) — where the
boundary is necessarily a marshaling membrane — is drawn out in
[xs-transferable-strategies](danfinlay-quickjs--native-ses--xs-transferable-strategies.md).

Source: [quickjs.c](https://github.com/danfinlay/quickjs/blob/49dc75ede0d511ddea07236622378df7f652b65e/quickjs.c#L60292) at commit `49dc75e`.
