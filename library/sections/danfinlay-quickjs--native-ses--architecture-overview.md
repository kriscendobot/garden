---
title: Native SES architecture — three C primitives, freeze without tame
source: quickjs.c, quickjs.h, quickjs-atom.h
source_repo: danfinlay/quickjs
source_branch: native-ses
source_commit: 49dc75ede0d511ddea07236622378df7f652b65e
source_date: 2026-03-28
source_authors: [Dan Finlay]
ingested: 2026-07-03
ingested_by: scholar
topics: [engine-implementation, hardened-javascript, compartments]
status: current
notes: Sibling-implementation ingest; read for comparison/synthesis, not import.
---

> Abstract: The `native-ses` fork adds three SES primitives directly to the
> quickjs-ng C engine — `harden()`, `lockdown()`, and a `Compartment` class —
> registered as intrinsics in the default context init (`quickjs.c:2517`)
> and re-added to every child compartment context. The public C surface is
> four functions (`JS_DeepFreeze`, `JS_FreezeIntrinsics`,
> `JS_AddIntrinsicLockdown`, `JS_AddIntrinsicCompartment`, `quickjs.h:560-563`)
> plus one new atom (`Compartment`, `quickjs-atom.h:267`). The defining
> characteristic for anyone reading this as a model: it realizes SES's
> *immutability* half (deep-freeze + frozen intrinsics) but **not** its
> *taming* half (no permits whitelist, no intrinsic removal/repair, no
> determinism scrub, no `eval`/`Function`/`Error` taming). It is the fast,
> simple, security-incomplete half of SES.

## What "native SES" means here

Standard SES (the `ses` npm shim) does `lockdown()` by walking a large
*permits* whitelist (`permits.js`) that enumerates every allowed intrinsic
property: it **removes** non-permitted properties, **replaces** authority-
bearing accessors and constructors with tamed variants, scrubs
non-determinism (`Date.now`, `Math.random`), tames `Error` stack access,
and restricts `eval`/`Function` — and only then hardens (deep-freezes) the
result. The whitelist walk and the removals/replacements are the security
core; the freeze locks in the tamed result.

danfinlay's native version keeps only the freeze. There is no permits graph
in the fork. `lockdown()` force-resolves lazily-initialized intrinsics and
then deep-freezes everything reachable from the global object and the class
prototypes. It removes nothing, replaces nothing, and scrubs nothing. This
makes it small and fast, and makes it a **partial** SES: it prevents
mutation of the shared intrinsics (prototype-pollution of a frozen
`Object.prototype` throws, which the test suite checks) but it does not
close the authority and non-determinism channels that SES's permits pass
exists to close.

## The three primitives and where they attach

- **`harden(value)`** — deep-freeze a single object graph. Backed by the
  public C API `JS_DeepFreeze`. Returns the same object (identity
  preserved); passes primitives through unchanged. See
  [harden-c-deep-freeze](danfinlay-quickjs--native-ses--harden-c-deep-freeze.md).

- **`lockdown()`** — freeze all standard intrinsics of the current context.
  Backed by `JS_FreezeIntrinsics`. Leaves the global object itself
  extensible (user code can still declare new globals) but freezes every
  intrinsic on it. See
  [lockdown-freeze-intrinsics](danfinlay-quickjs--native-ses--lockdown-freeze-intrinsics.md).

- **`Compartment`** — a native class; each instance owns a fresh `JSContext`
  in the **same** `JSRuntime`, seeded with standard intrinsics only (no host
  globals like `print`/`scriptArgs`) plus `Compartment` and `lockdown` so
  nesting works. `evaluate(src)` runs strict global eval in the child
  context; `globals` endowments are copied into the child global; exceptions
  are re-thrown across the context boundary. See
  [compartment-context-model](danfinlay-quickjs--native-ses--compartment-context-model.md).

## Registration

Both intrinsic sets are added during normal context creation:

```c
// quickjs.c:2507-2518 (JS_NewContext path)
JS_AddIntrinsicBaseObjects(ctx) || ... ||
JS_AddIntrinsicCompartment(ctx) ||
JS_AddIntrinsicLockdown(ctx) || ...
```

so `harden`, `lockdown`, and `Compartment` are ambient globals in any
standard quickjs-ng context built from this fork — including inside every
compartment (`js_compartment_new_context`, `quickjs.c:60342-60344`).

## Engine posture relevant to the XS lens

quickjs-ng is a **register-based bytecode interpreter with no JIT** — the
same no-JIT posture the garden's XS direction requires. Consequently there
is no JIT-based technique in this fork to evaluate against the no-JIT
constraint; every speed win here comes from moving work out of the JS
interpreter into C, not from native code generation. The relevant
safety-cost axis is instead **memory safety**: all of this is hand-written
C using manual `JSValue` refcount management (`js_dup`/`JS_FreeValue`) and
explicit re-reads of object pointers after recursion because the heap shape
can change mid-traversal (`quickjs.c:60060-60061`). That is exactly the
class of code where a defect is a memory-safety defect — the consideration
that motivates doing the equivalent traversal in Rust (or in carefully
reviewed engine C) rather than casually, in the XS→Rust program.

Source: [quickjs.c](https://github.com/danfinlay/quickjs/blob/49dc75ede0d511ddea07236622378df7f652b65e/quickjs.c#L59935), [quickjs.h](https://github.com/danfinlay/quickjs/blob/49dc75ede0d511ddea07236622378df7f652b65e/quickjs.h#L560), [quickjs-atom.h](https://github.com/danfinlay/quickjs/blob/49dc75ede0d511ddea07236622378df7f652b65e/quickjs-atom.h#L267) at commit `49dc75e`.
