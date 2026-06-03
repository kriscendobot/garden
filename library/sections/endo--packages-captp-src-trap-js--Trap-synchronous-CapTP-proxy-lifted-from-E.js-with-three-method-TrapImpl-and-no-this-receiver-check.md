---
section: Trap-synchronous-CapTP-proxy-lifted-from-E.js-with-three-method-TrapImpl-and-no-this-receiver-check
source: endo--packages-captp-src-trap-js
topics: [captp, eventual-send, hardened-javascript]
status: current
---

# `Trap` — synchronous CapTP proxy lifted from `E.js` with three-method TrapImpl and no `this`-receiver check

> *Lifted mostly from `@endo/eventual-send/src/E.js`.*
>
> — `packages/captp/src/trap.js` line 1

`trap.js` (105 lines) is the **synchronous-CapTP proxy
surface**, a sibling to cycle 146's `eventual-send/src/E.js`.
The file's *one-line opening comment* declares its derivation:
*Lifted mostly from `@endo/eventual-send/src/E.js`*. Last
touched 2025-10-09 by Kris Kowal in cycle 108's coordinated-
update commit `e56bf00f` (the @endo/harden migration that
touched many @endo files).

This file is the §synchronous-counterpart-to-eventual-send.
Where cycle 146's `E(x).method()` returns a *promise* that
settles in some future turn, `Trap(x).method()` *blocks* the
current turn until the remote returns — implemented via
SharedArrayBuffer + Atomics.wait under the hood (the related
`atomics.js` file in the same package).

## The §load-bearing-relationship — §lifted-from-E.js

The §single-line-opening-comment is the most structurally
load-bearing acknowledgment in the file. It declares:

- *Where* the code came from (`E.js`).
- *That* it's a derivation, not an independent design.
- *Implicitly* that readers should understand `E.js` first to
  understand this file's structure.

The §lifted-from-X-comment discipline names the relationship
*at the file's top*, before any code. Future readers see the
provenance immediately; future changes to `E.js` are an
expected source of changes to this file.

The §shared-shape-different-semantics observation: this file
*mirrors* `E.js`'s structure (Proxy handler trio, freezable-
not-hardened targets, computed-property-key-arrow returning
method dispatch) *but* swaps eventual-send semantics for
synchronous-blocking semantics. Same lattice, different
operator.

## The §three-method-TrapImpl interface — narrower than E.js's six-method API

```js
export const nearTrapImpl = harden({
  applyFunction(target, args) { return target(...args); },
  applyMethod(target, prop, args) { return target[prop](...args); },
  get(target, prop) { return target[prop]; },
});
```

§TrapImpl has **three methods**:

| Method | Used by | What it does |
|--------|---------|-------------|
| `applyFunction(target, args)` | `Trap(x)(...args)` | Sync function call |
| `applyMethod(target, prop, args)` | `Trap(x).method(...args)` | Sync method call |
| `get(target, prop)` | `Trap.get(x).prop` | Sync property read |

§Three-methods-not-six: cycle 146's `E.js` exposes E(x) /
E.sendOnly(x) / E.get(x) / E.resolve(x) / E.when(x) — five
surfaces. Trap has *three*. No SendOnly (synchronous calls
don't need fire-and-forget); no resolve (synchronous calls
return values directly); no when (no promise chain).

The §narrowed-API-for-narrower-semantics observation: each
removed method was *promise-related*. Trap's whole point is
*no promises*; the API shape reflects that.

## The §single most structurally interesting move — §no-`this`-receiver-check

Cycle 146's E.js implements the §this-receiver-check via
concise-method-syntax discipline: the dispatched function
rejects with *Unexpected receiver* if `this !== receiver`,
preventing method-detach attacks.

**Trap.js does NOT do this**:

```js
get(_target, p, _receiver) {
  return (...args) => trapImpl.applyMethod(x, p, args);
}
```

The returned function is an *arrow function* — *no `this`*.
Arrow functions take their `this` from the enclosing scope
(unused here), so detaching via `const m = Trap(x).method;
m(...args)` *works the same way as calling it directly*. The
detach-attack vector doesn't exist because the function
doesn't depend on `this`.

The §why-no-receiver-check-here observation:

- **`E.js`** returns a function that *closes over* `recipient`
  and *also* needs `this` to be the proxy (because the
  generated function does dispatch via `HandledPromise.applyMethod`
  but also needs to know the proxy's identity for breakpoint
  match). Method detach corrupts the dispatch logic.
- **`trap.js`** returns an arrow function that *closes over
  both* `x` and `p` and *only* calls `trapImpl.applyMethod(x,
  p, args)`. There's no `this`-dependent logic. Detaching is
  harmless.

The §arrow-function-is-already-detach-safe property emerges
*for free* from the closure semantics. No defensive code
needed.

## The §`baseFreezableProxyHandler` mirror

```js
const baseFreezableProxyHandler = {
  set(_target, _prop, _value) { return false; },
  isExtensible(_target) { return false; },
  setPrototypeOf(_target, _value) { return false; },
  deleteProperty(_target, _prop) { return false; },
};
```

**Identical** to cycle 146's E.js. The §four-meta-traps-
return-false discipline carries over: `set` / `isExtensible`
/ `setPrototypeOf` / `deleteProperty` all return `false` (the
*correct* Proxy-meta-trap signal for "no", preserving strict-
mode invariants without throwing).

The §code-reuse-via-duplication discipline (not via shared
import): both files inline the same `baseFreezableProxyHandler`
object literally. Cross-package shared-helpers would create
a dependency between `@endo/captp` and `@endo/eventual-send`
that doesn't otherwise exist; the §duplicate-don't-import
discipline preserves package independence.

## The §funcTarget + objTarget — same freeze-not-harden discipline

```js
const funcTarget = freeze(() => {});
const objTarget = freeze({ __proto__: null });
```

**Identical** to cycle 146's E.js. The §freeze-not-harden
discipline + the §preparing-for-stabilize.md doc-link comment.

Both files contain *the same JSDoc comment* word-for-word:

> *`freeze` but not `harden` the proxy target so it remains
> trapping. Thus, it should not be shared outside this module.*
>
> *See https://github.com/endojs/endo/blob/master/packages/ses/docs/preparing-for-stabilize.md*

The §verbatim-comment-shared-across-derived-files pattern: the
comment travels with the code. When *either* file's code
changes, the comment moves with it. The §rationale-is-load-
bearing observation.

## The §nearTrapImpl default — §local-fast-path

```js
export const nearTrapImpl = harden({
  applyFunction(target, args) { return target(...args); },
  applyMethod(target, prop, args) { return target[prop](...args); },
  get(target, prop) { return target[prop]; },
});
```

The §nearTrapImpl is the *trivial implementation* that
dispatches *locally* to the target. For local-object usage,
`Trap(x).method(...args)` reduces to `x.method(...args)` — no
overhead, no atomics, just direct method dispatch.

The §local-fast-path-via-trivial-impl discipline lets the same
`Trap(x)` surface work in *both* near and far cases. The
caller doesn't change; only the *injected `trapImpl`* differs.
Cycle 119's daemon-capability-bus carries a related §pattern
where same envelope-protocol verbs work whether the handler
is in the same process or across the bus.

The §three-line-implementations: each method body is one line.
The §minimal-trampoline form makes it obvious the overhead is
zero.

## The §makeTrap factory — same §callable-with-methods discipline

```js
export const makeTrap = trapImpl => {
  const Trap = x => {
    const handler = TrapProxyHandler(x, trapImpl);
    return new Proxy(funcTarget, handler);
  };

  const makeTrapGetterProxy = x => { ... };
  Trap.get = makeTrapGetterProxy;

  return harden(Trap);
};
```

The §callable-with-methods discipline (parallel to E.js's
makeE): `Trap` is both a function *and* an object with a
`.get` method. Implementation differs from E.js in two ways:

1. **Property assignment, not `Object.assign`** —
   `Trap.get = makeTrapGetterProxy` directly (vs E.js's
   `harden(assign(fn, { get, resolve, sendOnly, when }))`).
2. **Two surfaces, not five** — only `Trap` (apply) and
   `Trap.get` (property read).

The §simpler-shape-because-fewer-methods observation: with
only one extra method, direct assignment is fine; with five,
`Object.assign` is cleaner.

§Final `harden(Trap)` makes the whole structure immutable
after construction. (E.js wraps the assign-result in `harden`;
same effect.)

## The §`has`-trap with §honest-TODO

```js
has(_target, _p) {
  // TODO: has property is not yet transferrable over captp.
  return true;
}
```

Both `TrapProxyHandler` and `makeTrapGetterProxy` have this
identical `has` trap with the identical TODO comment.

The §has-property-not-yet-transferrable-over-captp
acknowledgment: the `in` operator (`'foo' in Trap(x)`) cannot
*currently* be implemented over the CapTP wire because there's
no wire-level "has" message. The trap returns `true`
unconditionally — same as E.js, but with a TODO marker
because *for synchronous calls, accurate `has` would be
implementable* (unlike E.js where async-`has` is
semantically tricky).

The §honest-acknowledgment-of-API-gap discipline. The TODO is
*specific* (cite the missing feature) and *bounded* (says
exactly what would unblock the fix).

## The §sibling-files-completing-the-CapTP-surface

The relationship to cycle 146:

| Property | `E.js` (cycle 146) | `trap.js` (this file) |
|----------|-------------------|----------------------|
| Semantics | Eventual (returns promise) | Synchronous (blocks current turn) |
| Underlying mechanism | HandledPromise dispatch | Atomics.wait + SharedArrayBuffer |
| API surfaces | 5 (E + E.get + E.resolve + E.sendOnly + E.when) | 2 (Trap + Trap.get) |
| Receiver-check | Yes (cycle 146's §this-receiver-check) | No (arrow functions are detach-safe by construction) |
| Method dispatch shape | Concise-method-syntax + computed property | Arrow function returning `trapImpl.applyMethod(x, p, args)` |
| `has` trap | Returns true (no TODO) | Returns true *with TODO about wire transferrability* |
| TrapImpl/Handler injection | HandledPromise constructor | `trapImpl` parameter to `makeTrap` |

The §two-files-one-CapTP-experience observation: together
these files describe the full CapTP application interface.
The captp.js file (the wire protocol) sits below them; both
operate on the same captp slot tables but expose different
*caller-facing* semantics.

## How this file fits the broader @endo/captp + @endo/eventual-send picture

- **Cycle 146** (`E.js`) provides the *eventual* user-facing
  surface. This file is the *synchronous* mirror.
- **`captp.js`** (1012 lines, not yet ingested) — the wire
  protocol below both.
- **`atomics.js`** (170 lines, not yet ingested) — the
  SharedArrayBuffer + Atomics.wait substrate for synchronous
  CapTP. Without that substrate, `Trap` can't block.
- **`loopback.js`** (117 lines, not yet ingested) — the
  in-process CapTP connection used for testing/dev.

The §captp-cluster-mapping: 6 substantial source files in
`@endo/captp`; this is the *first* ingested. The other
captp.* files remain candidates for future cycles.

## Related sections

- cycle 146
  [[endo--packages-eventual-send-src-E-js--E-proxy-handler-trio-with-this-receiver-check-and-freezable-not-hardened-proxy-targets]]
  — the *eventual-send* mirror that this file is lifted from.
  Same baseFreezableProxyHandler / funcTarget / objTarget;
  different dispatch shape (concise-method-syntax-with-this-
  check vs arrow-function).
- cycle 66
  [[endo--packages-eventual-send-src-handled-promise-js--handler-protocol]]
  — the HandledPromise dispatch protocol that E.js routes
  through. Trap routes through a different channel
  (Atomics-based).
- cycle 108
  [[endo--packages-exo-src-exo-makers-js--defineExoClass-defineExoClassKit-and-makeExo-factory-trio]]
  — same coordinated-update commit `e56bf00f` (@endo/harden
  migration). The cluster grows to 16 files.
- cycle 119
  [[endo-but-for-bots--llm-designs-daemon-capability-bus--daemon-as-message-router-with-envelope-protocol-and-handle-rewriting]]
  — the daemon-side §pattern of *same envelope verbs whether
  in-process or cross-process*, which this file's §local-
  fast-path-via-trivial-impl mirrors at the user-facing
  proxy layer.
