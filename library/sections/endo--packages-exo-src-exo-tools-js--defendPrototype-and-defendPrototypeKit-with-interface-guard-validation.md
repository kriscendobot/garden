---
title: The §`defendPrototype(tag, contextProvider, behaviorMethods, thisfulMethods?, interfaceGuard?)` public factory — the file's *primary export* that cycle 108's exo-makers.js imports; the §method-name discovery via `getRemotableMethodNames(behaviorMethods)` with the §`constructor` filter (ignore method-named *constructor* unless `constructor.prototype.constructor !== constructor` — *By ignoring any method that seems to be a constructor, we can use a class.prototype as a behaviorMethods*); the §interface-guard validation — extracts `interfaceName`/`methodGuards`/`symbolMethodGuards`/`sloppy`/`defaultGuards` via `getInterfaceGuardPayload`; merges `symbolMethodGuards` via `fromEntries(getCopyMapEntries(...))`; the §`defaultGuards: dg = sloppy ? 'passable' : undefined` deprecated `sloppy` flag handled as alias for `defaultGuards: 'passable'`; the §two complementary listDifference checks — *methods X not implemented by tag* (interface declares methods the behavior doesn't have) and *methods X not guarded by interfaceName* (behavior has methods the interface doesn't declare; only enforced when `defaultGuards` is undefined); the §per-method wrapping in the iteration — `thisfulMethods ? originalMethod : shiftedMethod` where `shiftedMethod(...args) { return originalMethod(this, ...args) }` adapts behavior-methods-as-first-arg to behavior-methods-as-this for the non-thisful case (allowing `behaviorMethods = { method: (state, ...args) => ... }` style); the §defaultGuards-resolution per-method — `undefined` falls back to `PassableMethodGuard` for thisful or `RawMethodGuard` for non-thisful; `'passable'` → `PassableMethodGuard`; `'raw'` → `RawMethodGuard`; the §`GET_INTERFACE_GUARD` symbol auto-installation if not already present — the runtime-introspection method that returns the interfaceGuard (possibly undefined); wrapped via `bindMethod` with `PassableMethodGuard`; the §`Far(tag, prototype)` final wrapping produces the user-visible prototype; the §`defendPrototypeKit(tag, contextProviderKit, behaviorMethodsKit, thisfulMethods?, interfaceGuardKit?)` multi-facet factory — sorts facet names; rejects single-facet kits (`A multi-facet object must have multiple facets`); cross-checks facet-names against interface-guard-names and context-provider-names (extras in either direction throw); delegates to `defendPrototype` per facet with `${tag} ${facetName}` as the per-facet tag
source: packages/exo/src/exo-tools.js
source_repo: endojs/endo
source_branch: master
source_commit: e56bf00f289ff8484094b785b11636b8bc71d87e
source_date: 2025-10-09
source_authors: [Kris Kowal]
source_lines: "348-513 (defendPrototype + defendPrototypeKit)"
topics: [hardened-javascript, exo]
status: current
notes: |
  Section 2 of cycle 118's exo-tools.js ingest (sister to section 1
  which covers the method-defense layer). This section captures
  the *prototype-building* layer — the two public exports
  `defendPrototype` and `defendPrototypeKit` that cycle 108's
  exo-makers.js imports and consumes.
  
  Three structurally interesting moves in section 2: (1) the
  *behavior-methods-as-first-arg-vs-as-this* dual mode via the
  `thisfulMethods` flag — non-thisful mode wraps each behavior
  method in a `shiftedMethod(...args) { return originalMethod(this,
  ...args) }` adapter so the user can write methods that take
  state as the first arg explicitly; (2) the *symmetric
  listDifference validation* for interface guards — *methods X
  not implemented by tag* (interface declares methods behavior
  doesn't have) + *methods X not guarded by interfaceName*
  (behavior has methods interface doesn't declare; only enforced
  when defaultGuards is undefined); (3) the *GET_INTERFACE_GUARD
  auto-installation* — the runtime-introspection method gets
  added to every prototype that doesn't already have it; this is
  how downstream code (the introspection API for exo classes)
  queries the interface guard at runtime.
  
  Plus the *constructor-filter discipline* — *By ignoring any
  method that seems to be a constructor, we can use a
  class.prototype as a behaviorMethods* — lets the user pass a
  JavaScript class.prototype directly as the behavior-methods
  object. And the *deprecated-sloppy-flag handling* — `sloppy:
  true` is aliased to `defaultGuards: 'passable'` for backward
  compatibility.
---

## Abstract

The §`defendPrototype(tag, contextProvider, behaviorMethods, thisfulMethods?, interfaceGuard?)` (lines 348-468) is the file's primary export — the file that cycle 108's exo-makers.js imports as `defendPrototype` and consumes in `defineExoClass`. The §method discovery (lines 364-377) uses `getRemotableMethodNames(behaviorMethods)` filtered by *ignoring any method that seems to be a constructor* — *By ignoring any method that seems to be a constructor, we can use a `class.prototype` as a behaviorMethods*. The §filter logic: only ignore `key === 'constructor'` if `behaviorMethods.constructor` is *itself a class constructor* (i.e., `constructor.prototype.constructor === constructor`). This lets the user pass a JavaScript class's `.prototype` directly as the behavior-methods.

The §interface-guard validation (lines 378-407) extracts five fields from the interface guard via `getInterfaceGuardPayload`: `interfaceName`, `methodGuards`, `symbolMethodGuards`, `sloppy`, `defaultGuards`. The §`defaultGuards = sloppy ? 'passable' : undefined` clause handles the deprecated `sloppy: true` flag as an alias for `defaultGuards: 'passable'`. Symbol method guards are merged in via `fromEntries(getCopyMapEntries(symbolMethodGuards))`. The §two complementary `listDifference` checks: (1) *methods X not implemented by tag* (interface declares methods that the behavior doesn't have); (2) *methods X not guarded by interfaceName* (behavior has methods the interface doesn't declare; only enforced when `defaultGuards === undefined`, since otherwise the default-guard catches them).

The §per-method wrapping loop (lines 409-449) walks each method name and:

1. **Picks the right callable** — `thisfulMethods ? originalMethod : shiftedMethod`. The §`shiftedMethod(...args) { return originalMethod(this, ...args) }` adapter wraps the original to *put `this` as the first arg* — supporting the non-thisful style where users write `behaviorMethods = { method: (state, ...args) => ... }`.
2. **Picks the right method-guard** — explicit `methodGuards[prop]` if present; else fall back per `defaultGuards`: `undefined` → `PassableMethodGuard` for thisful or `RawMethodGuard` for non-thisful; `'passable'` → `PassableMethodGuard`; `'raw'` → `RawMethodGuard`; unknown → `Fail`.
3. **Wraps via `bindMethod`** — produces the defended method with `name = "In <prop> method of (<tag>)"`.
4. **Stores on prototype** — `prototype[prop] = defended-method`.

The §`GET_INTERFACE_GUARD` symbol auto-installation (lines 451-464) — if the prototype doesn't already have `GET_INTERFACE_GUARD`, the factory adds a method that returns the (possibly undefined) `interfaceGuard`. The method is wrapped via `bindMethod` with `PassableMethodGuard`. The §discipline: *every exo instance has a runtime-introspection point for its interface guard*.

The §final wrapping (line 466) — `Far(tag, prototype)` produces the user-visible prototype with the tag as `Symbol.toStringTag`.

The §`defendPrototypeKit(tag, contextProviderKit, behaviorMethodsKit, thisfulMethods?, interfaceGuardKit?)` (lines 478-513) is the multi-facet variant:

- **Sort facet names** — `ownKeys(behaviorMethodsKit).sort()` for stable iteration.
- **Reject single-facet kits** — *A multi-facet object must have multiple facets* (kits with one facet should use `defineExoClass` not `defineExoClassKit`).
- **Cross-check facet-names against interface-guard-names** — `listDifference` both ways; extras in either direction throw with *Interfaces X not implemented by tag* or *Facets X of tag not guarded by interfaces*.
- **Cross-check facet-names against context-provider-names** — same pattern; extras throw with *Contexts X not implemented by tag* or *Facets X of tag missing contexts*.
- **Per-facet delegation** — `objectMap(behaviorMethodsKit, (behaviorMethods, facetName) => defendPrototype('${tag} ${facetName}', contextProviderKit[facetName], behaviorMethods, thisfulMethods, interfaceGuardKit?.[facetName]))`.

## Body

### §The constructor-filter discipline

The §lines 364-377:

```js
const methodNames = getRemotableMethodNames(behaviorMethods).filter(
  // By ignoring any method that seems to be a constructor, we can use a
  // class.prototype as a behaviorMethods.
  key => {
    if (key !== 'constructor') {
      return true;
    }
    const constructor = behaviorMethods.constructor;
    return !(
      constructor.prototype &&
      constructor.prototype.constructor === constructor
    );
  },
);
```

The §design intent: *let the user pass a JavaScript class's `.prototype` directly as behavior-methods*. A class prototype has a `constructor` property pointing back to the class. The §filter:

- **If `key !== 'constructor'`** → keep it (it's a regular method).
- **If `key === 'constructor'`** → check if it *looks like a class constructor*: `constructor.prototype.constructor === constructor`. This is the *class-constructor self-reference invariant*. If true → ignore (it's a class constructor, not a method).
- **If `key === 'constructor'` but doesn't look like a class constructor** → keep it (the user explicitly named a method `constructor` for some reason).

The §discipline: *gracefully accept class prototypes without requiring the user to strip the constructor manually*. Reusable for any *behavior-spec-as-class-prototype* shape.

### §The interface-guard validation

The §lines 382-406:

```js
if (interfaceGuard) {
  const {
    interfaceName,
    methodGuards: mg,
    symbolMethodGuards,
    sloppy,
    defaultGuards: dg = sloppy ? 'passable' : undefined,
  } = getInterfaceGuardPayload(interfaceGuard);
  methodGuards = harden({
    ...mg,
    ...(symbolMethodGuards &&
      fromEntries(getCopyMapEntries(symbolMethodGuards))),
  });
  defaultGuards = dg;
  {
    const methodGuardNames = ownKeys(methodGuards);
    const unimplemented = listDifference(methodGuardNames, methodNames);
    unimplemented.length === 0 ||
      Fail`methods ${q(unimplemented)} not implemented by ${q(tag)}`;
    if (defaultGuards === undefined) {
      const unguarded = listDifference(methodNames, methodGuardNames);
      unguarded.length === 0 ||
        Fail`methods ${q(unguarded)} not guarded by ${q(interfaceName)}`;
    }
  }
}
```

The §key destructuring line:

```js
defaultGuards: dg = sloppy ? 'passable' : undefined,
```

The §deprecated `sloppy: true` is *aliased to `defaultGuards: 'passable'`*. New code uses `defaultGuards: 'passable'`; old code with `sloppy: true` continues to work.

The §symbol-method-guards merge:

```js
methodGuards = harden({
  ...mg,
  ...(symbolMethodGuards &&
    fromEntries(getCopyMapEntries(symbolMethodGuards))),
});
```

The §two-source merge: `mg` is the string-keyed method guards; `symbolMethodGuards` is a CopyMap (cycles 102 / 115) keyed by symbols. Merging produces a single record with both string keys and symbol keys.

The §**symmetric `listDifference` validation**:

- **`unimplemented = listDifference(methodGuardNames, methodNames)`** — methods the interface declares but the behavior doesn't implement. Throws *methods X not implemented by tag*.
- **`unguarded = listDifference(methodNames, methodGuardNames)`** — methods the behavior implements but the interface doesn't declare. *Only enforced when `defaultGuards === undefined`* — otherwise the default-guard catches them.

The §discipline: *interface and behavior must agree in both directions*. If the interface declares a method the behavior lacks, runtime callers would crash; if the behavior has methods the interface doesn't declare, callers can invoke unguarded methods (defeating the interface). The §`defaultGuards` escape lets the maintainer accept unguarded methods with an explicit *passable-or-raw default*.

### §The thisful-vs-shifted-method dual mode

The §lines 409-416:

```js
for (const prop of methodNames) {
  const originalMethod = behaviorMethods[prop];
  const { shiftedMethod } = {
    shiftedMethod(...args) {
      return originalMethod(this, ...args);
    },
  };
  const behaviorMethod = thisfulMethods ? originalMethod : shiftedMethod;
  // ... pick methodGuard ...
  prototype[prop] = bindMethod(
    `In ${q(prop)} method of (${tag})`,
    contextProvider,
    behaviorMethod,
    methodGuard,
  );
}
```

The §two-mode discipline:

- **`thisfulMethods === true`** — the user's behavior methods use `this` for state. Cycle 108's `defineExoClass` calls with `thisfulMethods = true`. The original method is used as-is; `this` becomes the context.
- **`thisfulMethods === false`** (default) — the user's behavior methods take *state as the first arg* explicitly. The `shiftedMethod` adapter wraps the original: `shiftedMethod(...args)` body calls `originalMethod(this, ...args)`, passing the runtime `this` (the context) as the first arg.

The §rationale: *two equally-valid style preferences*. Some users prefer `this.state.x` (thisful); others prefer explicit `(state, x) => state.x` (functional). The framework supports both via the `thisfulMethods` flag.

The §`shiftedMethod` is wrapped in a destructure-pattern (same concise-method-syntax discipline as section 1) so its `this` works correctly at call time.

### §The per-method guard resolution

The §lines 419-442:

```js
let methodGuard = methodGuards && methodGuards[prop];
if (!methodGuard) {
  switch (defaultGuards) {
    case undefined: {
      if (thisfulMethods) {
        methodGuard = PassableMethodGuard;
      } else {
        methodGuard = RawMethodGuard;
      }
      break;
    }
    case 'passable': {
      methodGuard = PassableMethodGuard;
      break;
    }
    case 'raw': {
      methodGuard = RawMethodGuard;
      break;
    }
    default: {
      throw Fail`Unrecognized defaultGuards ${q(defaultGuards)}`;
    }
  }
}
```

The §three-mode default-guard resolution:

- **Explicit `methodGuards[prop]`** — use it directly. Highest priority.
- **`defaultGuards: undefined`** (no interface guard, or explicit no-default) — *thisful → PassableMethodGuard; non-thisful → RawMethodGuard*. The §rationale: thisful style implies passable contracts (the user can't easily pass raw values via `this`); non-thisful style allows raw values via explicit first-arg.
- **`defaultGuards: 'passable'`** — `PassableMethodGuard` for all unguarded methods.
- **`defaultGuards: 'raw'`** — `RawMethodGuard` for all unguarded methods.
- **Unknown `defaultGuards`** — `Fail` with *Unrecognized defaultGuards*.

The §discipline: *the user picks the safety floor*. `'passable'` is the strict default (everything must be passable); `'raw'` is the permissive default (no validation); `undefined` falls back to per-style behavior.

### §The GET_INTERFACE_GUARD auto-installation

The §lines 451-464:

```js
if (!hasOwn(prototype, GET_INTERFACE_GUARD)) {
  const getInterfaceGuardMethod = {
    [GET_INTERFACE_GUARD]() {
      // Note: May be `undefined`
      return interfaceGuard;
    },
  }[GET_INTERFACE_GUARD];
  prototype[GET_INTERFACE_GUARD] = bindMethod(
    `In ${q(GET_INTERFACE_GUARD)} method of (${tag})`,
    contextProvider,
    getInterfaceGuardMethod,
    PassableMethodGuard,
  );
}
```

The §`GET_INTERFACE_GUARD` symbol (imported from `./get-interface.js`) is the *runtime-introspection method* for the interface guard. The §auto-installation:

- **If the prototype doesn't already have it** → add a method that returns `interfaceGuard` (which may be `undefined` if no guard was provided).
- **Computed-property-name idiom** — `{ [GET_INTERFACE_GUARD]() { ... } }[GET_INTERFACE_GUARD]` is the concise-method-syntax trick (cycle 108 + section 1's idiom) extended for symbol keys.
- **Wrapped via `bindMethod`** with `PassableMethodGuard` — even the introspection method goes through the standard defense.

The §discipline: *every exo class is introspectable for its interface guard at runtime*. Downstream code (debugging, doc generation, capability auditing) can query the guard via `obj[GET_INTERFACE_GUARD]()`.

The §`// Note: May be undefined` comment is honest about the case where no guard was provided. The introspection method *returns whatever was passed in*; callers must handle the undefined case.

### §The Far-wrapping final step

The §line 466:

```js
return Far(tag, /** @type {T & GetInterfaceGuard<T>} */ (prototype));
```

The §`Far(tag, ...)` from `@endo/pass-style` wraps the prototype with:

- **`Symbol.toStringTag` = tag** — the user-visible class name in error messages and debug output.
- **Remotable marker** — the prototype is now a *passable Far object* that can cross compartment boundaries.

The §TypeScript cast `T & GetInterfaceGuard<T>` tells the type system that the returned prototype implements both the user's behavior-method type `T` and the `GetInterfaceGuard<T>` introspection contract.

### §The defendPrototypeKit multi-facet validation

The §`defendPrototypeKit` (lines 478-513):

```js
export const defendPrototypeKit = (
  tag,
  contextProviderKit,
  behaviorMethodsKit,
  thisfulMethods = false,
  interfaceGuardKit = undefined,
) => {
  const facetNames = ownKeys(behaviorMethodsKit).sort();
  facetNames.length > 1 || Fail`A multi-facet object must have multiple facets`;
  if (interfaceGuardKit) {
    const interfaceNames = ownKeys(interfaceGuardKit);
    const extraInterfaceNames = listDifference(facetNames, interfaceNames);
    extraInterfaceNames.length === 0 ||
      Fail`Interfaces ${q(extraInterfaceNames)} not implemented by ${q(tag)}`;
    const extraFacetNames = listDifference(interfaceNames, facetNames);
    extraFacetNames.length === 0 ||
      Fail`Facets ${q(extraFacetNames)} of ${q(tag)} not guarded by interfaces`;
  }
  const contextMapNames = ownKeys(contextProviderKit);
  const extraContextNames = listDifference(facetNames, contextMapNames);
  extraContextNames.length === 0 ||
    Fail`Contexts ${q(extraContextNames)} not implemented by ${q(tag)}`;
  const extraFacetNames = listDifference(contextMapNames, facetNames);
  extraFacetNames.length === 0 ||
    Fail`Facets ${q(extraFacetNames)} of ${q(tag)} missing contexts`;
  const protoKit = objectMap(behaviorMethodsKit, (behaviorMethods, facetName) =>
    defendPrototype(
      `${tag} ${String(facetName)}`,
      contextProviderKit[facetName],
      behaviorMethods,
      thisfulMethods,
      interfaceGuardKit && interfaceGuardKit[facetName],
    ),
  );
  return protoKit;
};
```

The §five validation steps:

1. **Sort facet names** — `ownKeys(behaviorMethodsKit).sort()` produces a stable iteration order. The §discipline: *deterministic facet enumeration*.
2. **Reject single-facet kits** — *A multi-facet object must have multiple facets*. Single-facet kits should use `defineExoClass`; using `defineExoClassKit` for a single facet is *category-error*.
3. **Cross-check facet-names against interface-guard-names** (if `interfaceGuardKit` provided) — *both directions*:
   - **Extras in facets** (facets without interfaces) → *Facets X of tag not guarded by interfaces*.
   - **Extras in interfaces** (interfaces without facets) → *Interfaces X not implemented by tag*.
4. **Cross-check facet-names against context-provider-names** (always) — *both directions*:
   - **Extras in facets** → *Facets X of tag missing contexts*.
   - **Extras in contexts** → *Contexts X not implemented by tag*.
5. **Per-facet delegate to `defendPrototype`** — `objectMap` builds the prototypeKit by calling `defendPrototype` per facet. The per-facet tag is `'${tag} ${facetName}'`; the per-facet context-provider is `contextProviderKit[facetName]`; the per-facet interface-guard is `interfaceGuardKit?.[facetName]`.

The §discipline: *cross-checks are bidirectional*. A mismatch in either direction is a design error; the maintainer must declare every facet's interface and context-provider explicitly.

### §The eight-error vocabulary

The §file's `Fail` messages name eight specific errors:

| Error message | Source location | Trigger |
|---|---|---|
| `methods X not implemented by tag` | defendPrototype | interface declares methods the behavior lacks |
| `methods X not guarded by interfaceName` | defendPrototype | behavior has methods interface doesn't declare (with `defaultGuards === undefined`) |
| `Unrecognized defaultGuards X` | defendPrototype | `defaultGuards` value not in `undefined`/`passable`/`raw` |
| `A multi-facet object must have multiple facets` | defendPrototypeKit | single-facet kit |
| `Interfaces X not implemented by tag` | defendPrototypeKit | interface-guard-kit declares facets the behavior-methods-kit doesn't |
| `Facets X of tag not guarded by interfaces` | defendPrototypeKit | behavior-methods-kit has facets the interface-guard-kit doesn't declare |
| `Contexts X not implemented by tag` | defendPrototypeKit | context-provider-kit declares facets the behavior-methods-kit doesn't |
| `Facets X of tag missing contexts` | defendPrototypeKit | behavior-methods-kit has facets the context-provider-kit doesn't |

The §discipline: *each declaration kit is cross-checked against the behavior-methods kit*; mismatch in either direction throws with a specific error message. Reusable for any *multi-kit-cross-validation* situation.

## Connection to the wider library

This section is the **canonical *behavior-methods-as-class-prototype + interface-guard-bidirectional-validation + GET_INTERFACE_GUARD-introspection* worked example**. Four threads:

1. **The constructor-filter discipline** — *By ignoring any method that seems to be a constructor, we can use a `class.prototype` as a behaviorMethods*. The §pattern enables *class-syntax authoring* for exo classes.

2. **The thisful-vs-shifted-method dual mode** — `thisfulMethods` flag selects between `this`-based-state and explicit-first-arg-state styles. The §discipline: *support multiple authoring styles via runtime adaptation*.

3. **The bidirectional listDifference validation** — interface declares vs behavior implements, both ways. The §discipline: *kits must agree in both directions*; one-way checks miss design errors.

4. **The GET_INTERFACE_GUARD auto-installation** — every exo class gets a runtime-introspection point for its interface guard. Reusable for any *opt-in-auto-installed-introspection-method* shape.

The §library connections:

- **Cycle 108** `exo-makers.js` — imports `defendPrototype` and `defendPrototypeKit` from this file. `defineExoClass` calls `defendPrototype(tag, getContext, methods, true, interfaceGuard)`. `defineExoClassKit` calls `defendPrototypeKit(tag, getContextKit, methodsKit, true, interfaceGuardKit)`.
- **Cycle 102 / 104 / 110 / 115** `@endo/patterns` Keys + Collections — provide `mustMatch`, `M.interface()`, `getInterfaceGuardPayload`, `getCopyMapEntries`, `M.splitArray()` consumed here.
- **Section 1** of this cycle's ingest — the method-defense layer that `defendPrototype` calls into per-method via `bindMethod`.

The §two-section trilogy:

- **Cycle 108** `exo-makers.js` — the user-facing factories (`defineExoClass` / `defineExoClassKit` / `makeExo`).
- **Section 1** of cycle 118 — the method-defense machinery.
- **Section 2** of cycle 118 (this) — the prototype-building machinery.

Together: *the user calls `defineExoClass` → factory calls `defendPrototype` → defendPrototype iterates methods + calls `bindMethod` → bindMethod calls `defendMethod` → defendMethod dispatches to `defendSyncMethod` or `defendAsyncMethod`*. The full call-tree is now documented.

## Translation block (comment idiom → contemporary practice)

| Comment idiom | Contemporary practice |
| ------------- | --------------------- |
| `By ignoring any method that seems to be a constructor, we can use a class.prototype as a behaviorMethods` | The *gracefully-accept-class-prototypes-by-filtering-constructor* discipline. |
| `defaultGuards: dg = sloppy ? 'passable' : undefined` | The *deprecated-flag-aliased-to-new-mechanism* discipline; preserve backward-compat. |
| `methods X not implemented by tag` + `methods X not guarded by interfaceName` | The *symmetric-listDifference-validation* discipline; check both directions. |
| `shiftedMethod(...args) { return originalMethod(this, ...args) }` | The *non-thisful-to-thisful adapter* idiom; supports two authoring styles. |
| `thisful → PassableMethodGuard; non-thisful → RawMethodGuard` default | The *style-appropriate-default-guard* discipline. |
| `hasOwn(prototype, GET_INTERFACE_GUARD) ? skip : install` | The *auto-installation-if-not-already-present* discipline. |
| `[GET_INTERFACE_GUARD]() { ... }` computed-property concise method | The *concise-method-syntax-for-symbol-keys* idiom. |
| `// Note: May be `undefined`` (GET_INTERFACE_GUARD method body) | The *honest-acknowledgment-of-undefined-return* comment. |
| `Far(tag, prototype)` | The *passable-prototype-with-Symbol.toStringTag* wrapping. |
| `A multi-facet object must have multiple facets` | The *category-error-rejection* discipline; kit-vs-class distinction. |
| 4-way listDifference validation in defendPrototypeKit | The *all-four-corners* validation; facet/interface + facet/context, both directions. |
| `objectMap(behaviorMethodsKit, ...)` per-facet delegation | The *per-facet-delegate-to-single-facet-factory* pattern. |

## See also

- [[hardened-javascript]] (topic) — the SES substrate.
- [[exo]] (topic) — the Exo class-API for capability-bearing objects.
- `endo--packages-exo-src-exo-tools-js--method-defense-with-raw-guards-and-async-await-handling` — the previous section: the method-defense layer (sync + async + raw-guard handling) that this section's `defendPrototype` calls into per-method.
- `endo--packages-exo-src-exo-makers-js--defineExoClass-defineExoClassKit-and-makeExo-factory-trio` (cycle 108) — imports `defendPrototype` + `defendPrototypeKit` from this file; the user-facing factories that consume the prototype-building layer.
- `endo--packages-patterns-src-keys-checkKey-js--*` (cycle 102) — provides `M.interface()` + `getInterfaceGuardPayload` + `getCopyMapEntries` consumed here.
- `endo--packages-patterns-src-keys-copybag-js--*` (cycle 115) — provides CopyMap shape used for `symbolMethodGuards`.

## Common confusions

- **"`getRemotableMethodNames(behaviorMethods)` returns just string keys."** It returns *both string keys and symbol keys* (Remotable methods can have symbol names). The §`symbolMethodGuards` handling later in the function merges symbol-keyed guards into the same `methodGuards` record.
- **"`shiftedMethod` always wraps even when not needed."** It does — *but only when `thisfulMethods === false`*. The §`thisfulMethods ? originalMethod : shiftedMethod` selects per call site. For `defineExoClass` (which passes `thisfulMethods = true`), the wrapping never happens.
- **"The deprecated `sloppy: true` should just be removed."** It's *kept for backward compatibility*. The §`sloppy ? 'passable' : undefined` aliasing lets old code continue to work; new code uses `defaultGuards: 'passable'` directly. Removing the alias would break existing interface guards.
- **"`unguarded` check only runs when `defaultGuards === undefined` — what about `'passable'`?"** When `defaultGuards: 'passable'`, *every unguarded method gets `PassableMethodGuard` automatically*. The §discipline: no need to flag unguarded methods because the default covers them. The `'raw'` case similarly.
- **"`hasOwn(prototype, GET_INTERFACE_GUARD)` check is dead code — `prototype = {}` was just created."** It's *not always*. The §user-provided `behaviorMethods` might define `[GET_INTERFACE_GUARD]` explicitly; in that case, the loop adds it from behaviorMethods, and the `hasOwn` check skips the auto-install. The §discipline: *don't override user intent*.
- **"`Far(tag, prototype)` is just adding a toStringTag — why not `Object.defineProperty`?"** `Far` is *the canonical passable-marker*. It does more than just set toStringTag — it ensures the object satisfies pass-style's *remotable* requirements (frozen + no own data properties + correct prototype structure). Using `Object.defineProperty` would be insufficient.
- **"Why `ownKeys(behaviorMethodsKit).sort()` instead of `Object.keys(...).sort()`?"** `ownKeys` includes *symbol keys*; `Object.keys` doesn't. The §discipline: kit facets can be symbol-keyed; the iteration must include them.
- **"`A multi-facet object must have multiple facets` is tautological."** It's *intentional rejection of the single-facet-kit category error*. A user with one facet should use `defineExoClass`; using `defineExoClassKit` for one facet would create a kit-shape (record-of-facets) where a class-shape (single object) is more appropriate. The §discipline: *fail-fast on category errors*.
- **"`objectMap(behaviorMethodsKit, (behaviorMethods, facetName) => defendPrototype(...))` produces a record of facets — but each facet has its own context."** Each facet's `contextProviderKit[facetName]` resolves to *the same shared context object* (the kit's single context with multiple facets). The §discipline: *facets share the context; each gets its own self-reference via the facet name*.
- **"Section 1's `defendMethod` could just inline the dispatch — why a separate function?"** Symmetry. `defendMethod` is the *callKind dispatcher*; `defendSyncMethod` and `defendAsyncMethod` are the *per-kind implementations*. Separating the dispatcher makes each piece testable and replaceable. The §discipline: *one-concern-per-function*.
