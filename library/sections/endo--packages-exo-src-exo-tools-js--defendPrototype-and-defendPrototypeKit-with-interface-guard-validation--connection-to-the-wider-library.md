---
title: Connection to the wider library
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
