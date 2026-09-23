---
title: Body
source: packages/exo/src/exo-makers.js
source_repo: endojs/endo
source_branch: master
source_commit: e56bf00f289ff8484094b785b11636b8bc71d87e
source_date: 2025-10-09
source_authors: [Kris Kowal]
source_lines: "1-242 (full file)"
topics: [hardened-javascript, exo]
status: current
notes: |
  Sixteenth comment-fragment ingest. Kris Kowal-authored *Exo
  construction surface* — *the* file that defines `defineExoClass`,
  `defineExoClassKit`, and `makeExo`, the three factories that
  every exo-shaped capability in @endo and downstream code (Agoric,
  endo-but-for-bots daemon designs, etc.) uses. Three structurally
  interesting moves: (1) the *callback-options hooks* pattern
  (`finish` / `receiveAmplifier` / `receiveInstanceTester`) that
  pass *privileged capability-references back to the host* — the
  host calls `defineExoClass` and gets back the *public* maker
  function, but additionally receives the *host-only* facets
  (amplifier, instance-tester) via callback options; (2) the
  *state-sealed-not-frozen* discipline — *Be careful not to freeze
  the state record* (twice repeated) — state must remain mutable
  for the exo class's methods to update it, but sealing prevents
  shape changes; context wrapping is frozen *after* the state and
  facets are attached; (3) the *class-vs-kit symmetry* —
  defineExoClass and defineExoClassKit follow the same shape but
  with single-context vs per-facet-context-map; the kit form
  uniquely supports *amplification* (going from one facet to all
  sibling facets via receiveAmplifier). Single-section cohesion-
  honest ingest. Complements:
  - the @endo/patterns cycles (102 checkKey + 104 compareKeys),
    since exo's method guards use the patterns language defined
    there;
  - the daemon design cycles (101 commands + 103 value + 105
    capability-bank + 107 agent-tools), since all daemon
    capabilities are exo-shaped — the Dir/Shell/Git capabilities
    from cycle 107 are concrete consumers of this file's
    `defineExoClass` / `makeExo` factories.
  
  Cycle 108 papers-lane pivot to comments-lane (sixth consecutive
  papers-lane block, cycles 97/100/102/104/106/108).
parent: endo--packages-exo-src-exo-makers-js--defineExoClass-defineExoClassKit-and-makeExo-factory-trio
---

### §The LABEL_INSTANCES debug knob

The §lines 14-15:

```js
// Turn on to give each exo instance its own toStringTag value.
const LABEL_INSTANCES = environmentOptionsListHas('DEBUG', 'label-instances');
```

The §env-option-driven debug flag. When `DEBUG=label-instances` is set in the environment, each created exo instance gets a per-instance `Symbol.toStringTag` like `Tag#3` (constructed in `makeSelf`). Otherwise, instances share the prototype's toStringTag (`Tag` without the `#N` suffix).

The §discipline: *production runs use the prototype's tag*; *debug runs label individual instances*. The labels make logs more diagnostic when many instances of the same class exist (each one is uniquely identifiable). The cost: a per-instance `defineProperty` call.

The §`environmentOptionsListHas` is the SES-discipline for env-driven feature flags — it checks `globalThis.process.env.DEBUG` (or equivalent) and parses the comma-separated list for the named flag. The §pattern is reusable for any *opt-in-debug-feature* in @endo packages.

### §The makeSelf helper

The §lines 17-34:

```js
const makeSelf = (proto, instanceCount) => {
  const self = create(proto);
  if (LABEL_INSTANCES) {
    defineProperty(self, Symbol.toStringTag, {
      value: `${proto[Symbol.toStringTag]}#${instanceCount}`,
      writable: false,
      enumerable: false,
      configurable: false,
    });
  }
  return harden(self);
};
```

The §three-step construction:

1. **`create(proto)`** — produce a fresh object whose `[[Prototype]]` is the guarded prototype. The new self-object inherits the methods but has no own properties.
2. **Optional per-instance label** — if `LABEL_INSTANCES`, define a non-writable non-enumerable non-configurable own `Symbol.toStringTag` property with value `${proto[Symbol.toStringTag]}#${instanceCount}`.
3. **`harden(self)`** — freeze the object plus all its (currently-empty) reachable structure.

The §property-descriptor discipline: `writable: false`, `enumerable: false`, `configurable: false`. The label is *immutable* (can't be changed), *invisible to enumeration* (won't show up in `Object.keys(self)`), and *non-removable* (`delete self[Symbol.toStringTag]` is a no-op in strict mode). The §three-false discipline matches the standard SES *frozen value* shape.

The §`harden(self)` call freezes the self at construction time. Subsequent code (the state record, the context wrapper) stays mutable until explicit freeze. The §discipline: *the self is hardened the moment it's constructed*; the state and context follow different lifecycle rules.

### §The initEmpty convenience

The §lines 36-46:

```js
const emptyRecord = harden({});

export const initEmpty = () => emptyRecord;
```

The §two-line convenience. `emptyRecord` is a hardened empty record (frozen, no own properties); `initEmpty` is a function that returns it.

The §JSDoc reasoning (lines 39-45):

> When calling `defineDurableKind` and its siblings, used as the `init` function argument to indicate that the state record of the (virtual/durable) instances of the kind/exoClass should be empty, and that the returned maker function should have zero parameters.

The §discipline: *some exo classes have no state*. The `init` parameter to `defineExoClass` is normally a function that takes user-arguments and returns the initial state record. For a stateless class, the maintainer passes `initEmpty` (which ignores arguments and returns the empty record). This:

- Makes the *zero-state-zero-arg* case explicit and uniform.
- Lets the maker function have *zero parameters*: `const myMaker = defineExoClass('Tag', guard, initEmpty, methods); const myInstance = myMaker();`
- Reuses the same shared `emptyRecord` across all stateless classes (one hardened object; no per-class allocation).

### §The defineExoClass factory

The §`defineExoClass` factory (lines 48-118) is the centerpiece of the file. Five parameters: `tag` (string identifier), `interfaceGuard` (optional `M.interface()` shape), `init` (function returning the initial state), `methods` (method dictionary), `options` (optional callback hooks).

The §opening lines (65-72):

```js
harden(methods);
const {
  finish = undefined,
  receiveAmplifier = undefined,
  receiveInstanceTester = undefined,
} = options;
receiveAmplifier === undefined ||
  Fail`Only facets of an exo class kit can be amplified ${q(tag)}`;
```

The §three structural steps:

1. **`harden(methods)`** — methods dictionary frozen immediately. After this, the maintainer cannot add or remove methods.
2. **Destructure options** into the three callback hooks.
3. **Reject `receiveAmplifier`** for non-kit classes. Amplification is a *facet-to-other-facets* operation; a single-facet class has no other facets to amplify to. Fail-loud with explicit error message.

The §contextMap + prototype construction (lines 74-82):

```js
const contextMap = new WeakMap();
const proto = defendPrototype(
  tag,
  self => contextMap.get(self),
  methods,
  true,
  interfaceGuard,
);
```

The §`WeakMap<self, context>` is the *instance-bookkeeping* — keyed by the self-object (the user-visible reference), valued by the `context` record (`{ state, self }`).

The §`defendPrototype(tag, getContext, methods, true, interfaceGuard)` from `exo-tools.js` produces the *guarded prototype*. The 5-argument shape:

- **`tag`** — the class name (used for the prototype's `Symbol.toStringTag`).
- **`getContext`** — a function that takes a `self` and returns the matching context. The prototype's method-wrappers call this to retrieve the context before invoking the user-provided method.
- **`methods`** — the user-provided method dictionary.
- **`true`** (positional — likely the *thisful* flag) — methods receive a `context` argument that contains `{ state, self }`.
- **`interfaceGuard`** — the M.interface() shape; the prototype's method-wrappers check method calls against this guard before invocation.

The §makeInstance closure (lines 84-101):

```js
let instanceCount = 0;
const makeInstance = (...args) => {
  // Be careful not to freeze the state record
  const state = seal(init(...args));
  instanceCount += 1;
  const self = makeSelf(proto, instanceCount);

  // Be careful not to freeze the state record
  const context = freeze({ state, self });
  contextMap.set(self, context);
  if (finish) {
    finish(context);
  }
  return self;
};
```

The §five-step instance construction:

1. **`seal(init(...args))`** — produces the initial state record and *seals* it. The §comment names the discipline: *Be careful not to freeze the state record*. Sealing prevents shape changes (can't add/remove properties) but allows *value changes* — methods can update the state's values. Freezing would prevent both.
2. **`instanceCount += 1`** — bump the per-class instance counter (used for the `LABEL_INSTANCES` per-instance toStringTag).
3. **`makeSelf(proto, instanceCount)`** — produce the self-object (frozen, optionally labeled).
4. **`context = freeze({ state, self })`** — wrap the state and self into a context record and freeze the wrapper. The state and self are referenced from the context but not themselves re-frozen here. The §comment again: *Be careful not to freeze the state record*. Freezing the wrapper is *not* freezing the state.
5. **`contextMap.set(self, context)` + optional `finish(context)` + return `self`** — register the self↔context mapping; optionally invoke the host's finish-callback; return the self to the caller.

The §receiveInstanceTester branch (lines 103-114):

```js
if (receiveInstanceTester) {
  const isInstance = (exo, facetName = undefined) => {
    facetName === undefined ||
      Fail`facetName can only be used with an exo class kit: ${q(tag)} has no facet ${q(facetName)}`;
    return contextMap.has(exo);
  };
  harden(isInstance);
  receiveInstanceTester(isInstance);
}
```

The §`isInstance` test:

- **`facetName === undefined ||` short-circuit** — if the caller passed a `facetName`, fail with *facetName can only be used with an exo class kit*. Single-facet classes don't have named facets.
- **`contextMap.has(exo)` test** — checks if the exo is an instance of *this class* (was constructed via this maker).

The §`receiveInstanceTester` pattern: the host calls `defineExoClass` and provides `options.receiveInstanceTester` (a callback). The factory builds the `isInstance` function and passes it back to the host *via the callback*. The host now holds the privileged capability to test exo instances *of this class*; the public maker function doesn't expose this test.

### §The callback-options-hooks pattern

The §three callback hooks (`finish` / `receiveAmplifier` / `receiveInstanceTester`) are structurally important. Each is a *capability-grant-via-callback* mechanism.

The §host's perspective:

```js
let isInstanceTester;
let amplifier;
const makeFoo = defineExoClassKit('Foo', guardKit, init, methodsKit, {
  finish: ctx => { /* ... */ },
  receiveAmplifier: fn => { amplifier = fn; },
  receiveInstanceTester: fn => { isInstanceTester = fn; },
});

// Now the host holds three things:
// - makeFoo (the public maker function)
// - amplifier (the private facet-to-siblings amplifier)
// - isInstanceTester (the private instance-tester)
```

The §discipline: *the maker function is the public surface; the amplifier and instance-tester are privileged*. The host receives them via callback so they can never leak outside the host's scope. The §pattern is reusable for any *factory-that-grants-public-and-private-references*.

The §`finish(context)` is a *per-instance* hook (called after each instance is constructed). The §use case: the host wants to perform additional setup on each new instance (e.g., register it in a directory, log it, attach observability). The hook receives the full context (`{ state, self }`) so the host can access the state if needed.

The §`receiveAmplifier` is *class-kit-only* (rejected for non-kit classes). It's a *one-shot* callback called at class-definition time (not per-instance).

The §`receiveInstanceTester` is similar — *one-shot* at class-definition time. The host receives the isInstance function once.

### §The defineExoClassKit factory

The §`defineExoClassKit` (lines 120-218) parallels `defineExoClass` for the *multi-facet* case. The §five parameters mirror: `tag`, `interfaceGuardKit` (a record of per-facet interface guards), `init`, `methodsKit` (a record of per-facet method dictionaries), `options`.

The §key differences:

- **`contextMapKit = objectMap(methodsKit, () => new WeakMap())`** — one WeakMap per facet, since each facet has its own self-object.
- **`getContextKit = objectMap(contextMapKit, contextMap => facet => contextMap.get(facet))`** — one context-lookup function per facet.
- **`prototypeKit = defendPrototypeKit(...)`** — one prototype per facet.

The §makeInstanceKit (lines 158-181):

```js
let instanceCount = 0;
const makeInstanceKit = (...args) => {
  // Be careful not to freeze the state record
  const state = seal(init(...args));
  // Don't freeze context until we add facets
  const context = { state, facets: null };
  instanceCount += 1;
  const facets = objectMap(prototypeKit, (proto, facetName) => {
    const self = makeSelf(proto, instanceCount);
    contextMapKit[facetName].set(self, context);
    return self;
  });
  context.facets = facets;
  // Be careful not to freeze the state record
  freeze(context);
  if (finish) {
    finish(context);
  }
  return context.facets;
};
```

The §differences from `defineExoClass`'s makeInstance:

- **Context construction is two-phase** — first `context = { state, facets: null }` (mutable, allows late attachment); then `context.facets = facets` after all facets are built; then `freeze(context)`. The §comment: *Don't freeze context until we add facets*.
- **Facets are built atomically via `objectMap(prototypeKit, (proto, facetName) => makeSelf...)`** — for each facet name, build the self and register it in the per-facet contextMap (sharing the same context).
- **All facets share the same context** — they all see the same `state` and the same `facets` record. The §discipline lets *facets call each other through the context*.
- **Returns `context.facets`** — the record of all facets (instead of a single self).

### §The amplification mechanism

The §`amplify(exoFacet)` (lines 183-195):

```js
if (receiveAmplifier) {
  const amplify = exoFacet => {
    for (const contextMap of values(contextMapKit)) {
      if (contextMap.has(exoFacet)) {
        const { facets } = contextMap.get(exoFacet);
        return facets;
      }
    }
    throw Fail`Must be a facet of ${q(tag)}: ${exoFacet}`;
  };
  harden(amplify);
  receiveAmplifier(amplify);
}
```

The §`amplify` walks all per-facet contextMaps:

1. **Iterate `values(contextMapKit)`** — each entry is a per-facet WeakMap.
2. **Check `contextMap.has(exoFacet)`** — does this WeakMap recognize the input as one of its facets?
3. **If yes** — get the context, extract `facets` (all sibling facets), return.
4. **If no match found** — throw with *Must be a facet of `tag`* error.

The §discipline: *amplification is the privileged ability to go from one facet to all sibling facets*. The public exo-class user holds only the facet they were given; the host (who holds the amplifier) can *expand* a single facet to the whole sibling-facet record.

The §canonical use case: the *Caretaker* pattern. The user holds a *read-only* facet; the host holds the *control* facet plus the *amplifier*. The host can use amplification to go from the user-facing read-only facet to the control facet (e.g., to revoke).

The §`receiveAmplifier` callback grants the amplifier to the host *one-shot*; the host stores it for later use.

### §The makeExo singleton convenience

The §`makeExo` (lines 220-242):

```js
export const makeExo = (tag, interfaceGuard, methods, options = undefined) => {
  const makeInstance = defineExoClass(
    tag,
    interfaceGuard,
    initEmpty,
    methods,
    options,
  );
  return makeInstance();
};
```

The §two-step convenience:

1. **`defineExoClass` with `initEmpty`** — produces a maker function that takes zero arguments (because `initEmpty` ignores its arguments).
2. **Invoke the maker immediately** — produces the singleton instance.

The §JSDoc:

> Return a singleton instance of an internal ExoClass with no state fields.

The §use case: *internal* exos that need the method-dispatch + interface-guard machinery but don't need state. Common for module-internal helpers that want type-safe method calls.

The §`CAVEAT: static typing does not yet support callWhen transformation` (line 227) is an honest TypeScript limitation note — the static types don't fully cover the `callWhen` (eventual-send) transformation that `M.interface()` guards can apply.

### §The state-sealed-not-frozen invariant

The §invariant repeated twice in the file (lines 88-89 and 174-175):

> Be careful not to freeze the state record

The §discipline operationalized:

- **State is `seal(...)`-ed**, not `harden(...)`-ed or `freeze(...)`-ed.
- **`seal`** prevents shape changes (can't add or remove properties) but allows value changes (existing properties can be reassigned).
- **`freeze`** prevents both shape changes and value changes.
- **`harden`** is `freeze` plus transitively-freeze-all-reachable.

The §rationale: methods on the exo class need to *mutate the state's values* (e.g., increment a counter, change a status). The state's *shape* must not change (so the JIT can optimize property access; so the maintainer's mental model holds). The state's *values* must remain mutable.

The §context wrapping freezes (`freeze({state, self})` for classes; `freeze(context)` for kits *after* facets are attached). The wrapper is frozen; the wrapped state remains sealed-but-not-frozen.

The §two-comment-repetition is *intentional* — the discipline is easy to violate (a careless maintainer might `harden(context)` thinking it's safer, breaking all state-updating methods). The repeated comment serves as a visible reminder.
