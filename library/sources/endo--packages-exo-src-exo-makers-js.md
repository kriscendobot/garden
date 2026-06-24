---
source: packages/exo/src/exo-makers.js
source_repo: endojs/endo
source_branch: master
source_commit: e56bf00f289ff8484094b785b11636b8bc71d87e
source_date: 2025-10-09
source_authors: [Kris Kowal]
ingested: 2026-06-02
ingested_by: scholar
section_count: 2
status: current
notes: |
  Sixteenth comment-fragment ingest. Kris Kowal-authored *Exo
  construction surface* — *the* file that defines `defineExoClass`,
  `defineExoClassKit`, and `makeExo`, the three factories that every
  exo-shaped capability in @endo and downstream code uses. Three
  structurally interesting moves: (1) the *callback-options hooks*
  pattern (`finish` / `receiveAmplifier` / `receiveInstanceTester`)
  that pass *privileged capability-references back to the host* via
  callback — the public maker function is returned normally, while
  privileged out-band capabilities flow through one-shot callbacks
  so they never leak; (2) the *state-sealed-not-frozen* discipline —
  the *Be careful not to freeze the state record* comment is
  repeated twice in the file (lines 88-89 and 174-175) as a visible
  reminder against the easy-to-violate invariant: state must remain
  mutable for method-updates; sealing prevents shape changes but
  allows value changes; context wrappers freeze *after* state and
  facets are attached; (3) the *class-vs-kit symmetry* — both
  factories follow the same shape but with single-context vs
  per-facet-context-map; the kit form uniquely supports
  *amplification* (going from one facet to all sibling facets via
  receiveAmplifier). Plus the `makeExo(tag, guard, methods, opts?)`
  singleton convenience that delegates to `defineExoClass` with
  `initEmpty` and immediate invocation.
  
  Cycle 108 papers-lane pivot to comments-lane (sixth consecutive
  papers-lane block, cycles 97/100/102/104/106/108). Single-section
  cohesion-honest ingest — the 242-line file is one *exo-construction
  factory trio* with shared idioms (callback-options, state-sealed,
  symmetric class-vs-kit). Foundational across the library: cycles
  102+104 (@endo/patterns) provide the guards consumed by these
  factories; cycles 101+103+105+107 (daemon designs) construct exo-
  shaped capabilities via these factories.
---

> Abstract: `packages/exo/src/exo-makers.js` is the *Exo construction
> surface* — *the* file that defines `defineExoClass`,
> `defineExoClassKit`, and `makeExo`, the three factories that every
> exo-shaped capability in @endo and downstream code uses. The
> opening `LABEL_INSTANCES` debug knob (driven by `DEBUG=label-
> instances` env-option) enables per-instance `Symbol.toStringTag`
> like `Tag#3`. The §`makeSelf(proto, instanceCount)` private helper
> creates + optionally labels + hardens a self-object. The
> §`emptyRecord` + `initEmpty` zero-state convenience returns the
> shared frozen empty record (for stateless exos; zero-arg makers).
> The §`defineExoClass(tag, interfaceGuard, init, methods, options?)`
> factory produces a single-facet exo class maker: WeakMap<self,
> context> bookkeeping; guarded prototype via `defendPrototype` from
> `exo-tools.js`; `makeInstance(...args)` constructs an instance via
> `seal(init(...args))` for state + `makeSelf(proto, instanceCount)`
> + frozen `context = { state, self }` + `contextMap.set(self,
> context)` + optional `finish(context)` callback. The §three
> *callback-options hooks* — `finish` (per-instance setup),
> `receiveAmplifier` (one-shot privileged amplifier; rejected for
> non-kit classes), `receiveInstanceTester` (one-shot privileged
> instance-tester) — pass privileged capability-references back to
> the host. The §`defineExoClassKit(tag, interfaceGuardKit, init,
> methodsKit, options?)` factory parallels for the multi-facet case:
> per-facet WeakMaps + prototypeKit; `makeInstanceKit(...args)`
> constructs all facets atomically with shared context;
> `amplify(exoFacet)` walks per-facet contextMaps to enable
> facet-to-siblings amplification (the privileged caretaker
> mechanism). The §`makeExo(tag, interfaceGuard, methods, options?)`
> singleton convenience delegates to `defineExoClass + initEmpty +
> immediate-invoke`. The §state-sealed-not-frozen invariant is
> repeated twice in the file as a visible reminder.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [defineExoClass-defineExoClassKit-and-makeExo-factory-trio](../sections/endo--packages-exo-src-exo-makers-js--defineExoClass-defineExoClassKit-and-makeExo-factory-trio.md) | hardened-javascript, exo | current (cycle 108; factory-trio lens) |
| [callback-receives-capability-and-state-sealed-not-frozen](../sections/endo--packages-exo-src-exo-makers-js--callback-receives-capability-and-state-sealed-not-frozen.md) | capability-discipline, seal-vs-freeze, circular-reference-via-late-binding | current (cycle 322; complementary capability-discipline lens) |

The 242-line file is honestly one cohesive argument-cluster — *one factory trio* with shared idioms (callback-options hooks, state-sealed-not-frozen, class-vs-kit symmetry). The cycle 108 ingest preserved the unified structure via a single section (the factory-trio lens); cycle 322 added a complementary section with a capability-discipline lens (callback-receives-capability + seal-vs-freeze + circular-reference-via-late-binding) that highlights *transferable patterns* rather than the construction-surface structure. **§the-named-complementary-lens-re-ingest** — two section files for one source, each taking a different framing.

## Provenance

- Fetched 2026-06-02 from `endojs/endo@e56bf00f289ff8484094b785b11636b8bc71d87e` via the local bare-clone.
- Last touched 2025-10-09 by Kris Kowal. Kris's authorship is consistent with his maintainer-role for the @endo/exo package.
- Verified file existence and structure via the local bare-clone: 242 lines / 55 comment lines (~23% comment density). The comment-density understates the structural significance because much of the file's content is structural-code (the factory bodies) rather than narrative-comments.
- **Sixteenth comment-fragment ingest**. The chosen file is *foundational across the library*:
  - **Cycles 102 + 104** `@endo/patterns/keys/checkKey.js` + `compareKeys.js` (Turadg Aleahmad) — the patterns language used as the `interfaceGuard` parameter of these factories.
  - **Cycles 101 + 103 + 105 + 107** daemon designs — every daemon capability is exo-shaped via these factories.
  - **Earlier-cycle ingests** — pass-style, marshal, eventual-send all consume or produce exo-shaped capabilities.
- Single-section cohesion-honest count. The 242-line file is *one factory trio* — the §callback-options-hooks pattern, the §state-sealed-not-frozen discipline, and the §class-vs-kit symmetry are shared across all three factories. Forcing a 3-section split (one per factory) would create artificial divides because each factory uses the same idioms.
- Cycle 108 pivoted from papers-lane (sixth consecutive papers-lane block — cycles 97 / 100 / 102 / 104 / 106 / 108) to comments-lane.
