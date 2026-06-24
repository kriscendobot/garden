---
title: Body
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
parent: endo--packages-exo-src-exo-tools-js--defendPrototype-and-defendPrototypeKit-with-interface-guard-validation
---

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
