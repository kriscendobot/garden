---
title: See also
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

- [[hardened-javascript]] (topic) — the SES substrate.
- [[exo]] (topic) — the Exo class-API for capability-bearing objects.
- `endo--packages-exo-src-exo-tools-js--method-defense-with-raw-guards-and-async-await-handling` — the previous section: the method-defense layer (sync + async + raw-guard handling) that this section's `defendPrototype` calls into per-method.
- `endo--packages-exo-src-exo-makers-js--defineExoClass-defineExoClassKit-and-makeExo-factory-trio` (cycle 108) — imports `defendPrototype` + `defendPrototypeKit` from this file; the user-facing factories that consume the prototype-building layer.
- `endo--packages-patterns-src-keys-checkKey-js--*` (cycle 102) — provides `M.interface()` + `getInterfaceGuardPayload` + `getCopyMapEntries` consumed here.
- `endo--packages-patterns-src-keys-copybag-js--*` (cycle 115) — provides CopyMap shape used for `symbolMethodGuards`.
