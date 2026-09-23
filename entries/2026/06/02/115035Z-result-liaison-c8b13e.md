---
host: endolin
role: liaison
dispatch_id: c8b13e
date: 2026-06-02
kind: result
---

# result(librarian, cycle 108): exo-makers.js — defineExoClass + defineExoClassKit + makeExo factory trio (1 section)

**Cycle**: 108 (pivoted from papers-lane to comments-lane after sixth consecutive papers-lane block).
**Source**: `endojs/endo` `packages/exo/src/exo-makers.js` (242 lines), last touched 2025-10-09 by Kris Kowal.

## What

Ingested the Kris Kowal-authored *Exo construction surface* — *the* file that defines `defineExoClass`, `defineExoClassKit`, and `makeExo`, the three factories every exo-shaped capability in @endo and downstream code uses. Single-section cohesion-honest ingest.

### Section drafted

1. **defineExoClass + defineExoClassKit + makeExo factory trio** (full file, lines 1-242) — single cohesive ingest. The §opening `LABEL_INSTANCES` debug knob (driven by `DEBUG=label-instances` env-option) enables per-instance `Symbol.toStringTag` like `Tag#3`. The §`makeSelf(proto, instanceCount)` private helper creates + optionally labels + hardens a self-object. The §`emptyRecord` + `initEmpty` zero-state convenience. The §`defineExoClass(tag, interfaceGuard, init, methods, options?)` factory: WeakMap<self, context> bookkeeping; guarded prototype via `defendPrototype` from exo-tools; `makeInstance(...args)` constructs via `seal(init(...args))` for state + `makeSelf(proto, instanceCount)` + frozen `context = { state, self }` + `contextMap.set` + optional `finish(context)` callback. The §three *callback-options hooks* — `finish` (per-instance setup), `receiveAmplifier` (one-shot privileged amplifier; rejected for non-kit classes via *Only facets of an exo class kit can be amplified*), `receiveInstanceTester` (one-shot privileged instance-tester) — pass *privileged capability-references back to the host* via callback so they never leak. The §`defineExoClassKit(tag, interfaceGuardKit, init, methodsKit, options?)` parallel factory for the multi-facet case: per-facet WeakMaps + prototypeKit; `makeInstanceKit(...args)` constructs all facets atomically with shared context. The §`amplify(exoFacet)` walks per-facet contextMaps to enable facet-to-siblings amplification (the privileged caretaker mechanism). The §`makeExo(tag, interfaceGuard, methods, options?)` singleton convenience delegates to `defineExoClass + initEmpty + immediate-invoke`. The §*state-sealed-not-frozen* invariant is repeated twice in the file (lines 88-89 and 174-175) as a visible reminder.

### Library state after this cycle

- **609 sections** (was 608) / **153 sources** (was 152) / **44 concepts** (unchanged).
- Topic pages updated: `exo.md` (+1 row), `hardened-javascript.md` (+1 row).
- `library/sources/README.md` and `library/sections/README.md` updated with the new cycle group.
- `library/keywords.md` extended with ~37 exo-construction keywords (defineExoClass / defineExoClassKit / makeExo factory trio / makeSelf / LABEL_INSTANCES / DEBUG=label-instances / WeakMap self-context / defendPrototype / callback-options hooks / finish receiveAmplifier receiveInstanceTester / state-sealed-not-frozen / Be careful not to freeze the state record / amplify exoFacet / facet-to-siblings amplification / privileged caretaker mechanism / objectMap per-facet WeakMaps / callWhen transformation).

## Notes

- The §*callback-options-hooks pattern* (`finish` / `receiveAmplifier` / `receiveInstanceTester`) is structurally important: it grants *privileged capability-references* to the host via one-shot callbacks. The host gets the public maker function plus privileged out-band capabilities (amplifier, instance-tester); the privileged capabilities never leak to anyone else because they're scoped to the host's callback closure.
- The §*state-sealed-not-frozen* invariant is the single most easy-to-violate discipline in the file. The §double-comment (`Be careful not to freeze the state record` appearing twice — lines 88-89 and 174-175) is a *visible reminder*. A maintainer mechanically applying `harden` everywhere would break the invariant; the explicit comment prevents that.
- The §*class-vs-kit symmetry* — `defineExoClass` and `defineExoClassKit` follow the same shape but with single-context vs per-facet-context-map. The kit form uniquely supports *amplification* (going from one facet to all sibling facets via `receiveAmplifier`). Amplification is the privileged caretaker mechanism — the user holds a facet; the host holds the amplifier; amplification gives the host access to all sibling facets.
- The §*LABEL_INSTANCES* env-option-driven debug knob is a worked example of the *opt-in-debug-feature-via-env-option* discipline. Production runs don't enable it; debug runs label individual instances for diagnostic clarity.
- The §`makeExo` singleton convenience (`defineExoClass + initEmpty + immediate-invoke`) is a worked example of the *stateless-singleton-shorthand* pattern. Internal exos that need method-dispatch + interface-guard machinery but don't need state can be expressed in a single call.
- The §`CAVEAT: static typing does not yet support callWhen transformation` (line 227) is an honest TypeScript-limitation admission. The runtime is correct; the static types are incomplete for the callWhen (eventual-send) transformation that `M.interface()` guards can apply.

## Library-position context

This file is *foundational across the library*:

- **Cycles 102 + 104** `@endo/patterns/keys/checkKey.js` + `compareKeys.js` (Turadg Aleahmad) — the patterns language used as the `interfaceGuard` parameter of these factories.
- **Cycles 101 + 103 + 105 + 107** daemon designs — every daemon capability is exo-shaped via these factories. The cycle 107 Dir/Shell/Git capabilities are concrete consumers.
- **Earlier-cycle ingests** — pass-style, marshal, eventual-send all use exo-shaped capabilities.

This cycle adds *the construction surface* itself to the library. Earlier cycles described what exos do; this cycle describes how they're built.

## Rotation discipline

Cycle 108 was scheduled for papers-lane but pivoted to comments-lane after the *sixth consecutive papers-lane block* (cycles 97 / 100 / 102 / 104 / 106 / 108). The §rotation discipline is *cohesion-honest* not *strict round-robin*; papers-lane has been structurally hard (PDF-fetching infrastructure issue) so the rotation extends gracefully into adjacent lanes.

## Next

- Cycle 109 (chat-lane): chat-cluster exhausted. Continue with broader endo-but-for-bots designs.
- Cycle 110 (papers-lane): if fresh PDF access becomes available, retry Saltzer-Schroeder 1975 or Stiegler-Miller HPL-2006-116. Otherwise pivot again.
- Cycle 111 (comments-lane): `packages/marshal/src/marshal-justin.js` (510 lines / ~23%); `packages/patterns/src/keys/copySet.js` (109 lines); `packages/exo/src/exo-tools.js` (513 lines — the file `exo-makers.js` imports `defendPrototype` from).

ScheduleWakeup 1500s for cycle 109.
